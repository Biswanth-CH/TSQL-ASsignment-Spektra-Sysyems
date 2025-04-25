use adventureworks2019;

-- 1. retrieve all employees whose hiredate is after january 1, 2015
select * from humanresources.employee where hiredate > '2015-01-01';

-- 2. products in categories 1, 2, 3 
select name from production.productcategory where productcategoryid in (1, 2, 3);

-- 3. products in category 1 or priced over $100 
select * from production.product
where (productsubcategoryid = 1 or listprice > 100) and listprice is not null;

-- 4. retrieve sales orders placed between jan 1, 2018 and dec 31, 2019
select * from sales.salesorderheader
where orderdate >= '2018-01-01' and orderdate < '2020-01-01';

-- 5. list all distinct job titles from humanresources.employee
select distinct jobtitle 'job tittle' from humanresources.employee;

-- 6. retrieve customers whose first name starts with 'jo'
select * from person.person where firstname like 'jo_l';

-- 7. retrieve customers whose last name contains 'son'
select * from person.person where lastname like '%son%';

-- 8. retrieve a list of products sorted by price in descending order
select * from production.product where listprice > 0 order by listprice desc;
