CREATE DATABASE ecom;

use ecom;

CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    customer_name VARCHAR(50),
    city VARCHAR(50),
    state VARCHAR(50),
    signup_date DATE
);


CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(100),
    category VARCHAR(50),
    price DECIMAL(10,2)
);


CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    payment_method VARCHAR(30),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


CREATE TABLE order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

INSERT INTO customers VALUES
(101, 'Rahul', 'Delhi', 'Delhi', '2025-01-10'),
(102, 'Priya', 'Mumbai', 'Maharashtra', '2025-02-15'),
(103, 'Amit', 'Pune', 'Maharashtra', '2025-03-20'),
(104, 'Neha', 'Bangalore', 'Karnataka', '2025-04-05'),
(105, 'Rohan', 'Delhi', 'Delhi', '2025-05-12');

INSERT INTO products VALUES
(1, 'Laptop', 'Electronics', 60000),
(2, 'Mobile', 'Electronics', 25000),
(3, 'Headphones', 'Electronics', 2000),
(4, 'Shoes', 'Fashion', 3000),
(5, 'Watch', 'Fashion', 5000);


INSERT INTO orders VALUES
(1001, 101, '2025-06-01', 'UPI'),
(1002, 102, '2025-06-05', 'Credit Card'),
(1003, 103, '2025-06-10', 'UPI'),
(1004, 101, '2025-06-15', 'Cash'),
(1005, 104, '2025-07-01', 'UPI'),
(1006, 105, '2025-07-10', 'Credit Card');


INSERT INTO order_details VALUES
(1, 1001, 1, 1),
(2, 1001, 3, 2),
(3, 1002, 2, 1),
(4, 1003, 4, 2),
(5, 1004, 5, 1),
(6, 1005, 1, 1),
(7, 1006, 2, 2);

##Q1. Find total revenue

SELECT 
    SUM(p.price * od.quantity) AS total_revenue
FROM order_details od
JOIN products p
ON od.product_id = p.product_id;

Q2. Find revenue by product


SELECT 
    p.product_name,
    SUM(p.price * od.quantity) AS revenue
FROM order_details od
JOIN products p
ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY revenue DESC;

Q3. Find best-selling products


SELECT 
    p.product_name,
    SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN products p
ON od.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_quantity DESC;

Q4. Find sales by category

SELECT 
    p.category,
    SUM(p.price * od.quantity) AS revenue
FROM order_details od
JOIN products p
ON od.product_id = p.product_id
GROUP BY p.category
ORDER BY revenue DESC;


Q5. Find top customers

SELECT 
    c.customer_name,
    SUM(p.price * od.quantity) AS total_spending
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_details od
ON o.order_id = od.order_id
JOIN products p
ON od.product_id = p.product_id
GROUP BY c.customer_name
ORDER BY total_spending DESC;

Q6. Find sales by city
SELECT 
    c.city,
    SUM(p.price * od.quantity) AS revenue
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_details od
ON o.order_id = od.order_id
JOIN products p
ON od.product_id = p.product_id
GROUP BY c.city
ORDER BY revenue DESC;

Q7. Find average order value
SELECT 
    AVG(order_total) AS average_order_value
FROM (
    SELECT 
        o.order_id,
        SUM(p.price * od.quantity) AS order_total
    FROM orders o
    JOIN order_details od
    ON o.order_id = od.order_id
    JOIN products p
    ON od.product_id = p.product_id
    GROUP BY o.order_id
) AS sales;

