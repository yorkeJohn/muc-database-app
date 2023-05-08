CREATE TABLE cars (
  CarID INT NOT NULL,
  PlateNumber VARCHAR(7),
  Province VARCHAR(25),
  Colour VARCHAR(255),
  Year YEAR,
  Make VARCHAR(255),
  Model VARCHAR(255),
  Type VARCHAR(255),
  PRIMARY KEY(CarID)
) engine = innodb;

CREATE TABLE car_purchases (
  PurchaseID INT NOT NULL,
  CustomerID INT NOT NULL,
  Price DECIMAL(13, 2),
  Date DATE, 
  CarID INT, 
  PRIMARY KEY(PurchaseID, CustomerID),
  FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID),
  FOREIGN KEY (CarID) REFERENCES cars(CarID)
) engine = innodb;

CREATE TABLE cars_for_sale (
  CarID INT NOT NULL,
  Price DECIMAL(13, 2),
  Kilometres INT,
  PurchaseID INT,
  PRIMARY KEY(CarID),
  FOREIGN KEY (CarID) REFERENCES cars(CarID),
  FOREIGN KEY (PurchaseID) REFERENCES car_purchases(PurchaseID)
) engine = innodb;

CREATE TABLE car_sales (
  SaleID INT NOT NULL,
  CustomerID INT NOT NULL,
  Price DECIMAL(13, 2),
  Date DATE, 
  CarID INT,
  PRIMARY KEY(SaleID, CustomerID),
  FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID),
  FOREIGN KEY (CarID) REFERENCES cars_for_sale(CarID)
) engine = innodb;