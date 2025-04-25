use db;
-- 1. Inner Joins: Employee and Department
CREATE TABLE Departments (
    DepartmentID INT PRIMARY KEY,
    DepartmentName VARCHAR(50)
);

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    DepartmentID INT,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

INSERT INTO Departments (DepartmentID, DepartmentName)
VALUES (1, 'HR'),(2, 'IT'),(3, 'Sales');

INSERT INTO Employees (EmployeeID, Name, DepartmentID)
VALUES (101, 'Biswanth', 1),(102, 'Harshith', 2),(103, 'Nageswar', 3),(104, 'Iliaz', 1);

-- Query with INNER JOIN
SELECT Employees.Name, Departments.DepartmentName
FROM Employees INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID;

-- Challenge: Filter specific departments 
SELECT Employees.Name, Departments.DepartmentName
FROM Employees INNER JOIN Departments
ON Employees.DepartmentID = Departments.DepartmentID
WHERE Departments.DepartmentName = 'HR';

-------------------------------------------------------------------------------------------------------------------------------------------

-- 2. Left Joins: Product Inventory

CREATE TABLE Categories (
    CategoryID INT PRIMARY KEY,
    CategoryName VARCHAR(50)
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(50),
    CategoryID INT,
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

INSERT INTO Categories (CategoryID, CategoryName)
VALUES
(1, 'Electronics'),
(2, 'Clothing'),
(3, 'Furniture');

INSERT INTO Products (ProductID, ProductName, CategoryID)
VALUES
-- Electronics
(1001, 'Laptop', 1),
(1002, 'Keyboard', 1),
(1003, 'Mouse', 1),
(1004, 'Headphones', 1),
(1005, 'Monitor', 1),

-- Clothing
(2001, 'T-Shirt', 2),
(2002, 'Jeans', 2),
(2003, 'Jacket', 2),
(2004, 'Sneakers', 2),

-- Furniture
(3001, 'Office Chair', 3),
(3002, 'Desk', 3),
(3003, 'Bookshelf', 3),
(3004, 'Sofa', 3),

(4001, 'Visual Studio Code', NULL);



-- Query with LEFT JOIN
SELECT Products.ProductName, Categories.CategoryName
FROM Products
LEFT JOIN Categories
ON Products.CategoryID = Categories.CategoryID;

-- Challenge: Sort by CategoryName
SELECT Products.ProductName, Categories.CategoryName
FROM Products
LEFT JOIN Categories
ON Products.CategoryID = Categories.CategoryID
ORDER BY Categories.CategoryName;

---------------------------------------------------------------------------------------------

-- 3. Right Joins: Sales Data

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(50)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    CustomerID INT,
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

INSERT INTO Customers (CustomerID, CustomerName)
VALUES
(1, 'Biswanth Ch'),
(2, 'Harshith'),
(3, 'Nageswar');

INSERT INTO Orders (OrderID, OrderDate, CustomerID)
VALUES
(5001, '2023-01-15', 1),
(5002, '2023-02-20', 2),
(5003, '2023-03-10', NULL),
(5004, '2023-04-05', 3);

-- Query with RIGHT JOIN
	SELECT Orders.OrderDate, Customers.CustomerName
	FROM Customers
	RIGHT JOIN Orders ON Customers.CustomerID = Orders.CustomerID;

-- Challenge: Identify orders without customer names
SELECT Orders.OrderID, Orders.OrderDate, Customers.CustomerName
FROM Customers
RIGHT JOIN Orders ON Customers.CustomerID = Orders.CustomerID 
WHERE Customers.CustomerName IS NULL;

---------------------------------------------------------------------------------------------

-- 4. Aggregate Functions: Sales Analysis

CREATE TABLE Sales (
    SaleID INT PRIMARY KEY,
    ProductID INT,
    Quantity INT,
    SaleAmount DECIMAL(10,2),
    SaleDate DATE
);

INSERT INTO Sales (SaleID, ProductID, Quantity, SaleAmount, SaleDate)
VALUES
(1, 101, 2, 150.50, '2023-01-01'),
(2, 102, 1, 200.00, '2023-01-02'),
(3, 101, 3, 225.75, '2023-01-03'),
(4, 103, 5, 500.00, '2023-01-04');

-- Total sales
SELECT SUM(SaleAmount)  'Total Sales' FROM Sales;

-- Average sales
SELECT AVG(SaleAmount)  'Avg Sales' FROM Sales;

-- Number of sales
SELECT COUNT(SaleID)  'Number Of Sales' FROM Sales;

-- Max and Min sale amounts
SELECT MAX(SaleAmount)  'Max Sale', MIN(SaleAmount)  'Min Sale' FROM Sales;

-- Challenge: Group by ProductID
SELECT 
    ProductID,
    SUM(SaleAmount) AS TotalSales,
    AVG(SaleAmount) AS AvgSales,
    COUNT(SaleID) AS NumberOfSales,
    MAX(SaleAmount) AS MaxSale,
    MIN(SaleAmount) AS MinSale
FROM Sales
GROUP BY ProductID;

---------------------------------------------------------------------------------------------

-- 5. HAVING and GROUP BY Clauses: Employee Performance

CREATE TABLE Performance (
    EmployeeID INT,
    Month VARCHAR(10),
    SalesAmount DECIMAL(10,2)
);

INSERT INTO Performance (EmployeeID, Month, SalesAmount)
VALUES
(101, 'January', 3000.00),
(101, 'February', 2500.00),
(102, 'January', 4000.00),
(102, 'February', 3500.00),
(103, 'January', 2000.00),
(103, 'February', 1500.00);

-- Group employees and calculate total sales
SELECT EmployeeID, SUM(SalesAmount) TotalSales
FROM Performance
GROUP BY EmployeeID;

-- Filter with HAVING clause (total sales > $5000)
SELECT EmployeeID, SUM(SalesAmount) TotalSales
FROM Performance
GROUP BY EmployeeID
HAVING SUM(SalesAmount) > 5000;

-- Challenge: Include average monthly sales
SELECT EmployeeID,SUM(SalesAmount) 'Total Sales',AVG(SalesAmount) 'Avg Monthly Sales'
FROM Performance
GROUP BY EmployeeID
HAVING SUM(SalesAmount) > 5000;
