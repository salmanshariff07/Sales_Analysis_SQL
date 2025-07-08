Select Top 100 * from Categories

Select Top 100  * from Customers

Select Top 100  * from Employees

Select Top 100 [Order Details].ProductID from [Order Details]

Select Top 100  * from Orders

Select Top 100  * from Suppliers

Select Top 100  * from Products

Select Top 100 * from Shippers

/*Report 1 - Total Sales by Category*/

--Step 1
Select OD.OrderID, OD.ProductID, 
	OD.UnitPrice * OD.Quantity * (1-OD.Discount) as [Sales Amount] 
from [Order Details] as OD


--Step 2
Select OD.OrderID, OD.ProductID, CC.CategoryName,
	OD.UnitPrice * OD.Quantity * (1-OD.Discount) as [Sales Amount] 
from [Order Details] as OD
left join Products as PD 
	on PD.ProductID = OD.ProductID
left join Categories as CC 
	on PD.CategoryID = CC.CategoryID


--Step 3
Select MyTable1.CategoryName, 
	round(Sum(MyTable1.[Sales Amount]),0) 
		as TotalSales from
				(Select CC.CategoryName,
					OD.UnitPrice * OD.Quantity * (1-OD.Discount) as [Sales Amount] 
				from [Order Details] as OD
				left join Products as PD 
					on PD.ProductID = OD.ProductID
				left join Categories as CC 
					on PD.CategoryID = CC.CategoryID) 
				as MyTable1
Group by MyTable1.CategoryName


/*Report 2 - Total Sales by Employee (Last Name) by Year
Step 1*/
Select OD.OrderID, 
	OD.UnitPrice * OD.Quantity * (1-OD.Discount) as [Sales Amount] 
from [Order Details] as OD


--Step 2
Select OD.OrderID, EE.LastName, ODR.OrderDate,
	OD.UnitPrice * OD.Quantity * (1-OD.Discount) as [Sales Amount] 
from [Order Details] as OD

left join Orders as ODR 
	on ODR.OrderID = OD.OrderID
left join Employees as EE 
	on EE.EmployeeID = ODR.EmployeeID


--Step 3
Select MyTable1.LastName, year(MyTable1.OrderDate) as OrderYear
	, round(sum(MyTable1.[Sales Amount]),2) 
		as TotalSales FROM
			(Select OD.OrderID, EE.LastName, ODR.OrderDate,
				OD.UnitPrice * OD.Quantity * (1-OD.Discount) as [Sales Amount] 
			from [Order Details] as OD

			left join Orders as ODR 
				on ODR.OrderID = OD.OrderID
			left join Employees as EE 
				on EE.EmployeeID = ODR.EmployeeID) 
			as MyTable1
Group by MyTable1.LastName,
		year(MyTable1.OrderDate)
Order By MyTable1.LastName, OrderYear

/*Report 3 - No Of Sale Transactions by Shipper Company*/

--Step 1
Select SS.CompanyName, 
	(Select Count(*) from Orders as OD where OD.ShipVia = SS.ShipperID) as NumberOfShipments 
FROM Shippers as SS


/*Report 4 - List of Products Supplied by Country*/

--Step 1
Select SS.Country, PD.ProductName 
from Products as PD

left join Suppliers as SS 
	on SS.SupplierID = PD.SupplierID
Order by SS.Country, PD.ProductName


/*Report 5 - Total Sales By Product Name*/

--Step 1
Select OD.OrderID, 
	OD.UnitPrice * OD.Quantity * (1-OD.Discount) as [Total Sales] 
from [Order Details] as OD


--Step 2
Select PD.ProductName, 
	OD.UnitPrice * OD.Quantity * (1-OD.Discount) as [Total Sales] 
from [Order Details] as OD

Left Join Products as PD 
	on PD.ProductID=OD.ProductID

--Step 3
Select Top 10 MyTable1.ProductName, 
Round(Sum(MyTable1.[Total Sales]),0) 
	as [Total Sales] from
			(Select PD.ProductName, 
				OD.UnitPrice * OD.Quantity * (1-OD.Discount) as [Total Sales] 
			from [Order Details] as OD

			Left Join Products as PD 
				on PD.ProductID=OD.ProductID) as MyTable1
Group by MyTable1.ProductName
order by [Total Sales] DESC


/*Report 6 - Total Sales By Customer Company Name
				-Top 10 Selling Products
				-Top 10 Customers (by Sales)*/
--Step 1
Select
	OD.OrderID, OD.ProductID,
	OD.UnitPrice * OD.Quantity * (1-OD.Discount) as [Sales Amount] 
from [Order Details] as OD

--Step 2
Select OD.OrderID, OD.ProductID,
		CS.CompanyName,
		OD.UnitPrice * OD.Quantity * (1-OD.Discount) as [Sales Amount] 
from [Order Details] as OD

Left Join Orders as ODR 
	on ODR.OrderID = OD.OrderID
Left Join Customers as CS 
	on CS.CustomerID = ODR.CustomerID

--Step 3
Select top 10 MyTable1.CompanyName, 
	Round(Sum(MyTable1.[Sales Amount]),0)
		as [Total Sales] from
				(Select CS.CompanyName,
					OD.UnitPrice * OD.Quantity * (1-OD.Discount) as [Sales Amount] 
				from [Order Details] as OD

				Left Join Orders as ODR 
					on ODR.OrderID = OD.OrderID
				Left Join Customers as CS 
					on CS.CustomerID = ODR.CustomerID) 
				as MyTable1
Group by MyTable1.CompanyName
Order by [Total Sales] DESC


--ALL REPORTS GENERATED

