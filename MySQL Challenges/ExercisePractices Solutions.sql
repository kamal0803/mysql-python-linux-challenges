/*
EXERCISE 1 - COMPLETED
*/

-- **** Databases, Tables and CRUD Operations ****
-- 1. Create a database called coursedb
USE coursedb;

use northwind;
show tables;
desc suppliers;
select * from suppliers;
select SupplierID, CompanyName, Country, City from northwind.Suppliers;
use northwind;
select * from suppliers;
select * from coursedb.products;
show tables;
CREATE TABLE products(
	productid int auto_increment primary key,
    product varchar(40),
    price decimal(6,2),
    supplierid int,
    foreign key(supplierid) references suppliers(supplierid)
);
desc northwind.suppliers;
select * from northwind.suppliers;
select * from northwind.products;
Delete from northwind.suppliers where supplierid='30';
Update northwind.products set supplierid='8' where productname='chai';
Insert into northwind.suppliers(companyname,contactname,contacttitle,addreb,city,region,postalcode,country,phone,fax,homepage) values
('xyz1','Kamal','Manager','Mansarovar','Jaipur','Rajasthan','302020','India','1234','No FAX','abcd');


/*
EXERCISE 2 - COMPLETED
*/

-- **** Select Statements Exercise ****
-- 1 Show the ProductName and UnitPrice of all products in the price range 20 to 30
SELECT ProductName, UnitPrice from northwind.products where unitprice between 20 and 30;

-- 2 Show the countries in the customers table with no duplicates
select country as Country from northwind.customers group by country having count(country)=1 ;

-- 3 Show the CompanyName, Country and City of all customers that are restaurants (the word restaurant should be in the CompanyName)
select CompanyName,country,city from northwind.customers where companyname like '%restaurant%';

-- 4 Show The CompanyName, ContactName, Country,and City of all suppliers from Germany, France, Italy and Spain
select companyname, contactname,country,city from northwind.customers where country='Germany' 
or country='france' or country='italy' or country='spain';

select * from northwind.products;
select orderid,orderdate,customerid from northwind.customers;

use northwind;

select ProductName as Product, UnitPrice as Price,
UnitsInStock as Stock, ReorderLevel as `Reorder Level` from products where discontinued <>1;


-- 6 Create a report that shows each ProductName, UnitPrice, UnitsInStock and ReorderLevel and a message
-- for each product that will be either 'Order Stock' (UnitsInStock is equal to or below ReorderLevel) or 'Sufficient Stock' 
-- (UnitsInStock is above the ReorderLevel) give the report headings such as Product, Price, Stock, 'Reorder Level' and 
-- 'Stock Alert'.  Discontinued products should be excluded from the report. (DONE)


select ProductName as Product, UnitPrice as Price, UnitsInStock as Stock, ReorderLevel as `Reorder Level`,
case 
	when UnitsInStock <=ReorderLevel then "Sufficient Stock"
    else "Stock Alert"
end as Message
from products where discontinued <>1;

select * from customers;
select * from orders;

select companyname, orderid,orderdate from customers c 
join orders o on c.customerid=o.customerid 
where country='germany' and year(orderdate)=2018;

select * from categories;
select * from products;
select * from suppliers;

select categoryname, companyname, productname,unitprice from categories c 
join products p on c.categoryid=p.categoryid
join suppliers s on s.supplierid=p.supplierid;

-- 4 List the CategoryName (categories), ProductName (products) and UnitPrice (products) for the 5
-- most expensive products. To do this you will need to Join the Categories and Products tables


select * from categories;
select * from products;

select categoryname, productname,unitprice from categories c
join products p on c.categoryid=p.categoryid
order by unitprice desc limit 5;

show tables;



-- 5 Write a SQL Statement that displays the total revenue for each category.  
-- The revenue can be calculated using the expression (unitprice * quantity) * (1 – discount).
-- You will need to join the Categories, Products and Order_Details tables to do this.
-- Make sure you use the UnitPrice in the Order_Details table not the Products table.  
-- Sort the list in descending order of revenue.

select * from categories;
select * from products;
select * from order_details;

use northwind;

create temporary table result
select FORMAT(SUM((o.unitprice * o.quantity) * (1 - o.discount)),2) as `Revenue`,
c.categoryname as `Category Name` 
from 
categories c 
join products p ON c.categoryid= p.categoryid
join order_details o ON o.productid=p.productid group by `Category Name` ;

drop temporary table result;
desc result;

select `Category Name`, revenue from result 
order by revenue desc;

SELECT CategoryName, FORMAT(SUM((od.UnitPrice * Quantity) * (1 - Discount)),2) Revenue FROM Categories c
JOIN Products p ON c.CategoryID = p.CategoryID
JOIN Order_Details od ON p.ProductID = od.ProductID
GROUP BY CategoryName ORDER BY SUM((od.UnitPrice * Quantity) * (1 - Discount)) DESC;

select * from customers;
select * from employees;


-- 6 Write a SQL Statement that displays the total revenue generated by each customer country.  The revenue can be calculated 
-- using the expression (unitprice * quantity) * (1 â€“ discount) in a sum aggregate.  You will need to join the Customers, Orders and 
-- Order_Details tables to do this.  Only show rows where the revenue is over 100,000


select * from customers;
select * from orders;
select * from order_details;

SELECT Country, FORMAT(SUM((od.UnitPrice * Quantity) * (1 - Discount)),2) Revenue FROM Customers c
JOIN orders o ON o.customerid = c.customerid
JOIN Order_Details od ON o.orderid = od.orderID
GROUP BY country HAVING SUM((od.UnitPrice * Quantity) * (1 - Discount)) > 100000;


-- ***** Subqueries and Views *****
-- 1. Use a subquery to generate a list of customers (CompanyName, ContactName, Country, City) that are in the same country as 
-- the employees.

select companyname,contactname,country,city from customers where customers.country in 
(select country from employees where customers.country=employees.country );

-- Alternate Solution
select companyname,contactname,country,city from customers where customers.country in 
(select distinct country from employees);



-- 2.  Execute this statement:
SELECT ProductName, DATE_FORMAT(OrderDate, "%D %b %Y") `Order Date`, 
Quantity FROM Products p JOIN Order_Details od ON p.ProductID = od.ProductID 
JOIN Orders o ON o.OrderID = od.OrderID ORDER BY ProductName, Quantity DESC;
-- Can you modify it so that we only see the row or rows (in the case of a tie) 
-- for the best sale for each product?


SELECT ProductName, DATE_FORMAT(OrderDate, "%D %b %Y") `Order Date`, 
Quantity FROM Products p JOIN Order_Details od ON p.ProductID = od.ProductID 
JOIN Orders o ON o.OrderID = od.OrderID where quantity=(select max(quantity) from order_details 
where productid=p.productid)
ORDER BY ProductName;


-- 3. Create a view vCountryFromTo that lists the OrderID(Orders), OrderDate(Orders), ProductName(Products), Country(Suppliers) with an alias
-- 'Supplier Country' and Country(Customers) with an alias 'Customer Country'.  You will need to join the Suppliers, Products, Order_Details,
-- Orders and Customers tables to do this.  When querying the view you can limit the results to a single month of your choice.

CREATE view vCountryFromTo AS
SELECT o.OrderID, OrderDate, ProductName, s.Country `Supplier Country`, c.Country `Customer Country`
FROM suppliers s
JOIN products p ON s.SupplierID = p.SupplierID
JOIN order_details od ON p.ProductID = od.ProductID
JOIN orders o ON od.OrderID = o.OrderID
JOIN customers c ON o.CustomerID = c.CustomerID;