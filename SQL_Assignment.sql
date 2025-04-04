-- Q1.	Create a table called employees with the following structure?

create database sql_test;
use sql_test;

CREATE TABLE employees (
    emp_id INT NOT NULL PRIMARY KEY,
    emp_name VARCHAR(100) NOT NULL,
    age INT CHECK (age >= 18),
    email VARCHAR(255) UNIQUE,
    salary DECIMAL(10, 2) DEFAULT 30000.00);
select * from employees;

-- Q2.	Explain the purpose of constraints and how they help maintain data integrity in a database. Provide examples of common types of constraints.

-- Ans. Constraints are rules enforced on table columns to ensure data accuracy and reliability. 
-- They maintain data integrity by restricting the types of data that can be inserted, updated, or deleted. 
-- Here are common types of constraints, explained with examples:

-- a. NOT NULL: Ensures that a column cannot have a  value
-- b. UNIQUE: Ensures all values in a column are unique.
-- c. PRIMARY KEY: Combines NOT NULL and UNIQUE to uniquely identify each record in the table.
-- d. FOREIGN KEY: Links one table to another, enforcing referential integrity. 
-- e. CHECK: Validates the value of a column against specific conditions.
-- f. DEFAULT: Assigns a default value to a column when no value is provided.

-- Q3 	Why would you apply the NOT NULL constraint to a column? Can a primary key contain NULL values? Justify your answer. 	

-- Ans. The NOT NULL constraint ensures that a column cannot have a NULL value. 
-- It is typically applied to columns where data is mandatory, such as identifiers or essential information.

-- Why Apply NOT NULL?

-- 1. Ensures critical data is always present (e.g., employee names, order IDs, etc.).
-- 2. Prevents database errors that could occur due to missing values in essential columns.
-- 3. Helps maintain logical integrity, especially when the data is part of relationships or calculations.

-- Can a Primary Key Contain NULL Values?
-- No, a primary key cannot contain NULL values. because:

-- 1. A primary key uniquely identifies each record in a table, and NULL represents "unknown" or "missing" data, which cannot serve as a unique identifier.
-- 2. Primary keys combine the constraints NOT NULL and UNIQUE.

-- Attempting to assign a NULL value to a primary key would violate the rule of uniqueness, as it creates ambiguity in identifying a record.

-- Q4	 Explain the steps and SQL commands used to add or remove constraints on an existing table. Provide an example for both adding and removing a constraint.

-- Ans. To add a constraint to an existing table, you use the `ALTER TABLE` command along with `ADD CONSTRAINT`. example:

CREATE TABLE products (
    product_id INT NOT NULL PRIMARY KEY,
    product_name VARCHAR(50),
    price DECIMAL(10, 2) DEFAULT 50.00);

ALTER TABLE products
ADD CONSTRAINT pk_product_id PRIMARY KEY (product_id);

-- To remove a constraint, you use the `ALTER TABLE` command along with `DROP CONSTRAINT`. 
-- Note that MySQL requires you to use the constraint's name (for example, `pk_product_id` above) or specify its type directly, like dropping a `FOREIGN KEY`.

ALTER TABLE products
DROP PRIMARY KEY;

-- Q5	5. Explain the consequences of attempting to insert, update, or delete data in a way that violates constraints. Provide an example of an error message that might occur when violating a constraint

-- Ans. Consequences of Constraint Violations:
-- 1. Insert Violations: Occur when inserting data that doesn't meet column constraints, such as `NOT NULL`, `UNIQUE`, or `CHECK`.
-- Example:
     INSERT INTO employees (emp_id, emp_name, age, email, salary)
     VALUES (1, 'John', 17, 'john@example.com', 40000);

-- Error: Error Code: 3819. Check constraint 'employees_chk_1' is violated.

-- 2. Update Violations: Happen when attempting to update rows in ways that breach constraints like referential integrity or column rules.
-- Example:
     UPDATE employees
     SET age = NULL
     WHERE emp_id = 1;
     
-- Error: Error Code: 1048. Column 'age' cannot be NULL.*

-- 3. Delete Violations: Arise when deleting rows referenced by `FOREIGN KEY` in another table.
-- Example:
     DELETE FROM employees
     WHERE emp_id = 1;

-- If `emp_id` is a foreign key in another table, you might get: Error Code: 1451. Cannot delete or update a parent row: a foreign key constraint fails.*

-- Q6.	6. You created a products table without constraints as follows:

