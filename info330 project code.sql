-- Name of the Database: New Starbucks.csv

-- (1) Create your Schema
-- Store Table
CREATE TABLE Store (
    store_id INT PRIMARY KEY,
    location VARCHAR(500) NOT NULL,
    manager_name VARCHAR(100),
    store_contact_info VARCHAR(300)
);

-- Employee Table
CREATE TABLE Employee (
    employee_id INT PRIMARY KEY,
    employee_name VARCHAR(255) NOT NULL,
    position VARCHAR(100) NOT NULL,
    employee_contact_info VARCHAR(300),
    store_id INT,
    FOREIGN KEY (store_id) REFERENCES Store(store_id)
);

-- Sales Transaction Table
CREATE TABLE SalesTransaction (
    transaction_id INT PRIMARY KEY,
    quantity INT NOT NULL,
    date DATE NOT NULL,
    total_price DECIMAL(10, 2) NOT NULL,
    product_id INT,
    customer_id INT
);
-- Product Table
CREATE TABLE Product (
    product_id INT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    restock_level INT NOT NULL,
    category VARCHAR(100),
	transaction_id INT,
	FOREIGN KEY (transaction_id) REFERENCES SalesTransaction(transaction_id) ON DELETE CASCADE
);

-- Store & Product: sell (many-many)
CREATE TABLE sell (
    store_id INT,
    product_id INT,
    PRIMARY KEY (store_id, product_id),
    FOREIGN KEY (product_id) REFERENCES Product(product_id) ON DELETE CASCADE,
    FOREIGN KEY (store_id) REFERENCES Store(store_id) ON DELETE CASCADE
);

-- Customer Table
CREATE TABLE Customer (
    customer_id INT PRIMARY KEY,
    feedback VARCHAR(500),
    date DATE NOT NULL,
    store_id INT,
	transaction_id INT,
	FOREIGN KEY (transaction_id) REFERENCES SalesTransaction(transaction_id) ON DELETE CASCADE
);

-- Customer & Employee: serve (many-many)
CREATE TABLE serve (
	customer_id INT,
	employee_id INT,
	FOREIGN KEY (customer_id) REFERENCES customer(customer_id) ON DELETE CASCADE,
	FOREIGN KEY (employee_id) REFERENCES employee(employee_id) ON DELETE CASCADE
)


-- (2) Implement your queries
-- 1. Store Manager: How many products are currently below the restock level at our store?
SELECT COUNT(*) AS ProductsBelowRestockLevel
FROM Product
WHERE quantity < restock_level;

-- 2. Store Manager: How many units of each product category have been sold february? 
SELECT
    Product.category,
    SUM(SalesTransaction.quantity) AS UnitsSold
FROM
    SalesTransaction
INNER JOIN
    Product ON SalesTransaction.product_id = Product.product_id
WHERE
    SalesTransaction.date >= '2024-02-01' AND
    SalesTransaction.date < '2024-03-01'
GROUP BY
    Product.category;

-- 3. Barista: How many baristas are currently employed in each store?
SELECT
    S.store_id,
    S.location,
    COUNT(E.employee_id) AS BaristaCount
FROM
    Employee E
JOIN
    Store S ON E.store_id = S.store_id
WHERE
    E.position = 'Barista'
GROUP BY
    S.store_id, S.location;

-- 4. Store Manager: How many customers have made purchases in each store from February 8 to February 15, 2024?
SELECT
    S.store_id,
    S.location,
    COUNT(DISTINCT ST.customer_id) AS UniqueCustomers
FROM
    Store S
JOIN
    Employee E ON S.store_id = E.store_id
JOIN
    serve SV ON E.employee_id = SV.employee_id
JOIN
    SalesTransaction ST ON SV.customer_id = ST.customer_id
WHERE
    ST.date BETWEEN '2024-02-08' AND '2024-02-15'
GROUP BY
    S.store_id, S.location;

-- 5. Marketing Analyst: What are the top 5 selling products by quantity sold?
SELECT
    P.name,
    SUM(ST.quantity) AS TotalQuantitySold
FROM
    SalesTransaction ST
JOIN
    Product P ON ST.product_id = P.product_id
GROUP BY
    P.name
ORDER BY
    TotalQuantitySold DESC
LIMIT 5;

-- 6. Marketing Analyst: Which products have shown an lowest sales in quantity with its feedback from Customer?
SELECT
    P.product_id,
    P.name AS ProductName,
    MIN(ST.quantity) AS TotalQuantitySold
FROM
    SalesTransaction ST
JOIN
    Product P ON ST.product_id = P.product_id
WHERE
    ST.date BETWEEN '2024-02-01' AND '2024-02-29'
GROUP BY
    P.product_id
ORDER BY
    TotalQuantitySold ASC
LIMIT 10;

