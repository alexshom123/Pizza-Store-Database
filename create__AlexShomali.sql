

-- creation script here
IF DB_ID('PIZZA') IS NOT NULL             
BEGIN
    PRINT 'Database exists - dropping.';
		
    USE master;		
    ALTER DATABASE PIZZA SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
		
    DROP DATABASE PIZZA;
END
GO

--  Now that we are sure the database does not exist, we create it.
PRINT 'Creating database.';
CREATE DATABASE PIZZA;
GO

--  Now that an empty database has been created, we will make it the active one.
--  The table creation statements that follow will therefore be executed on the newly created database.
USE PIZZA;
GO

CREATE TABLE Staff(
	StaffID INT IDENTITY CONSTRAINT staff_pk PRIMARY KEY NOT NULL,
	StaffFirstName VARCHAR(50) NOT NULL,
	StaffLastName VARCHAR(50) NOT NULL,
	SuperviserID INT NULL FOREIGN KEY REFERENCES Staff(StaffID),
	DOB DATE NOT NULL,
	Staffphone VARCHAR(50) NOT NULL
);

CREATE TABLE StoreOrder(
	OrderID INT NOT NULL IDENTITY CONSTRAINT order_pk PRIMARY KEY,
	StaffID INT NOT NULL FOREIGN KEY REFERENCES Staff(StaffID),
	DeliveryStaffID INT NULL FOREIGN KEY REFERENCES Staff(StaffID),
	DateAndTime DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
	CustName VARCHAR(50) NOT NULL,
	CustAddress VARCHAR(100) NULL,
	CustNumber VARCHAR(20) NULL,
	OrderType CHAR(1) NOT NULL CHECK(OrderType IN ('P', 'D')),
	CHECK((StoreOrder.OrderType = 'P' AND StoreOrder.DeliveryStaffID IS NULL) OR (StoreOrder.OrderType = 'D' AND StoreOrder.CustAddress IS NOT NULL))
);

CREATE TABLE Crust(
	CrustID TINYINT IDENTITY CONSTRAINT crust_pk PRIMARY KEY NOT NULL,
	CrustName VARCHAR(25) NOT NULL UNIQUE,
	CrustSurcharge MONEY NOT NULL DEFAULT 0
);

CREATE TABLE Sauce(
	SauceID TINYINT IDENTITY CONSTRAINT sauce_pk PRIMARY KEY NOT NULL,
	SauceName VARCHAR(50) NOT NULL UNIQUE,
	SauceSurcharge MONEY NOT NULL DEFAULT 0
);

CREATE TABLE PizzaRange(
	RangeID TINYINT IDENTITY CONSTRAINT range_pk PRIMARY KEY NOT NULL,
	RangeName VARCHAR(25) NOT NULL UNIQUE,
	RangePrice MONEY NOT NULL
);

CREATE TABLE Pizza(
	PizzaID TINYINT IDENTITY CONSTRAINT pizza_pk PRIMARY KEY NOT NULL,
	PizzaName VARCHAR(50) NOT NULL UNIQUE,
	PizzaDesc VARCHAR(100) NOT NULL,
	RangeID TINYINT NOT NULL FOREIGN KEY REFERENCES PizzaRange(RangeID) 
);

CREATE TABLE OrderedPizza(
	OrderedPizzaID INT IDENTITY CONSTRAINT orderedpizza_pk PRIMARY KEY NOT NULL,
	OrderID INT NOT NULL FOREIGN KEY REFERENCES StoreOrder(OrderID),
	PizzaID TINYINT NOT NULL FOREIGN KEY REFERENCES Pizza(PizzaID),
	CrustID TINYINT NOT NULL FOREIGN KEY REFERENCES Crust(CrustID),
	SauceID TINYINT NOT NULL FOREIGN KEY REFERENCES Sauce(SauceID),
	ReadyOrNot CHAR(1) NOT NULL CHECK(ReadyOrNot IN ('Y', 'N')) DEFAULT 'N'
);