-- CREATE TABLE product (
   --  product_id INT,
   -- product_name VARCHAR(50),
   --  price DECIMAL(10, 2));
-- Now, you realise that?
-- : The product_id should be a primary key
-- : The price should have a default value of 50.00    

CREATE TABLE product (
    product_id INT,
    product_name VARCHAR(50),
    price DECIMAL(10, 2));

-- Step 1: Add Primary Key
ALTER TABLE product
ADD CONSTRAINT pk_product_id PRIMARY KEY (product_id);

-- Step 2: Modify Column to Add Default Value for `price`
ALTER TABLE product
MODIFY price DECIMAL(10, 2) DEFAULT 50.00;    

-- Q7	You have two tables:

CREATE TABLE Student (
    student_id INT,
    student_name VARCHAR(50),
    class_id INT);

CREATE TABLE Classe (
    class_id INT,
    class_name VARCHAR(50));
    
INSERT INTO Student (student_id, student_name, class_id)
VALUES 
(1, 'Alice', 101),
(2, 'Bob', 102),
(3, 'Charlie', 101);

INSERT INTO Classe (class_id, class_name)
VALUES 
(101, 'Math'),
(102, 'Science'),
(103, 'History'); 

select * from student;
select * from classe;

SELECT 
    s.student_name, 
    c.class_name
FROM 
    Student s
INNER JOIN 
    Classe c
ON 
    s.class_id = c.class_id;
    
-- Q8	 Consider the following three tables:

-- Write a query that shows all order_id, customer_name, and product_name, ensuring that all products are listed even if they are not associated with an order 

use learn2;

CREATE TABLE Orders (
    order_id INT PRIMARY KEY,
    order_date DATE,
    customer_id INT);

CREATE TABLE Customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50));

CREATE TABLE Product (
    product_id INT,
    product_name VARCHAR(50),
    order_id INT);
    
INSERT INTO Orders (order_id, order_date, customer_id)
VALUES 
(1, '2024-01-01', 101),
(2, '2024-01-03', 102);

INSERT INTO Customers (customer_id, customer_name)
VALUES 
(101, 'Alice'),
(102, 'Bob');

INSERT INTO Product (product_id, product_name, order_id)
VALUES 
(1, 'Laptop', 1),
(2, 'Phone', 1),
(NULL, NULL, NULL);    
    
SELECT 
    o.order_id,
    c.customer_name,
    p.product_name
FROM 
    Products p
LEFT JOIN 
    Orders o ON p.order_id = o.order_id
LEFT JOIN 
    Customers c ON o.customer_id = c.customer_id;
    
-- Q9	Given the following tables:
-- 		Write a query to find the total sales amount for each product using an INNER JOIN and the SUM() function.

CREATE TABLE Sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    amount DECIMAL(10, 2));

INSERT INTO Sales (sale_id, product_id, amount)
VALUES 
(1, 101, 500),
(2, 102, 300),
(3, 101, 700);

INSERT INTO Products (product_id, product_name)
VALUES 
(101, 'Laptop'),
(102, 'Phone');    

SELECT 
    p.product_name,
    SUM(s.amount) AS total_sales
FROM 
    Products p
INNER JOIN 
    Sales s ON p.product_id = s.product_id
GROUP BY 
    p.product_name;    

-- Q10	You are given three tables:
-- 		Write a query to display the order_id, customer_name, and the quantity of products ordered by each customer using an INNER JOIN between all three tables.

CREATE TABLE Ord (
    order_id INT,
    order_date DATE,
    customer_id INT);

CREATE TABLE Cust (
    customer_id INT,
    customer_name VARCHAR(50));

CREATE TABLE Order_Details (
    order_id INT,
    product_id INT,
    quantity INT);
    

INSERT INTO Ord (order_id, order_date, customer_id)
VALUES 
(1, '2024-01-02', 1),
(2, '2024-01-05', 2);

INSERT INTO Cust (customer_id, customer_name)
VALUES 
(1, 'Alice'),
(2, 'Bob');

INSERT INTO Order_Details (order_id, product_id, quantity)
VALUES 
(1, 101, 2),
(1, 102, 1),
(2, 101, 3);

SELECT 
    o.order_id,
    c.customer_name,
    od.quantity
FROM 
    Orders o
INNER JOIN 
    Customers c ON o.customer_id = c.customer_id
INNER JOIN 
    Order_Details od ON o.order_id = od.order_id;
    

