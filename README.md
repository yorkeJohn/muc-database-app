# MUC Database
This app was originally created as a part of CSCI 3461 - Database Systems at [Saint Mary's University](https://smu.ca).

# Project Description
MUC is a national company specializing in used cars. Customers can buy cars, sell cars, and get repairs.
### Objectives
* Design a relational database schema (EER and schema diagrams)
* Create tables and fill them with data from JSON files
* Develop and present a web application

# Web App Requirements
* View Data: the user selects the name of a table, and the application displays the contents of that table.
* Add New Supplier: the user enters a new supplier's attributes, the application inserts the corresponding rows into the database. The app should consider the case where the new supplier cannot be inserted.
* Annual Expenses for Parts: the user enters a start year and an end year, the application shows the total amount paid for parts in each year.
* Budget Projection: the user enters a number of years and an inflation rate value (e.g, 2%). The application displays the total amount that would be spent in each of the next years by applying inflation (starting after the most recent full year).
