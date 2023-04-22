CREATE TABLE parts (
	PartID INT NOT NULL,
	Price DOUBLE(10, 2),
	Description VARCHAR(50),
	PRIMARY KEY(PartID)
) engine = innodb;

CREATE TABLE suppliers (
	SupplierID INT NOT NULL,
	Name VARCHAR(255),
	Email VARCHAR(255),
	PRIMARY KEY(SupplierID)
) engine = innodb;

CREATE TABLE supplier_phones (
	PhoneNumber VARCHAR(20) NOT NULL,
	SupplierID INT,
	PRIMARY KEY(PhoneNumber),
	FOREIGN KEY (SupplierID) REFERENCES suppliers(SupplierID)
) engine = innodb;

CREATE TABLE orders (
	OrderID INT NOT NULL,
	SupplierID INT,
	Date DATE,
	PRIMARY KEY(OrderID),
	FOREIGN KEY (SupplierID) REFERENCES suppliers(SupplierID)
) engine = innodb;

CREATE TABLE order_parts (
	OrderID INT NOT NULL,
	PartID INT NOT NULL,
	Quantity INT,
	PRIMARY KEY(OrderID, PartID),
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
	FOREIGN KEY (PartID) REFERENCES parts(PartID)
) engine = innodb;