-- SQL COMMANDS
use mavenmovies;

-- Q1	Identify the primary keys and foreign keys in maven movies db. Discuss the differences

-- Query to identify primary keys
SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = 'mavenmovies' 
    AND CONSTRAINT_NAME = 'PRIMARY';

SELECT 
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM 
    INFORMATION_SCHEMA.KEY_COLUMN_USAGE
WHERE 
    TABLE_SCHEMA = 'mavenmovies' 
    AND REFERENCED_TABLE_NAME IS NOT NULL;
    
-- Differences Between Primary Keys and Foreign Keys:
-- Primary Keys**:
  -- Ensure uniqueness and no `NULL` values.
  -- Exist independently in their own table.
-- Foreign Keys**:
  -- Can have duplicate or `NULL` values.
  -- Reference primary keys in other tables to enforce relationships.

-- Q2 	 List all details of actors

SELECT * FROM Actor;

-- Q3 	List all customer information from DB.

SELECT * FROM Customer;

-- Q4	List different countries.

SELECT * FROM country; 

-- Q5 	Display all active customers.

SELECT * 
FROM Customer
WHERE active = 1;

-- 6 	List of all rental IDs for customer with ID 1.

SELECT rental_id
FROM Rental
WHERE customer_id = 1;

-- 7 	Display all the films whose rental duration is greater than 5.

SELECT *
FROM Film
WHERE rental_duration > 5;

-- 8 	List the total number of films whose replacement cost is greater than $15 and less than $20.

SELECT COUNT(*) AS total_films
FROM Film
WHERE replacement_cost > 15 AND replacement_cost < 20;

-- 9 	Display the count of unique first names of actors.

select * from actor;
SELECT COUNT(DISTINCT first_name) AS unique_first_names
FROM Actor;

-- 10	Display the first 10 records from the customer table .

SELECT *
FROM Customer
LIMIT 10;

-- 11 	Display the first 3 records from the customer table whose first name starts with ‘b’.

SELECT *
FROM Customer
WHERE first_name LIKE 'B%'
LIMIT 3;

-- 12 	Display the names of the first 5 movies which are rated as ‘G’.

SELECT *
FROM film
WHERE rating = 'G'
LIMIT 5;

-- 13	Find all customers whose first name starts with "a".

SELECT *
FROM Customer
WHERE first_name LIKE 'A%';

-- 14 	Find all customers whose first name ends with "a".

SELECT *
FROM Customer
WHERE first_name LIKE '%a';

-- 15 	Display the list of first 4 cities which start and end with ‘a’.

SELECT city
FROM City
WHERE city LIKE 'a%' AND city LIKE '%a'
LIMIT 4;

-- 16	Find all customers whose first name have "NI" in any position.

SELECT *
FROM Customer
WHERE first_name LIKE '%NI%';

-- 17	Find all customers whose first name have "r" in the second position.

SELECT *
FROM Customer
WHERE first_name LIKE '_R%';

-- 18 	Find all customers whose first name starts with "a" and are at least 5 characters in length.

SELECT *
FROM Customer
WHERE first_name LIKE 'A%' AND CHAR_LENGTH(first_name) >= 5;

-- 19	Find all customers whose first name starts with "a" and ends with "o".

SELECT *
FROM Customer
WHERE first_name LIKE 'A%o';

-- 20 	Get the films with pg and pg-13 rating using IN operator.

SELECT *
FROM Film
WHERE rating IN ('PG', 'PG-13');

-- 21 	Get the films with length between 50 to 100 using between operator.

SELECT *
FROM Film
WHERE length BETWEEN 50 AND 100;

-- 22 	Get the top 50 actors using limit operator.

SELECT *
FROM Actor
LIMIT 50;

-- 23 	Get the distinct film ids from inventory table.

SELECT DISTINCT film_id
FROM Inventory;

-- Functions
-- Basic Aggregate Functions:	

-- Q1 	Retrieve the total number of rentals made in the Sakila database.

SELECT COUNT(*) AS total_rentals FROM Rental;

-- Q2 	Find the average rental duration (in days) of movies rented from the Sakila database.

SELECT AVG(DATEDIFF(return_date, rental_date)) AS avg_rental_duration
FROM Rental;

-- Q3 	Display the first name and last name of customers in uppercase.

SELECT UPPER(first_name) AS uppercase_first_name,
       UPPER(last_name) AS uppercase_last_name
FROM Customer;

