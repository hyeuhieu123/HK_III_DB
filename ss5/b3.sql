USE ss5;

CREATE TABLE customers1 (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    custmer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    phone VARCHAR(15),
    address VARCHAR(255)
);

CREATE TABLE orders1 (
    order_id INT AUTO_INCREMENT PRIMARY KEY, 
    customer_id INT, 
    order_date DATE NOT NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    orders1_status  VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) 
);


INSERT INTO customers1 (custmer_name, email, phone, address)
VALUES
('Nguyen Van An', 'nguyenvanan@example.com', '0901234567', '123 Le Loi, TP.HCM'),
('Tran Thi Bich', 'tranthibich@example.com', '0912345678', '456 Nguyen Hue, TP.HCM'),
('Le Van Cuong', 'levancuong@example.com', '0923456789', '789 Dien Bien Phu, Ha Noi');

INSERT INTO orders1 (customer_id, order_date, total_amount,orders1_status)
VALUES
(1, '2025-01-10', 500000, 'Pending'),
(1, '2025-01-12', 325000, 'Completed'),
(NULL, '2025-01-13', 450000, 'Cancelled'),
(3, '2025-01-14', 270000, 'Pending'),
(2, '2025-01-16', 850000, NULL);
select c.custmer_name, c.phone, o.order_id, o.total_amount from  orders1 o join  customers1 c on  o.customer_id = c.customer_id where o.orders1_status = 'Pending'  and o.total_amount>300000;
select c.custmer_name , c.email, o.order_id from orders1 o join customers1 c ON o.customer_id = c.customer_id where o.orders1_status = 'Completed' or o.orders1_status is null;
select
    c.custmer_name,
    c.address, 
    o.order_id, 
    o.orders1_status
from orders1 o join customers1 c on o.customer_id = c.customer_id where o.orders1_status in ('Pending', 'Cancelled');
select
    c.cstomer_name, 
    c.phone, 
    o.order_id, 
    o.total_amount
from orders1 o
join customers1 c on o.customer_id = c.customer_id
where o.total_amount between 300000 and 600000;