USE DB;

-- ==========================================================================================
-- 1. CREATE AND EXECUTE A STORED PROCEDURE WITH PARAMETERS
-- OBJECTIVE:
-- Learn to create a stored procedure with input parameters and execute it with different values.
-- TASK:
-- • Create a stored procedure to retrieve employee details from the Employees table based on DepartmentID.
-- • Pass DepartmentID as an input parameter.
-- • Test the procedure by calling it with different department IDs.
-- EXPECTED OUTCOME:
-- A dynamic result set displaying employee information specific to the input department.
-- ==========================================================================================

CREATE TABLE EMPLOYEES (
    EMPLOYEEID INT,
    NAME VARCHAR(100),
    DEPARTMENTID INT,
    SALARY DECIMAL(10,2)
);

INSERT INTO EMPLOYEES (EMPLOYEEID, NAME, DEPARTMENTID, SALARY)
VALUES
(1, 'BISWANTH', 1, 70000),
(2, 'NAGESWARA RAO', 2, 50000),
(3, 'HARSHITH', 1, 75000),
(4, 'ILIAZ', 3, 60000),
(5, 'HEMANTH', 2, 65000);

CREATE PROCEDURE GETEMPLOYEESBYDEPARTMENT
    @DEPARTMENTID INT
AS
BEGIN
    SELECT *
    FROM EMPLOYEES
    WHERE DEPARTMENTID = @DEPARTMENTID;
END;

EXEC GETEMPLOYEESBYDEPARTMENT @DEPARTMENTID = 1;
EXEC GETEMPLOYEESBYDEPARTMENT @DEPARTMENTID = 2;

-- ==========================================================================================
-- 2. IMPLEMENT ERROR HANDLING IN STORED PROCEDURES
-- OBJECTIVE:
-- Understand how to add error handling in stored procedures using TRY...CATCH.
-- TASK:
-- • Create a stored procedure to insert data into a Products table.
-- • Add error handling to catch primary key or unique constraint violations.
-- • Log any errors into an ErrorLogs table with error details like message and timestamp.
-- EXPECTED OUTCOME:
-- Successful logging of errors without disrupting other operations.
-- ==========================================================================================

CREATE TABLE PRODUCTS (
    PRODUCTID INT PRIMARY KEY,
    PRODUCTNAME VARCHAR(100),
    PRICE DECIMAL(10,2),
    CATEGORY VARCHAR(50)
);

INSERT INTO PRODUCTS (PRODUCTID, PRODUCTNAME, PRICE, CATEGORY)
VALUES
(1, 'WATCH', 70000, 'ELECTRONICS'),
(2, 'SMARTPHONE', 40000, 'ELECTRONICS'),
(3, 'CHAIR', 50000, 'FURNITURE'),
(4, 'SPEAKER', 15000, 'ELECTRONICS'),
(5, 'SHIRT', 2000, 'CLOTHING');

CREATE TABLE ERRORLOGS (
    ERRORLOGID INT IDENTITY(1,1),
    ERRORMESSAGE VARCHAR(4000),
    ERRORTIME DATETIME
);

CREATE PROCEDURE INSERTPRODUCT
    @PRODUCTID INT,
    @PRODUCTNAME VARCHAR(100),
    @PRICE DECIMAL(10,2)
AS
BEGIN
    BEGIN TRY
        INSERT INTO PRODUCTS (PRODUCTID, PRODUCTNAME, PRICE)
        VALUES (@PRODUCTID, @PRODUCTNAME, @PRICE);
    END TRY
    BEGIN CATCH
        INSERT INTO ERRORLOGS (ERRORMESSAGE, ERRORTIME)
        VALUES (ERROR_MESSAGE(), GETDATE());
    END CATCH
END;

EXEC INSERTPRODUCT @PRODUCTID = 6, @PRODUCTNAME = 'DEVICE', @PRICE = 25000;
EXEC INSERTPRODUCT @PRODUCTID = 6, @PRODUCTNAME = 'DUPLICATE DEVICE', @PRICE = 18000;

SELECT * FROM PRODUCTS;
SELECT * FROM ERRORLOGS;