-- Q4 	Extract the month from the rental date and display it alongside the rental ID.

SELECT rental_id, MONTH(rental_date) AS rental_month
FROM Rental;

-- Q5 	Retrieve the count of rentals for each customer (display customer ID and the count of rentals).

SELECT customer_id, COUNT(*) AS rental_count
FROM Rental
GROUP BY customer_id;

-- Q6 Find the total revenue generated by each store.

SELECT store, SUM(amount) AS total_revenue
FROM Payment
GROUP BY store_id;

-- Q7	Determine the total number of rentals for each category of movies.

SELECT c.name AS category_name, COUNT(r.rental_id) AS total_rentals
FROM Rental r
JOIN Inventory i ON r.inventory_id = i.inventory_id
JOIN Film f ON i.film_id = f.film_id
JOIN Film_Category fc ON f.film_id = fc.film_id
JOIN Category c ON fc.category_id = c.category_id
GROUP BY c.name
ORDER BY total_rentals DESC;

-- Q8	Find the average rental rate of movies in each language.

SELECT l.name AS language_name, AVG(f.rental_rate) AS average_rental_rate
FROM Film f
JOIN Language l ON f.language_id = l.language_id
GROUP BY l.name
ORDER BY average_rental_rate DESC;

-- Q9	Display the title of the movie, customer s first name, and last name who rented it.

SELECT f.title AS movie_title,
       c.first_name AS customer_first_name,
       c.last_name AS customer_last_name
FROM Rental r
JOIN Inventory i ON r.inventory_id = i.inventory_id
JOIN Film f ON i.film_id = f.film_id
JOIN Customer c ON r.customer_id = c.customer_id;

-- 10	Retrieve the names of all actors who have appeared in the film "Gone with the Wind."

SELECT a.first_name, a.last_name
FROM Actor a
JOIN Film_Actor fa ON a.actor_id = fa.actor_id
JOIN Film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

-- 11 	Retrieve the customer names along with the total amount they've spent on rentals.

SELECT c.first_name AS customer_first_name,
       c.last_name AS customer_last_name,
       SUM(p.amount) AS total_spent
FROM Customer c
JOIN Payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_spent DESC;

-- 12 	List the titles of movies rented by each customer in a particular city (e.g., 'London').

SELECT c.first_name AS customer_first_name,
       c.last_name AS customer_last_name,
       f.title AS movie_title,
       ci.city AS customer_city
FROM Rental r
JOIN Inventory i ON r.inventory_id = i.inventory_id
JOIN Film f ON i.film_id = f.film_id
JOIN Customer c ON r.customer_id = c.customer_id
JOIN Address a ON c.address_id = a.address_id
JOIN City ci ON a.city_id = ci.city_id
WHERE ci.city = 'London';

-- 13 	Display the top 5 rented movies along with the number of times they've been rented.

SELECT f.title AS movie_title, COUNT(r.rental_id) AS rental_count
FROM Rental r
JOIN Inventory i ON r.inventory_id = i.inventory_id
JOIN Film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;

-- 14 	Determine the customers who have rented movies from both stores (store ID 1 and store ID 2).

SELECT c.customer_id, c.first_name, c.last_name
FROM Customer c
WHERE c.customer_id IN (
    SELECT r.customer_id
    FROM Rental r
    JOIN Inventory i ON r.inventory_id = i.inventory_id
    WHERE i.store_id = 1)
    
AND c.customer_id IN (
    SELECT r.customer_id
    FROM Rental r
    JOIN Inventory i ON r.inventory_id = i.inventory_id
    WHERE i.store_id = 2);
    

-- WINDOWS FUNCTION

-- Q1	 Rank the customers based on the total amount they've spent on rentals.

SELECT c.customer_id,
       c.first_name AS customer_first_name,
       c.last_name AS customer_last_name,
       SUM(p.amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(p.amount) DESC) AS customer_rank
FROM Customer c
JOIN Payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY customer_rank;

-- Q2	 Calculate the cumulative revenue generated by each film over time.

SELECT f.title AS film_title,
       p.payment_date,
       SUM(p.amount) OVER (PARTITION BY f.film_id ORDER BY p.payment_date) AS cumulative_revenue
FROM Payment p
JOIN Rental r ON p.rental_id = r.rental_id
JOIN Inventory i ON r.inventory_id = i.inventory_id
JOIN Film f ON i.film_id = f.film_id
ORDER BY f.title, p.payment_date;

