USE AdventureWorks2019;
-- 1. Salespeople not living in the same city as customers with commission > 12%
SELECT DISTINCT
    pCust.FirstName + ' ' + pCust.LastName AS CustomerName,
    custAddr.City AS CustomerCity,
    salesPerson.FirstName + ' ' + salesPerson.LastName AS SalesmanName,
    salesAddr.City AS SalesmanCity,
    salesRep.CommissionPct  AS Commission
FROM Sales.SalesOrderHeader salesOrder
JOIN Sales.Customer cust ON salesOrder.CustomerID = cust.CustomerID
JOIN Sales.SalesPerson salesRep ON salesOrder.SalesPersonID = salesRep.BusinessEntityID
JOIN Person.Person salesPerson ON salesRep.BusinessEntityID = salesPerson.BusinessEntityID
JOIN Person.Person pCust ON cust.PersonID = pCust.BusinessEntityID

-- Customer Address
JOIN Person.BusinessEntityAddress custBEA ON cust.StoreID = custBEA.BusinessEntityID
JOIN Person.Address custAddr ON custBEA.AddressID = custAddr.AddressID

-- Salesperson Address
JOIN Person.BusinessEntityAddress salesBEA ON salesRep.BusinessEntityID = salesBEA.BusinessEntityID
JOIN Person.Address salesAddr ON salesBEA.AddressID = salesAddr.AddressID

WHERE custAddr.City != salesAddr.City
  AND salesRep.CommissionPct > 0.0012;

select CommissionPct from Sales.SalesPerson; -- Commision values

	-- 2. Every salesperson with customer & order info (or none)
	SELECT 
		sp.BusinessEntityID AS SalespersonID,
		spPerson.FirstName + ' ' + spPerson.LastName AS SalespersonName,
		c.CustomerID,
		custPerson.FirstName + ' ' + custPerson.LastName AS CustomerName,
		addr.City AS CustomerCity,
		soh.SalesOrderID AS OrderNumber,
		soh.OrderDate,
		soh.TotalDue AS OrderAmount
	FROM 
Sales.SalesPerson sp
	LEFT JOIN Sales.SalesOrderHeader soh ON sp.BusinessEntityID = soh.SalesPersonID
	LEFT JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
	LEFT JOIN Person.Person custPerson ON c.PersonID = custPerson.BusinessEntityID
	LEFT JOIN Person.BusinessEntityAddress custBEA ON custPerson.BusinessEntityID = custBEA.BusinessEntityID
	LEFT JOIN Person.Address addr ON custBEA.AddressID = addr.AddressID
	LEFT JOIN Person.Person spPerson ON sp.BusinessEntityID = spPerson.BusinessEntityID;


	-- 3. Salary difference in Department ID 16
		SELECT 
   SELECT 
    e.JobTitle,
    p.FirstName + ' ' + p.LastName AS EmployeeName,
    (MAX(ph.Rate) OVER() - ph.Rate) AS SalaryDifference
FROM 
    HumanResources.Employee e
INNER JOIN 
    HumanResources.EmployeeDepartmentHistory edh 
    ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN 
    HumanResources.Department d 
    ON edh.DepartmentID = d.DepartmentID
INNER JOIN 
    HumanResources.EmployeePayHistory ph 
    ON e.BusinessEntityID = ph.BusinessEntityID
INNER JOIN 
    Person.Person p 
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE 
    d.DepartmentID = 16
    AND edh.EndDate IS NULL 
ORDER BY 
    EmployeeName;

	SELECT DepartmentID from HumanResources.EmployeeDepartmentHistory; -- Departments available

	-- 4. Compare employee YTD sales and previous year
	SELECT 
		st.Name AS TerritoryName,
		sp.SalesYTD,
		sp.BusinessEntityID,
		sp.SalesLastYear AS PrevRepSales
	FROM 
		Sales.SalesPerson sp
	JOIN Sales.SalesTerritory st ON sp.TerritoryID = st.TerritoryID
	ORDER BY st.Name ASC;


	-- 5. Orders where amount is between 500 and 2000
	SELECT 
		soh.SalesOrderID AS Ord_No,
		soh.TotalDue AS Purch_Amt,
		custPerson.FirstName + ' ' + custPerson.LastName AS Cust_Name,
		addr.City,
		soh.TotalDue -- Total Due
	FROM 
		Sales.SalesOrderHeader soh
	JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
	JOIN Person.Person custPerson ON c.PersonID = custPerson.BusinessEntityID
	JOIN Person.BusinessEntityAddress bea ON c.PersonID = bea.BusinessEntityID
	JOIN Person.Address addr ON bea.AddressID = addr.AddressID
	WHERE soh.TotalDue BETWEEN 500 AND 2000;


	-- 6. Customers with or without orders
		SELECT 
		p.FirstName + ' ' + p.LastName AS CustomerName,
		addr.City,
		soh.SalesOrderID AS OrderNumber,
		soh.OrderDate,
		soh.TotalDue AS OrderAmount
	FROM 
		Sales.Customer c
	JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
	LEFT JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
	LEFT JOIN Person.BusinessEntityAddress bea ON p.BusinessEntityID = bea.BusinessEntityID
	LEFT JOIN Person.Address addr ON addr.AddressID = soh.ShipToAddressID
	ORDER BY soh.OrderDate;



	-- 7. Employees with job titles starting with 'Sales'
	SELECT 
		e.JobTitle,
		p.LastName,
		p.MiddleName,
		p.FirstName
	FROM 
		HumanResources.Employee e
	JOIN Person.Person p ON e.BusinessEntityID = p.BusinessEntityID
	WHERE 
		e.JobTitle LIKE 'Sales%';
