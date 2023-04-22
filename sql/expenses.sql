CREATE TABLE rent_cost (
	Year YEAR NOT NULL,
	RentCost DECIMAL(13, 2),
	PRIMARY KEY (Year)
) engine = innodb;

CREATE TABLE monthly_expenses (
	Year YEAR NOT NULL,
	Month INT NOT NULL,
	ElectricCost DECIMAL(13, 2),
	WaterCost DECIMAL(13, 2),
	HeatCost DECIMAL(13, 2),
	PRIMARY KEY (Year, Month),
	FOREIGN KEY (Year) REFERENCES rent_cost(Year) 
) engine = innodb;