-- Q3 	 Determine the average rental duration for each film, considering films with similar lengths.

SELECT f.title AS film_title,
       f.length AS film_length,
       AVG(DATEDIFF(r.return_date, r.rental_date)) OVER (PARTITION BY f.length) AS avg_rental_duration
FROM Rental r
JOIN Inventory i ON r.inventory_id = i.inventory_id
JOIN Film f ON i.film_id = f.film_id
ORDER BY f.length, f.title;

-- Q4  Identify the top 3 films in each category based on their rental counts.

WITH RankedFilms AS (
    SELECT c.name AS category_name,
           f.title AS film_title,
           COUNT(r.rental_id) AS rental_count,
           RANK() OVER (PARTITION BY c.category_id ORDER BY COUNT(r.rental_id) DESC) AS rank
    FROM Rental r
    JOIN Inventory i ON r.inventory_id = i.inventory_id
    JOIN Film f ON i.film_id = f.film_id
    JOIN Film_Category fc ON f.film_id = fc.film_id
    JOIN Category c ON fc.category_id = c.category_id
    GROUP BY c.category_id, c.name, f.film_id, f.title
)
SELECT category_name, film_title, rental_count, rank
FROM RankedFilms
WHERE rank <= 3
ORDER BY category_name, rank;

-- The above query isn't working, so below is the workaround

SELECT category_name, film_title, rental_count
FROM (
    SELECT c.name AS category_name,
           f.title AS film_title,
           COUNT(r.rental_id) AS rental_count
    FROM Rental r
    JOIN Inventory i ON r.inventory_id = i.inventory_id
    JOIN Film f ON i.film_id = f.film_id
    JOIN Film_Category fc ON f.film_id = fc.film_id
    JOIN Category c ON fc.category_id = c.category_id
    GROUP BY c.category_id, f.film_id, c.name
) AS FilmCounts
WHERE rental_count >= (
    SELECT MIN(rental_count)
    FROM (
        SELECT COUNT(r.rental_id) AS rental_count
        FROM Rental r
        JOIN Inventory i ON r.inventory_id = i.inventory_id
        JOIN Film f ON i.film_id = f.film_id
        JOIN Film_Category fc ON f.film_id = fc.film_id
        JOIN Category c ON fc.category_id = c.category_id
        GROUP BY c.category_id, f.film_id
        ORDER BY rental_count DESC
        LIMIT 3
    ) AS Top3Films
)
ORDER BY category_name, rental_count DESC;

-- Q5 	Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers.

SELECT c.customer_id,
       c.first_name AS customer_first_name,
       c.last_name AS customer_last_name,
       COUNT(r.rental_id) AS total_rentals,
       AVG(COUNT(r.rental_id)) OVER () AS average_rentals,
       COUNT(r.rental_id) - AVG(COUNT(r.rental_id)) OVER () AS difference
FROM Customer c
JOIN Rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY difference DESC;

-- Q6 	 Find the monthly revenue trend for the entire rental store over time.

SELECT DATE_FORMAT(p.payment_date, '%Y-%m') AS month,
       SUM(p.amount) AS total_revenue
FROM Payment p
GROUP BY DATE_FORMAT(p.payment_date, '%Y-%m')
ORDER BY month;

-- Q7 	Identify the customers whose total spending on rentals falls within the top 20% of all customers.

WITH CustomerSpending AS (
    SELECT c.customer_id,
           c.first_name AS customer_first_name,
           c.last_name AS customer_last_name,
           SUM(p.amount) AS total_spent
    FROM Customer c
    JOIN Payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id
),
RankedCustomers AS (
    SELECT *,
           NTILE(5) OVER (ORDER BY total_spent DESC) AS spending_group
    FROM CustomerSpending
)
SELECT customer_id, customer_first_name, customer_last_name, total_spent
FROM RankedCustomers
WHERE spending_group = 1
ORDER BY total_spent DESC;

-- Q8 	Calculate the running total of rentals per category, ordered by rental count.

SELECT c.name AS category_name,
       COUNT(r.rental_id) AS rental_count,
       SUM(COUNT(r.rental_id)) OVER (PARTITION BY c.category_id ORDER BY COUNT(r.rental_id) DESC) AS running_total
FROM Rental r
JOIN Inventory i ON r.inventory_id = i.inventory_id
JOIN Film f ON i.film_id = f.film_id
JOIN Film_Category fc ON f.film_id = fc.film_id
JOIN Category c ON fc.category_id = c.category_id
GROUP BY c.category_id, c.name
ORDER BY c.name, rental_count DESC;

