

USE PIZZA;
GO


/*	Ordered Sides View 
	a view that selects details of all ordered sides.
	
*/

CREATE VIEW orderedsidesview AS
	SELECT OrderID, s.SideID, SideName, QTY, SidePrice * QTY AS Total_Price
	FROM OrderedSide as os INNER JOIN Side as s
	ON os.SideID = s.SideID;

	


GO
/*	Ordered Pizzas View 
	a view that selects details of all ordered pizzas, i.e. the pizzas that have been ordered in customer orders.
	The view should contain the following columns:
		� The ordered pizza ID number, customer order ID number and �ready� column.
		� The pizza ID number and pizza name of the ordered pizza.
		� The range ID number and range name of the ordered pizza.
		� The crust ID number and crust name of the ordered pizza.
		� The sauce ID number and sauce name of the ordered pizza.
		� The cost of the pizza (add together the range price, crust surcharge and sauce surcharge)

*/





CREATE VIEW orderedpizzaview AS
	SELECT OrderedPizzaID, OrderID, op.PizzaID, PizzaName, r.RangeID, RangeName, c.CrustID, CrustName, op.SauceID, SauceName, ReadyOrNot,
	SauceSurcharge + CrustSurcharge + RangePrice AS Cost
	FROM OrderedPizza AS op INNER JOIN Pizza AS p
	ON op.PizzaID = p.PizzaID
	INNER JOIN PizzaRange AS r
	ON p.RangeID = r.RangeID
	INNER JOIN Sauce AS s
	ON op.SauceID = s.SauceID
	INNER JOIN Crust AS c
	ON op.CrustID = c.CrustID;




GO
/*	Customer Orders View
	a view that selects details of all orders.  The view should contain the following columns:
		� The customer order ID number and order date.
		� The order type column, ideally with �P� and �D� replaced with �Pickup� and �Delivery�.
		� The staff ID number and full name of the staff member who took the order.
		� The staff ID number and full name of the staff member who delivered the order.
		� The customer name, phone number and address.

*/

CREATE VIEW detailedordersview AS
	SELECT OrderID, DateAndTime, Replace(Replace(OrderType,'P', 'Pickup'),'D', 'Delivery') AS OrderType,
	so.StaffID AS TakenBy, CONCAT(ts.StaffFirstName, ' ', ts.StaffLastName) AS TakerName, DeliveryStaffID, CONCAT(ds.StaffFirstName, ' ', ds.StaffLastName) AS DeliveryName,
	CustName, CustNumber, CustAddress
	FROM StoreOrder AS so INNER JOIN Staff AS ts
	ON so.StaffID = ts.StaffID
	LEFT OUTER JOIN Staff AS ds
	ON so.DeliveryStaffID = ds.StaffID;



GO

