CREATE DATABASE ss5; 
USE ss5;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY, 
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(255)
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY, 
    customer_id INT, 
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    order_status VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
);


INSERT INTO customers (customer_name, email, phone, address)
VALUES
('Nguyen Van An', 'nguyenvanan@example.com', '0901234567', '123 Le Loi, TP.HCM'),
('Tran Thi Bich', 'tranthibich@example.com', '0912345678', '456 Nguyen Hue, TP.HCM'),
('Le Van Cuong', 'levancuong@example.com', '0923456789', '789 Dien Bien Phu, Ha Noi');

INSERT INTO orders (customer_id, order_date, total_amount, order_status)
VALUES
(1, '2025-01-10', 500000, 'Pending'),
(1, '2025-01-12', 325000, 'Completed'),
(NULL, '2025-01-13', 450000, 'Cancelled'),
(3, '2025-01-14', 270000, 'Pending'),
(2, '2025-01-16', 850000, NULL);
select
    od.order_id, 
    od.order_date, 
    od.total_amount, 
    cs.customer_name, 
    cs.email
from orders od
left join customers cs on  od.customer_id = cs.customer_id;
select
    cs.customer_id, 
    cs.customer_name, 
    cs.phone, 
    od.order_id, 
    od.order_status
from customers cs
left join orders od ON cs.customer_id = od.customer_id;
select
    cs.customer_id, 
    cs.customer_name, 
    od.order_id, 
    od.total_amount, 
    od.order_date
FROM customers cs
INNER JOIN orders od ON cs.customer_id = od.customer_id;