-- Q9	Find the films that have been rented less than the average rental count for their respective categories.

SELECT f.title AS film_title,
       c.name AS category_name,
       COUNT(r.rental_id) AS rental_count
FROM Rental r
JOIN Inventory i ON r.inventory_id = i.inventory_id
JOIN Film f ON i.film_id = f.film_id
JOIN Film_Category fc ON f.film_id = fc.film_id
JOIN Category c ON fc.category_id = c.category_id
GROUP BY f.film_id, c.category_id
HAVING COUNT(r.rental_id) < (
    SELECT AVG(films_by_category.rental_count)
    FROM (
        SELECT c_sub.category_id,
               COUNT(r_sub.rental_id) AS rental_count
        FROM Rental r_sub
        JOIN Inventory i_sub ON r_sub.inventory_id = i_sub.inventory_id
        JOIN Film f_sub ON i_sub.film_id = f_sub.film_id
        JOIN Film_Category fc_sub ON f_sub.film_id = fc_sub.film_id
        JOIN Category c_sub ON fc_sub.category_id = c_sub.category_id
        GROUP BY f_sub.film_id, c_sub.category_id
    ) AS films_by_category
    WHERE films_by_category.category_id = c.category_id); 	
    
-- Q10	Identify the top 5 months with the highest revenue and display the revenue generated in each month.

SELECT DATE_FORMAT(p.payment_date, '%Y-%m') AS month,
       SUM(p.amount) AS total_revenue
FROM Payment p
GROUP BY DATE_FORMAT(p.payment_date, '%Y-%m')
ORDER BY total_revenue DESC
LIMIT 5;



-- Normalisation & CTE

-- Q1 	First Normal Form (1NF):
-- a. Identify a table in the Sakila database that violates 1NF. Explain how you would normalize it to achieve 1NF

-- First Normal Form (1NF) is achieved when a table has the following properties:
-- 1. Each column contains atomic values (no multivalued or composite attributes).
-- 2. Rows are uniquely identified (typically using a primary key).

-- Table in Sakila Database That Violates 1NF
-- A potential table that violates 1NF in the Sakila database could be a hypothetical table where multiple values exist in a single column. For example:

-- customer_id  phone_numbers         
-- 1           123-456-7890, 987-654-3210
-- 2           555-123-4567

-- Violation:
- The `phone_numbers` column contains multiple phone numbers in a single field, violating the atomicity requirement of 1NF.

-- Steps to Normalize the Table to 1NF
-- To normalize the table to 1NF, you need to ensure that each column contains atomic values. Here’s how to achieve it:

-- 1. Create a Separate Row for Each Phone Number:
-- Split the `phone_numbers` column into individual rows, ensuring each value is stored separately.

-- 2. Design a New Table:
   - Move the phone numbers to a separate table, such as `Customer_Phone_Detail`.

-- 3. Ensure Each Row Has a Unique Identifier:
-- Use `customer_id` to link phone numbers to the respective customers.

-- Normalized Table: `Customer_Phone_Detail`
 
 -- customer_id  phone_number   
 -- 1            123-456-7890  
 -- 1            987-654-3210  
 -- 2            555-123-4567  

-- Q2 	 Second Normal Form (2NF):
--  a. Choose a table in Sakila and describe how you would determine whether it is in 2NF.  If it violates 2NF, explain the steps to normalize it.

-- Second Normal Form (2NF) builds upon First Normal Form (1NF) by ensuring that:
-- 1. The table is already in 1NF.
-- 2. There are **no partial dependencies**: Non-key attributes must depend on the **whole primary key**, not just part of it.


-- Example Table: `Film_Actor`
film_id (PK) actor_id (PK) actor_name  
1              101         Tom Hanks   
1              102         Meg Ryan    
2              103         Julia Roberts

Primary Key: The combination of `film_id` and `actor_id`.

-- Determining Whether the Table Is in 2NF

-- 1. **Is it in 1NF?
-- The `Film_Actor` table is in 1NF because each column contains atomic values, and rows are uniquely identified by the composite primary key (`film_id`, `actor_id`).

-- 2. Are there Partial Dependencies?
   -- In this case, the `actor_name` attribute depends only on `actor_id`, not on the full composite primary key (`film_id`, `actor_id`).
   -- This violates 2NF because `actor_name` is only partially dependent on `actor_id`.