CREATE TABLE Side(
	SideID TINYINT IDENTITY CONSTRAINT side_pk PRIMARY KEY NOT NULL,
	SideName VARCHAR(25) NOT NULL UNIQUE,
	SidePrice MONEY NOT NULL
);

CREATE TABLE OrderedSide(
	OrderID INT NOT NULL,
	SideID TINYINT NOT NULL,
	QTY TINYINT NOT NULL,
	CONSTRAINT orderedside_pk Primary Key (OrderID, SideID)
);







/

/*	The following statement inserts the details of 3 pizza ranges into a table named "pizza_range".  It specifies values "range_name" and "range_price" columns.
	Range ID numbers numbers are not specified since it is assumed that an auto-incrementing integer is being used.
	
*/

INSERT INTO PizzaRange (RangeName, RangePrice)
VALUES	('Budget', 7.50), --PizzaRange 1
		('Traditional', 11.50), --PizzaRange 2
		('Gourmet', 15.50), --PizzaRange 3
		('Broke', 1.50), --PizzaRange 4
		('Golden', 100.50), --PizzaRange 5
		('Bigger Budget', 8.50), --PizzaRange 6
		('Tasteful', 23.50), --PizzaRange 7
		('Normal', 12.50), --PizzaRange 8
		('Better Than Normal', 13.50), --PizzaRange 9
		('Tight Budget', 6.50); --PizzaRange 10		    



/*	The following statement inserts the details of 9 pizzas into a table named "pizza".  It specifies values for "pizza_name", "pizza_desc" and "range_id" columns.
	Pizza ID numbers numbers are not specified since it is assumed that an auto-incrementing integer is being used.
	
*/

INSERT INTO Pizza (PizzaName, PizzaDesc, RangeID) 
VALUES	('Classic Cheese', 'Who needs toppings?', 1), --Pizza 1									
		('Hawaiian', 'A ham and pineapple classic.', 1), --Pizza 2							
		('Pepperoni', 'Slices of pepperoni all over.', 1), --Pizza 3							
		('Meatlovers', 'Covered in cheap processed meat.  Best with BBQ sauce.', 2), --Pizza 4	
		('Supreme', 'Meat AND vegetables - a balanced meal!', 2), --Pizza 5					
		('Vegetarian', 'Various vegetables and a handful of wilted spinach.', 2), --Pizza 6		
		('BBQ Duck and Asparagus', 'Sweet duck breast and seasoned asparagus.', 3),	--Pizza 7	
		('Pulled Pork and Pear', 'Slow-cooked pulled pork and fresh pear slices.', 3), --Pizza 8	
		('Wagyu Beef and Prawn', 'Tender slices of beef and tiger prawns.', 3); --Pizza 9			



/*	The following statement inserts the details of 4 crusts into a table named "crust".  It specifies values for "crust_name" and "crust_surcharge" columns.
	Crust ID numbers numbers are not specified since it is assumed that an auto-incrementing integer is being used.
*/

INSERT INTO Crust (CrustName, CrustSurcharge)
VALUES	('Thick Crust', 0.00), --Crust 1			
		('Thin Crust', 0.00), --Crust 2			
		('Deep Pan Crust', 1.00), --Crust 3		
		('Crunchy Crust', 2.00), --Crust 4	
		('Chocolate Crust', 3.00), --Crust 5	
		('Sauce-Stuffed Crust', 2.00), --Crust 6	
		('Cheese-Stuffed Crust', 1.50); --Crust	7	
		


/*	The following statement inserts the details of 4 sauces into a table named "sauce".  It specifies values for "sauce_name" and "sauce_surcharge" columns.
	Sauce ID numbers numbers are not specified since it is assumed that an auto-incrementing integer is being used.
*/

INSERT INTO Sauce (SauceName, SauceSurcharge)
VALUES	('Pizza Sauce', 0.00), --Sauce 1						
		('BBQ Sauce', 0.00), --Sauce 2						
		('Ranch', 1.00), --Sauce 3 								
		('Mayonaise', 1.00), --Sauce 4 
		('Sweet and Sour', 2.50), --Sauce 5 
		('Traditional Italian Pesto', 1.00), --Sauce 6
		('New Ranch', 1.50), --Sauce 7
		('Garlic and Red Wine Tomato Chutney', 2.00); --Sauce 8	