-- 7. Customer: What is the feedback from customers at stores in "Seattle Center, Seattle", "Ballard, Seattle", and "Fremont, Seattle"?
SELECT DISTINCT c.feedback
FROM Customer c
JOIN Store s ON c.store_id = s.store_id
WHERE s.location IN ('Seattle Center, Seattle', 'Fremont, Seattle', 'Ballard, Seattle');

-- 8. Customer: How many customers provided feedback about our products in February，2024?
SELECT COUNT(DISTINCT customer_id) AS NumberOfCustomersWithFeedback
FROM Customer
WHERE feedback IS NOT NULL
AND date BETWEEN '2024-02-01' AND '2024-02-29';

-- 9. Customer: See total spending in all stores in February ?
SELECT
    SUM(st.total_price) AS TotalSpending
FROM
    SalesTransaction st
WHERE
	st.date BETWEEN '2024-02-01' AND '2024-02-29';

-- 10. Sales Staff: How many transactions did each sales staff process in February 2024?
SELECT
    E.employee_id,
    E.employee_name,
    COUNT(DISTINCT ST.transaction_id) AS TransactionsProcessed
FROM
    Employee E
JOIN
    serve SV ON E.employee_id = SV.employee_id
JOIN
    SalesTransaction ST ON SV.customer_id = ST.customer_id
WHERE
    E.position = 'Sales Staffs'
    AND ST.date BETWEEN '2024-02-01' AND '2024-02-28'
GROUP BY
    E.employee_id, E.employee_name
ORDER BY
    TransactionsProcessed DESC;

-- (3) 3-5 demo queries that return (minimal) sensible results.
-- 2. [Houran Cheng]Store Manager: How many units of each product category have been sold february? 
SELECT
    Product.category,
    SUM(SalesTransaction.quantity) AS UnitsSold
FROM
    SalesTransaction
INNER JOIN
    Product ON SalesTransaction.product_id = Product.product_id
WHERE
    SalesTransaction.date >= '2024-02-01' AND
    SalesTransaction.date < '2024-03-01'
GROUP BY
    Product.category;

-- 7. [Hanrui Tang]Customer: What is the feedback from customers at stores in "Seattle Center, Seattle", "Ballard, Seattle", and "Fremont, Seattle"?
SELECT DISTINCT c.feedback
FROM Customer c
JOIN Store s ON c.store_id = s.store_id
WHERE s.location IN ('Seattle Center, Seattle', 'Fremont, Seattle', 'Ballard, Seattle');

-- 8. Customer: How many customers provided feedback about our products in February，2024?
SELECT COUNT(DISTINCT customer_id) AS NumberOfCustomersWithFeedback
FROM Customer
WHERE feedback IS NOT NULL
AND date BETWEEN '2024-02-01' AND '2024-02-29';

-- 10. [Yaqi Lu]Sales Staff: How many transactions did each sales staff process in February 2024?
SELECT
    E.employee_id,
    E.employee_name,
    COUNT(DISTINCT ST.transaction_id) AS TransactionsProcessed
FROM
    Employee E
JOIN
    serve SV ON E.employee_id = SV.employee_id
JOIN
    SalesTransaction ST ON SV.customer_id = ST.customer_id
WHERE
    E.position = 'Sales Staffs'
    AND ST.date BETWEEN '2024-02-01' AND '2024-02-28'
GROUP BY
    E.employee_id, E.employee_name
ORDER BY
    TransactionsProcessed DESC;

-- (4) reflection on what you learned and challenges.
We set our topic being about Starbucks because we are in Seattle, the founding city of Starbucks. 
At the beginning, our vision was that we were going to make a sophisticated system that serves both the stores and the customers, all in depth.
While we were designing our ERD diagram, we realized the relationships between stores and customers were just too complicated as it is,
and would pose unnecessary and probably unsolvable setbacks later on in the coding and dataset implementation process. So we narrowed it down to a more “store side focused” system,
while including the role of customers in the relationship chain. Moving on to the database implementation phase, we learned about the intricacies of managing foreign keys in ternary relationships,
which are very prone to errors if everything is not lined up perfectly. We encountered difficulties when inserting columns from temporary tables into real tables, often mixing up the table hierarchy and violating NULL value constraints.
Additionally, inconsistencies in data types led to challenges during the insertion process, and formatting issues in PostgreSQL occasionally resulted in errors as well. 

To address these challenges, we started by clarifying the dependencies between different elements of our database, this way we vget to insert data accurately according to class hierarchies.
By reviewing all keys and recreating tables for all many to many relationships, we ensured correct relational structure within our database. I’ll say that one of the most significant lessons
learned was the importance of accurately understanding and implementing parent child relationships in our database schema.
That and not getting over yourself earlier on in the process, if we had gone with what we envisioned during the ERD diagram phase, we’d be in bigger trouble.
Overall I’d say this project had been very useful in connecting all the skills we had learned over this quarter.