-- Steps to Normalize the Table to 2NF
-- To eliminate partial dependencies, you should split the table into two tables 
-- so that non-key attributes depend on the whole key or move them to a table where they are properly associated with their determinant.

-- 1. Create a Separate Table for Actors:
--   - Move the `actor_name` attribute to a new table where `actor_id` is the primary key.

-- 2. Keep a Relationship Table:
   - Retain the relationship between `film_id` and `actor_id` in the `Film_Actor` table.

-- Normalized Tables in 2NF:
-- 1. `Actor`
-- actor_id** (PK) actor_name
-- 101                Tom Hanks  
-- 102                Meg Ryan   
-- 103                Julia Roberts

-- 2. `Film_Actor`
-- film_id (PK) actor_id (PK) |
	1                101              
	1                102              
	2                103              

-- Q3 	 Third Normal Form (3NF):
-- a. Identify a table in Sakila that violates 3NF. Describe the transitive dependencies present and outline the steps to normalize the table to 3NF.

-- Third Normal Form (3NF) ensures that:
-- 1. The table is already in Second Normal Form (2NF).
-- 2. There are no transitive dependencies: Non-key attributes must not depend on other non-key attributes.

-- Example Table in Sakila Database That Might Violate 3NF
-- Let’s consider the Film table as an example. This table may include attributes like:

-- film_id** (PK)  title        	language_id 	language_name
-- 1               Jurassic Park 		1           English      
-- 2               Spirited Away 		2           Japanese     
-- 3               Parasite      		2           Japanese     

-- Transitive Dependency:
In this case:
-- `language_name` depends on `language_id`, which is a non-key attribute. However, `language_name` does not directly depend on the primary key (`film_id`).
-- This violates 3NF because `language_name` is transitively dependent on the primary key through `language_id`.

-- Steps to Normalize the Table to 3NF
-- To eliminate the transitive dependency, you can split the table into two separate tables:

-- 1. Create a Language Table:
   -- Extract the language-related attributes (`language_id` and `language_name`) into a separate table where `language_id` is the primary key.

-- the normalization process using the Customer table in the Sakila database, transforming it step by step from an unnormalized form to Second Normal Form (2NF).

-- Step 1: Unnormalized Form (UNF)
-- The table might contain repeated groups or non-atomic values, such as multiple phone numbers or addresses combined in one column. For example:

-- Issues:
-- 		>> Non-atomic Values: The `phone_numbers` column contains multiple values in a single cell.
-- 		>> Repeated Groups: Phone numbers should ideally be separated into individual rows.

-- Step 2: First Normal Form (1NF)
-- To achieve **1NF**, we must:
-- 		1. Remove non-atomic values: Ensure each column contains atomic values (no multiple values in a single cell).
-- 		2. Eliminate repeated groups: Create a separate row for each unique combination.

-- Now the data is atomic, and repeated groups have been removed by splitting `phone_numbers` into a separate table.

-- Step 3: Second Normal Form (2NF)
-- To achieve 2NF, ensure the table is already in 1NF, and eliminate any partial dependencies:
-- 1. Check for composite primary keys (if any) and confirm all non-key attributes depend on the **whole primary key**, not part of it.

-- If the table `Customer_Address` contains attributes such as `city` and `country`, where these depend on only `address_id`, not on the composite key (`customer_id`, `address_id`), it violates 2NF.

-- Steps to Normalize to 2NF:
-- 		1. Split `city` and `country` into a new table, where `address_id` is the primary key.
-- 		2. Link `Customer` and `Address` tables using a foreign key.

-- Summary of Normalization:
-- 		1. 1NF:
-- 	   	- Remove non-atomic values and repeated groups.

-- 		2. 2NF:
--    	- Ensure non-key attributes depend on the entire primary key, not part of it.

-- This process ensures data integrity, reduces redundancy, and makes the tables scalable for future use.

-- Q5	CTE Basics:
-- a. Write a query using a CTE to retrieve the distinct list of actor names and the number of films they have acted in from the actor and film_actor tables.

WITH ActorFilmCount AS (
    SELECT a.actor_id,
           CONCAT(a.first_name, ' ', a.last_name) AS actor_name,
           COUNT(fa.film_id) AS film_count
    FROM Actor a
    JOIN Film_Actor fa ON a.actor_id = fa.actor_id
    GROUP BY a.actor_id, a.first_name, a.last_name)
