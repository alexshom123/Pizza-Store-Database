
USE PIZZA;

/*	Query 1 � 
	a query that selects the pizza and range name concatenated into �pizza_name (range_name)� format and given an alias of �pizza�, 
	as well as the pizza description and range price of all pizzas.  Order the results by price, then pizza name.
*/


--p = pizza and r = range
SELECT CONCAT(PizzaName, ' (', RangeName, ')') AS Pizza, PizzaDesc, RangePrice
FROM Pizza AS p LEFT OUTER JOIN PizzaRange AS r
ON p.RangeID = r.RangeID
ORDER BY RangePrice, PizzaName





/*	Query 2 � Staff Search 
	a query that selects the staff ID number, full name and date of birth of staff members who do not have a supervisor 
	and are less than 21 years old (calculated using the current date).  Order the results by first name.
*/

SELECT StaffID, CONCAT(StaffFirstName, ' ', StaffLastName) AS 'Full Name', DOB
FROM Staff
WHERE (SuperViserID IS NULL) AND DATEDIFF(year, DOB, GETDATE()) < 21
Order BY StaffFirstName;




/*	Query 3 � Popular Budget Pizzas 
	Write a query that selects the names of the top three most ordered pizzas from the �Budget� range, and the number of times they have each been ordered.

*/

SELECT TOP (3) PizzaName, COUNT(PizzaName) AS 'Times Ordered'
FROM orderedpizzaview
WHERE RangeID = 1
GROUP BY PizzaName
Order BY 'Times Ordered' DESC; --NOTE**** I ordered by Times Ordered Because it makes sense to me : )



/*	Query 4 � Side Statistics 
	a query that selects the following details about the sides that have been ordered in orders:
		� The side ID number and side name.
		� How many orders the side has been ordered in (regardless of quantity).
		� The average quantity in which the side is ordered (rounded to 2 decimal places).
		� The total sale cost of the side (remember to take the quantity into account).

*/


SELECT SideName, COUNT(QTY) AS 'TimesOrdered', ROUND(AVG(CAST(QTY AS FLOAT)),2) AS 'Avg Qty Order', (SidePrice * SUM(QTY)) AS TotalCost
FROM Side AS s INNER JOIN OrderedSide AS os
ON s.SideID = os.SideID
GROUP BY SideName, SidePrice
ORDER BY TotalCost DESC;





/*	Query 5 � Younger Supervisors 
	a query that selects the ID number, full name and date of birth of staff and the 
	ID number, full name and date of birth of their supervisor for any staff who are being supervised by someone younger than themselves.
*/


SELECT y.StaffID AS StaffID, CONCAT(y.StaffFirstName, ' ', y.StaffLastName) AS StaffName, y.DOB AS StaffDOB,
o.StaffID As SuperviserID, CONCAT(o.StaffFirstName, ' ', o.StaffLastName) AS SuperviserName,  o.DOB AS SuperviserDOB
FROM Staff AS o INNER JOIN Staff AS y
ON o.StaffID = y.SuperviserID
WHERE y.DOB < o.DOB; 





/*	Query 6 � Unready Pizzas 
	 a query that selects order date, pizza name, crust name and sauce name of any ordered pizzas which are not ready 
	(the �ready� column contains �N�), as well as the order type (�P�/�Pickup� or �D�/�Delivery�) and the number of minutes between the order date and the current time.
	Order the results by the order date.

*/


SELECT DateAndTime, PizzaName, CrustName, SauceName, DATEDIFF(Minute, DateAndTime, GETDATE()) AS 'ElapsedMins',
Replace(Replace(OrderType,'P', 'Pickup'),'D', 'Delivery') AS OrderType
FROM orderedpizzaview AS opv INNER JOIN StoreOrder AS so
ON opv.OrderID = so.OrderID
WHERE ReadyOrNot = 'N'
ORDER BY DateAndTime;





