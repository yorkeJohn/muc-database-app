/* app server */
require("dotenv").config();
const express = require("express");
const path = require("path");
const bodyParser = require("body-parser");
const mysql = require("mysql2/promise");

/* app */
const app = express();

app.use(express.static(path.join(__dirname, "public")));
app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());
app.set("view engine", "ejs");

/* Connection to MySQL */
const pool = mysql.createPool({
  connectionLimit: 10,
  host: "127.0.0.1",
  user: process.env.SQL_USER,
  password: process.env.SQL_PASS,
  database: process.env.SQL_DB,
  dateStrings: true,
});

/* SQL query function */
const query = async (sql, args) => {
  try {
    const [results] = await pool.query(sql, args);
    return results;
  } catch (error) {
    console.log(`MySQL Error: ${error}`);
  }
};

/* helper functions */
const flatten = data => data.map(Object.values);
const cadFormat = new Intl.NumberFormat("en-CA", { style: "currency", currency: "CAD" });
const isValid = param => typeof param === 'string';
const allValid = params => params.every(isValid);

/* start app */
const port = process.env.NODE_PORT || 3000;
app.listen(port, () => {
  console.log(`App listening on port ${port}`);
});

/* home page */
app.get("/", async function (req, res) {
  res.render(path.join(__dirname, "views/home"));
});

/* view data */
app.get("/viewdata", async function (req, res) {
  let tables = flatten(await query("SHOW TABLES", process.env.SQL_DB)).flat();
  let tableName = req.query.table;
  if (isValid(tableName) && tables.includes(tableName)) {
    const headerQuery = `
      SELECT COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS 
      WHERE TABLE_NAME=? 
      ORDER BY ORDINAL_POSITION
    `;
    let tableHeader = await query(headerQuery, tableName);
    let tableData = await query(`SELECT * FROM ${tableName}`);

    let body = {
      tableHeader: flatten(tableHeader),
      tableData: flatten(tableData),
      title: `Showing table <b>${tableName}</b>`,
      backURL: "/viewdata"
    };
    res.render(path.join(__dirname, "views/show_table"), body);
  } else {
    res.render(path.join(__dirname, "views/view_data"), { tables: tables });
  }
});

/* add supplier */
app.get("/addsupplier", async function (req, res) {
  let { id, name, email, phones } = req.query;
  if (allValid([id, name, email, phones])) {
    const supplierQuery = `INSERT INTO suppliers (SupplierID, Name, Email) VALUES (?, ?, ?)`;
    await query(supplierQuery, [id, name, email]);

    const regex = /\d{1,3}-\(\d{3}\)\d{3}-\d{4}/g; // xxx-(xxx)xxx-xxxx
    phones = phones.match(regex).map(num => [num, id]);
    const phoneQuery = `INSERT INTO supplier_phones (PhoneNumber, SupplierID) VALUES (?, ?)`;
    await Promise.all(phones.map(num => query(phoneQuery, num)));

    const newSupplierQuery = `
      SELECT suppliers.SupplierID, Name, Email, GROUP_CONCAT(DISTINCT PhoneNumber SEPARATOR '\n') as PhoneNumbers FROM suppliers
      JOIN supplier_phones ON suppliers.SupplierID = supplier_phones.SupplierID
      WHERE suppliers.SupplierID = ?
      GROUP BY suppliers.SupplierID
    `;
    let tableData = flatten(await query(newSupplierQuery, id));

    let body = {
      tableHeader: ["SupplierID", "Name", "Email", "Phone Numbers"],
      tableData: tableData,
      title: `New supplier <b>${id}</b>`,
      backURL: "/addsupplier"
    };
    res.render(path.join(__dirname, "views/show_table"), body);
  } else {
    res.render(path.join(__dirname, "views/add_supplier"));
  }
});

/* expenses report */
app.get("/expenses", async function (req, res) {
  let { yearStart, yearEnd } = req.query;
  if (allValid([yearStart, yearEnd]) && parseInt(yearStart) <= parseInt(yearEnd)) {
    const expensesQuery = `
      SELECT YEAR(orders.date) as year, SUM(parts.price * order_parts.quantity) AS expenses FROM orders 
      JOIN order_parts ON orders.orderID=order_parts.orderID 
      JOIN parts ON order_parts.partID=parts.partID 
      WHERE YEAR(orders.date) BETWEEN ? AND ? 
      GROUP BY YEAR(orders.date)
    `;
    let tableData = flatten(await query(expensesQuery, [yearStart, yearEnd]));

    tableData = tableData.flatMap(([year, expenses]) => [[year, cadFormat.format(expenses)]]);

    let body = {
      tableHeader: ["Year", "Expenses"],
      tableData: tableData,
      title: `Expenses report for <b>${yearStart} - ${yearEnd}</b>`,
      backURL: "/expenses"
    };
    res.render(path.join(__dirname, "views/show_table"), body);
  } else {
    let minYearQuery = `SELECT MIN(YEAR(orders.date)) as year FROM orders`;
    let minYear = flatten(await query(minYearQuery)).flat()[0];
    res.render(path.join(__dirname, "views/expenses"), { minYear: minYear });
  }
});

/* budget projection */
app.get("/budget", async function (req, res) {
  let { years, inflation } = req.query;
  if (allValid([years, inflation])) {
    const budgetQuery = `
      SELECT SUM(parts.price * order_parts.quantity) AS expenses FROM orders
      JOIN order_parts ON orders.orderID=order_parts.orderID
      JOIN parts ON order_parts.partID=parts.partID
      WHERE YEAR(orders.date) = ?
      GROUP BY YEAR(orders.date)
    `;
    let year = new Date().getFullYear();
    let base = flatten(await query(budgetQuery, year - 1)).flat()[0];
    let tableData = [[year - 1, base]];

    for (let i = 0; i < Number(years); i++) {
      let inflatedValue = base * (1 + Number(inflation) / 100) ** (i + 1);
      tableData.push([year++, inflatedValue]);
    }

    tableData = tableData.flatMap(([year, budget]) => [[year, cadFormat.format(budget)]]);

    let body = {
      tableHeader: ["Year", "Budget"],
      tableData: tableData,
      title: `Budget projection for <b>${years} years @ ${inflation}% inflation</b>`,
      backURL: "/budget"
    };
    res.render(path.join(__dirname, "views/show_table"), body);
  } else {
    res.render(path.join(__dirname, "views/budget"));
  }
});
