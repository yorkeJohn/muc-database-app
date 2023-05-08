CREATE TABLE transactions (
	TransactionID INT NOT NULL,
	CustomerID INT NOT NULL,
	Charge DECIMAL(13, 2),
	Date DATE, 
	CarID INT, 
	PRIMARY KEY(TransactionID, CustomerID),
	FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID),
  FOREIGN KEY (CarID) REFERENCES cars(CarID)
) engine = innodb;	