/*	Query 7 � Staff Workload 
	a query that selects the full name of all staff members, the number of orders they have taken and the number of orders they have delivered.
	Ensure that all staff members are included in the results, even those who have not taken or delivered any orders.
	Order the results by the staff ID number.

*/

SELECT od.StaffID, od.FullName, ot.OrdersTaken, od.OrdersDelivered
FROM (SELECT s.StaffID, CONCAT(s.StaffFirstName, ' ', s.StaffLastName) AS 'FullName', COUNT(so.StaffID) AS 'OrdersTaken'
	  FROM Staff AS s LEFT OUTER JOIN StoreOrder AS so
	  ON s.StaffID = so.StaffID
	  GROUP BY s.StaffID, s.StaffFirstName, s.StaffLastName) AS ot
INNER JOIN 
	 (SELECT s.StaffID, CONCAT(s.StaffFirstName, ' ', s.StaffLastName) AS 'FullName', COUNT(DISTINCT so.DeliveryStaffID) AS 'OrdersDelivered'
	  FROM Staff AS s LEFT OUTER JOIN StoreOrder AS so
	  ON s.StaffID = so.DeliveryStaffID
	  GROUP BY s.StaffID, s.StaffFirstName, s.StaffLastName) AS od
ON ot.StaffID = od.StaffID;



/*	Query 8 � Orders Awaiting Delivery 
	a query that selects the customer order ID number, order date, customer name and customer address of any �Delivery� orders 
	which have not been delivered yet (delivery foreign key is NULL) and all the pizzas in the order are ready (�ready� column contains �Y�).
	Order results by order date.

*/

SELECT so.OrderID, so.DateAndTime, so.CustName, so.CustAddress
FROM StoreOrder AS so
LEFT JOIN (SELECT DISTINCT op.OrderID
		   FROM OrderedPizza AS op
		   WHERE op.ReadyOrNot = 'N') AS op
ON so.OrderID = op.OrderID
WHERE op.OrderID IS NULL AND so.DeliveryStaffID IS NULL AND so.OrderType = 'D'
ORDER BY DateAndTime; 



/*	Query 9 � Customer Order Summary (5 marks)
	a query that selects the following information for all orders:
	� The customer order ID number, order date and customer name.
	� The staff ID number and full name of the staff member who took the order.
	� The total cost of pizzas in the order, total cost of sides in the order, and total cost of entire order (i.e. the cost of all pizzas and all sides in the order).

	Order results by the total order cost in descending order, and ensures that the total order cost is calculated correctly even if an order did not contain any sides or any pizzas.

*/


SELECT so.OrderID, so.DateAndTime, so.CustName, so.StaffID, CONCAT(s.StaffFirstName, ' ', s.StaffLastName) AS StaffName,
pd.tpc AS TotalPizzaCost, sd.tcs AS TotalSideCost, pd.tpc + sd.tcs AS TotalCost
FROM StoreOrder AS so INNER JOIN Staff AS s 
ON so.StaffID = s.StaffID 
INNER JOIN (SELECT op.OrderID, SUM(pr.RangePrice+c.CrustSurcharge+sa.SauceSurcharge) AS tpc
			FROM OrderedPizza AS op INNER JOIN Pizza AS p 
			ON op.PizzaID = p.PizzaID INNER JOIN PizzaRange AS pr 
			ON p.RangeID = pr.RangeID INNER JOIN Crust AS c 
			ON op.CrustID = c.CrustID INNER JOIN Sauce AS sa 
			ON sa.SauceID = op.SauceID
			GROUP BY op.OrderID) AS pd 
ON pd.OrderID = so.OrderID
INNER JOIN (SELECT so.OrderID, SUM(os.QTY*si.SidePrice) AS tcs
			FROM StoreOrder AS so INNER JOIN OrderedSide AS os 
			ON os.OrderID = so.OrderID INNER JOIN Side AS si 
			ON si.SideID = os.SideID
			GROUP BY so.OrderID) AS sd 
ON sd.OrderID = so.OrderID
ORDER BY TotalCost DESC;