-- ==========================================================================================
-- 3. STORED PROCEDURE FOR DATA MODIFICATION
-- OBJECTIVE:
-- Practice using stored procedures to modify data in a table.
-- TASK:
-- • Create a stored procedure to update the salary of employees in the Employees table.
-- • Accept EmployeeID and NewSalary as input parameters.
-- • Test by updating multiple employee salaries.
-- EXPECTED OUTCOME:
-- Employees’ salaries are updated correctly, verified through a SELECT query.
-- ==========================================================================================

CREATE PROCEDURE UEMPLOYEESALARY 
    @EMPLOYEEID INT,
    @NEWSALARY DECIMAL(10,2)
AS
BEGIN
    SELECT 'BEFORE UPDATE' MESSAGE;
    SELECT * FROM EMPLOYEES WHERE EMPLOYEEID = @EMPLOYEEID;

    UPDATE EMPLOYEES
    SET SALARY = @NEWSALARY
    WHERE EMPLOYEEID = @EMPLOYEEID;

    SELECT 'AFTER UPDATE' MESSAGE;
    SELECT * FROM EMPLOYEES WHERE EMPLOYEEID = @EMPLOYEEID;
END;

EXEC UEMPLOYEESALARY @EMPLOYEEID = 1, @NEWSALARY = 75000;
EXEC UEMPLOYEESALARY @EMPLOYEEID = 2, @NEWSALARY = 70000;

SELECT * FROM EMPLOYEES;

-- ==========================================================================================
-- 4. STORED PROCEDURE WITH A CONDITIONAL QUERY
-- OBJECTIVE:
-- Use control flow in a stored procedure to return conditional results.
-- TASK:
-- • Create a stored procedure that accepts a category name as input.
-- • Return all products from the Products table for valid categories.
-- • Return a custom message if the category is not found.
-- EXPECTED OUTCOME:
-- Dynamic results displaying products or a “Category not found” message.
-- ==========================================================================================

CREATE PROCEDURE GETPRODUCTSBYCATEGORY
    @CATEGORYNAME VARCHAR(50)
AS
BEGIN
    IF EXISTS (SELECT 1 FROM PRODUCTS WHERE CATEGORY = @CATEGORYNAME)
        SELECT * FROM PRODUCTS WHERE CATEGORY = @CATEGORYNAME;
    ELSE
        SELECT 'CATEGORY NOT FOUND' MESSAGE;
END;

EXEC GETPRODUCTSBYCATEGORY 'ELECTRONICS';
EXEC GETPRODUCTSBYCATEGORY 'GADGETS';

-- ==========================================================================================
-- 5. STORED PROCEDURE WITH OUTPUT PARAMETERS
-- OBJECTIVE:
-- Learn to use output parameters in stored procedures.
-- TASK:
-- • Create a stored procedure to calculate total sales for a given CustomerID from the Sales table.
-- • Pass CustomerID as an input, return total sales as an output parameter.
-- • Execute for multiple customers.
-- EXPECTED OUTCOME:
-- Accurate calculation of total sales using output parameters.
-- ==========================================================================================

CREATE TABLE SALES (
    SALEID INT,
    CUSTOMERID INT,
    AMOUNT DECIMAL(10,2)
);

INSERT INTO SALES (SALEID, CUSTOMERID, AMOUNT)
VALUES
(1, 101, 10000),
(2, 102, 5000),
(3, 101, 3000),
(4, 103, 6000),
(5, 104, 15000);

CREATE PROCEDURE GETTOTALSALES
    @CUSTOMERID INT,
    @TOTALSALES DECIMAL(10,2) OUTPUT
AS
BEGIN
    SELECT @TOTALSALES = ISNULL(SUM(AMOUNT), 0)
    FROM SALES
    WHERE CUSTOMERID = @CUSTOMERID;
END;

DECLARE @TOTAL DECIMAL(10,2);
DECLARE @CUSTOMER INT = 101;

EXEC GETTOTALSALES @CUSTOMER, @TOTAL OUTPUT;
SELECT @TOTAL TOTALSALES, @CUSTOMER CUSTOMERID;

DECLARE @TOTALSALES DECIMAL(10,2);
EXEC GETTOTALSALES 102, @TOTALSALES OUTPUT;
SELECT @TOTALSALES TOTALSALES;
