CREATE TABLE customers (
  CustomerID INT NOT NULL,
  FirstName VARCHAR(255),
  LastName VARCHAR(255),
  Address VARCHAR(255),
  PhoneCell VARCHAR(20),
  PhoneOther VARCHAR(20),
  PRIMARY KEY(CustomerID)
) engine = innodb;
