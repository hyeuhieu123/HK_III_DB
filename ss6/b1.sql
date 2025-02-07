-- Tạo và sử dụng database
CREATE DATABASE ss6;
USE ss6;

-- Tạo bảng Orders
CREATE TABLE Orders (
    OrderID INT AUTO_INCREMENT PRIMARY KEY,              
    Customer_Name VARCHAR(100) NOT NULL,                 
    Product_Name VARCHAR(100) NOT NULL,                  
    Quantity INT NOT NULL CHECK (Quantity > 0),         
    Price DECIMAL(10, 2) NOT NULL CHECK (Price > 0),    
    Order_Date DATE NOT NULL                             
);

-- Thêm giá trị vào bảng Orders
INSERT INTO Orders (Customer_Name, Product_Name, Quantity, Price, Order_Date)
VALUES
    ('Nguyen Van A', 'Laptop', 1, 15000000, '2025-01-01'),
    ('Tran Thi B', 'Smartphone', 2, 8000000, '2025-01-01'),
    ('Nguyen Van A', 'Headphones', 3, 2000000, '2025-01-03'),
    ('Le Van C', 'Laptop', 1, 15000000, '2025-01-01'),
    ('Nguyen Van A', 'Smartphone', 1, 8000000, '2025-01-05'),
    ('Tran Thi B', 'Headphones', 1, 2000000, '2025-01-05'),
    ('Le Van C', 'Smartphone', 3, 8000000, '2025-01-07'),
    ('Tran Thi B', 'Laptop', 1, 15000000, '2025-01-03');

-- 2
select customer_name, sum(quantity) as total_quantity 
from orders
group by customer_name;

-- 3
select product_name, max(price) as max_price 
from orders
group by product_name;

-- 4
select order_date, count(*) as total_orders
from orders 
group by order_date;

-- 5
select customer_name, min(price) as min_price 
from orders
group by customer_name;