/*	The following statement inserts the details of 6 sides into a table named "side".  It specifies values for "side_name" and "side_price" columns.
	Side ID numbers numbers are not specified since it is assumed that an auto-incrementing integer is being used.
*/

INSERT INTO Side (SideName, SidePrice)	
VALUES  ('390ml Coke', 3.00), --Side 1		
		('390ml Fanta', 3.00), --Side 2
		('390ml Sprite', 3.00), --Side 3
		('390ml Mountain Dew', 3.00), --Side 4
		('1.25l Coke', 5.00), --Side 5			
		('1.25l Fanta', 5.00), --Side 6
		('1.25l Sprite', 5.00), --Side 7
		('1.25l Mountain Dew', 5.00), --Side 8
		('Lava Cake', 2.95), --Side 9			
		('Chicken Wings', 3.50), --Side 10		
		('Garlic Bread', 1.95), --Side 11
		('Onion Rings', 2.95), --Side 12
		('Wedges', 3.95), --Side 13			
		('Healthy Kale Chips', 5.50); --Side 14	




-- Insert statements

INSERT INTO Staff (StaffFirstName, StaffLastName, SuperviserID, DOB, Staffphone)
VALUES	('Alex', 'Shomali', Null, '05-02-2001', '04425345'),  --Staff ID 1
		('Billy', 'Jean', Null, '07-02-2003', '04526365'), --Staff ID 2
		('Eric', 'Cartman', 1, '06-02-1923', '0425345'),  --Staff ID 3
		('Jeffrey', 'Dalmer', 1, '12-01-2003', '04322249'),  --Staff ID 4
		('Greg', 'Baatard', Null, '07-02-2001', '04425345'),  --Staff ID 5
		('Frodo', 'Baggins', 2, '03-02-1989', '04125245'),  --Staff ID 6
		('Mario', 'Mario', 2, '05-02-1973', '93422245'),  --Staff ID 7
		('Luigi', 'Mario', 3, '11-02-2014', '93423452'),  --Staff ID 8
		('Jon', 'Snow', Null, '10-02-1934', '04325235'),  --Staff ID 9
		('Donkey', 'Kong', 6, '06-22-1955', '04222235'),  --Staff ID 10
		('Karate', 'Kid', 4, '04-12-1992', '04355335'),  --Staff ID 11
		('Nikola', 'Tesla', 2, '11-02-2001', '04927635'),  --Staff ID 12
		('Elon', 'Musk', Null, '04-04-1978', '04325237'),  --Staff ID 13
		('Freddy', 'Mercury', 4, '11-11-2001', '04325235'),  --Staff ID 14
		('Jennifer', 'Lawrence', 6, '02-02-1944', '04322235'),  --Staff ID 15
		('Tyrion', 'Lannister', 7, '02-11-1977', '33434345');  --Staff ID 16
		