SELECT actor_name, film_count
FROM ActorFilmCount
ORDER BY film_count DESC;

-- Q6 	 CTE with Joins:
-- a. Create a CTE that combines information from the film and language tables to display the film title, language name, and rental rate.

WITH FilmLanguageDetails AS (
    SELECT f.title AS film_title,
           l.name AS language_name,
           f.rental_rate
    FROM Film f
    JOIN Language l ON f.language_id = l.language_id
)
SELECT film_title, language_name, rental_rate
FROM FilmLanguageDetails
ORDER BY language_name, film_title;

-- Q7 	CTE for Aggregation:
-- a. Write a query using a CTE to find the total revenue generated by each customer (sum of payments) from the customer and payment tables.

WITH CustomerRevenue AS (
    SELECT c.customer_id,
           CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
           SUM(p.amount) AS total_revenue
    FROM Customer c
    JOIN Payment p ON c.customer_id = p.customer_id
    GROUP BY c.customer_id, c.first_name, c.last_name
)
SELECT customer_id, customer_name, total_revenue
FROM CustomerRevenue
ORDER BY total_revenue DESC;

-- Q8 	CTE with Window Functions:
-- a. Utilize a CTE with a window function to rank films based on their rental duration from the film table.

WITH FilmRankings AS (
    SELECT title AS film_title,
           rental_duration,
           RANK() OVER (ORDER BY rental_duration DESC) AS film_rank
    FROM Film
)
SELECT film_title, rental_duration, film_rank
FROM FilmRankings
ORDER BY film_rank;

-- Q9 	CTE and Filtering:
-- a. Create a CTE to list customers who have made more than two rentals, and then join this CTE with the customer table to retrieve additional customer details

WITH FrequentRenters AS (
    SELECT r.customer_id,
           COUNT(r.rental_id) AS rental_count
    FROM Rental r
    GROUP BY r.customer_id
    HAVING COUNT(r.rental_id) > 2
)
SELECT c.customer_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
       c.email,
       FrequentRenters.rental_count
FROM Customer c
JOIN FrequentRenters ON c.customer_id = FrequentRenters.customer_id
ORDER BY FrequentRenters.rental_count DESC;

-- Q10 	CTE for Date Calculations:
-- a. Write a query using a CTE to find the total number of rentals made each month, considering the rental_date from the rental table.

WITH MonthlyRentals AS (
    SELECT DATE_FORMAT(r.rental_date, '%Y-%m') AS rental_month,
           COUNT(r.rental_id) AS total_rentals
    FROM Rental r
    GROUP BY DATE_FORMAT(r.rental_date, '%Y-%m')
)
SELECT rental_month, total_rentals
FROM MonthlyRentals
ORDER BY rental_month;

-- Q11	CTE and Self-Join:
-- a. Create a CTE to generate a report showing pairs of actors who have appeared in the same film together, using the film_actor table.

WITH FilmActors AS (
    SELECT fa.actor_id,
           f.title AS film_title,
           CONCAT(a.first_name, ' ', a.last_name) AS actor_name
    FROM Film_Actor fa
    JOIN Actor a ON fa.actor_id = a.actor_id
    JOIN Film f ON fa.film_id = f.film_id
)
SELECT fa1.actor_name AS actor_1,
       fa2.actor_name AS actor_2,
       fa1.film_title
FROM FilmActors fa1
JOIN FilmActors fa2
    ON fa1.film_title = fa2.film_title
   AND fa1.actor_id < fa2.actor_id
ORDER BY fa1.film_title, fa1.actor_name, fa2.actor_name;

-- Q12 	CTE for Recursive Search:
-- a. Implement a recursive CTE to find all employees in the staff table who report to a specific manager, considering the reports_to column

WITH RECURSIVE EmployeeHierarchy AS (
    -- Anchor member: Start with the specific manager
    SELECT staff_id,
           first_name,
           last_name,
           manager_id
    FROM Staff
    WHERE staff_id = <manager_id> -- Replace <manager_id> with the desired manager ID

    UNION ALL

    -- Recursive member: Find employees who report to the manager or their subordinates
    SELECT s.staff_id,
           s.first_name,
           s.last_name,
           s.manager_id
    FROM Staff s
    JOIN EmployeeHierarchy eh ON s.manager_id = eh.staff_id
)
SELECT staff_id, first_name, last_name, manager_id
FROM EmployeeHierarchy
ORDER BY manager_id, staff_id;