INSERT INTO StoreOrder (StaffID, DeliveryStaffID, DateAndTime, CustName, CustAddress, CustNumber, OrderType)
VALUES	(1, NULL, '2020-05-12 03:02:29.500', 'Newton', '15 Helmsdeep Way', '9342342', 'D'), --Staff 1
		(1, NULL, '2020-05-12 03:02:29.500', 'Euler', NULL, '9342342', 'P'), --Staff 2
		(5, 10, '2020-05-12 05:01:22.100', 'Bernouli', '12 GiveMeAnA Street', NULL, 'D'), --Staff 3
		(12, NULL, '2020-05-12 02:01:19.400', 'Tesla', '93 Perth Way', '0442342', 'P'), --Staff 4
		(6, NULL, '2020-05-12 05:01:22.100', 'Laplace', '16 Monkey Road', NULL, 'D'), --Staff 5
		(5, 9, '2020-05-12 03:06:22.100', 'Fourier', '17 Monkey Road', '4342342', 'D'), --Staff 6
		(15, NULL, '2020-05-12 06:06:26.800', 'Feynman', NULL, NULL, 'P'), --Staff 7
		(3, NULL, '2020-05-12 04:08:12.900', 'Einstein', '4 Berkley Way', NULL, 'P'), --Staff 8
		(15, NULL, '2020-05-12 02:02:24.400', 'Maxwell', NULL, '04323233', 'P'), --Staff 9
		(16, NULL, '2020-05-12 02:02:22.200', 'Pythagoras', '89 Portal Road', NULL, 'D'), --Staff 10
		(4, 7, '2020-05-12 03:02:26.100', 'De Movre', '15 KarstElbow Road', '0411342', 'D'), --Staff 11
		(2, 10, '2020-05-12 05:01:22.100', 'Stoke', '16 KarstElbow Road', '0413349', 'D'), --Staff 12
		(1, NULL, '2020-05-12 01:02:12.100', 'Gauss', NULL, '9342342', 'P'), --Staff 13
		(1, 8, '2020-05-12 01:01:11.100', 'Ampere', '11 Rainbow Road', '0413999', 'D'), --Staff 14
		(5, NULL, '2020-05-12 06:06:26.800', 'Schrodinger', NULL, '9342342', 'P'), --Staff 15
		(10, 2, '2020-05-12 06:06:26.800', 'Hamilton', '12 Milk Way', '0411119', 'D'), --Staff 16
		(10, NULL, '2020-05-12 06:06:26.600', 'Lagrange', NULL, '0455542', 'P'); --Staff 17				
			
INSERT INTO OrderedPizza (OrderID, PizzaID, CrustID, SauceID, ReadyOrNot)
VALUES	(1, 1, 7, 1, 'Y'), --OrderedPizza 1 
		(2, 1, 7, 5, 'Y'), --OrderedPizza 2
		(3, 4, 1, 3, 'Y'), --OrderedPizza 3
		(4, 3, 2, 2, DEFAULT), --OrderedPizza 4
		(5, 2, 3, 5, DEFAULT), --OrderedPizza 5
		(6, 5, 4, 6, DEFAULT), --OrderedPizza 6
		(7, 6, 4, 7, 'Y'), --OrderedPizza 7
		(8, 1, 5, 7, DEFAULT), --OrderedPizza 8
		(9, 5, 1, 8, DEFAULT), --OrderedPizza 9
		(10, 9, 6, 1, 'Y'), --OrderedPizza 10
		(5, 9, 7, 1, DEFAULT), --OrderedPizza 11
		(3, 2, 4, 3, 'Y'), --OrderedPizza 12
		(2, 2, 1, 6, DEFAULT), --OrderedPizza 13
		(14, 2, 2, 6, DEFAULT), --OrderedPizza 14
		(15, 3, 3, 4, DEFAULT), --OrderedPizza 15
		(16, 1, 1, 1, DEFAULT), --OrderedPizza 16
		(17, 2, 2, 2, DEFAULT), --OrderedPizza 17
		(8, 6, 2, 4, DEFAULT); --OrderedPizza 18
		
INSERT INTO OrderedSide(OrderID, SideID, QTY)
VALUES	(1, 11, 1), --OrderedSide 1
		(11, 4, 1), --OrderedSide 2
		(5, 3, 2), --OrderedSide 3
		(3, 3, 5), --OrderedSide 4
		(2, 7, 2), --OrderedSide 5
		(9, 8, 1), --OrderedSide 6
		(8, 1, 3), --OrderedSide 7
		(11, 9, 3), --OrderedSide 8
		(2, 5, 1), --OrderedSide 9
		(12, 1, 1), --OrderedSide 10
		(13, 2, 3), --OrderedSide 11
		(16, 1, 1), --OrderedSide 12
		(17, 4, 4), --OrderedSide 13
		(6, 6, 2);	--OrderedSide 14				

