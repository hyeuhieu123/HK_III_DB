create database ontap;
use ontap;
create table users(
user_id int primary key auto_increment,
user_name varchar(50) not null unique,
user_fullname varchar(100) not null,
email varchar(100) not null unique,
user_address text,
user_phone varchar(20) not null unique
);
create table employees(
    emp_id CHAR(5) PRIMARY KEY,
    user_id INT NOT NULL UNIQUE,
    emp_position VARCHAR(50),
    emp_hire_date DATE,
    salary DECIMAL(10,2) NOT NULL CHECK (salary > 0),
    emp_status ENUM('đang làm', 'đang nghỉ') DEFAULT 'đang làm',
    FOREIGN KEY (user_id) REFERENCES users(user_id) 
);
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    order_date date,
    order_total_amount DECIMAL(10, 2),
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);
CREATE TABLE products (
    pro_id VARCHAR(5) PRIMARY KEY,
    pro_name VARCHAR(100) UNIQUE NOT NULL,
    pro_price DECIMAL(10, 2) NOT NULL CHECK (pro_price > 0),
    pro_quantity INT,
    pro_status ENUM('in_stock', 'out_of_stock') DEFAULT 'in_stock'
);
CREATE TABLE order_detail (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    pro_id VARCHAR(5),
    order_detail_quantity INT CHECK (order_detail_quantity > 0),
    order_detail_price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (pro_id) REFERENCES products(pro_id)
);
-- Thêm cột trạng thái đơn hàng (order_status) vào bảng tbl_orders:
alter table orders 
add column order_status enum('Pending', 'Processing', 'Completed', 'Cancelled');
-- Đổi kiểu dữ liệu cột phone_number trong bảng tbl_users thành VARCHAR(11):
alter table users
modify column user_phone varchar(11);
-- Xóa cột email khỏi bảng tbl_users:
alter table users
drop column email;
--  Thêm bản ghi vào bảng users:
INSERT INTO users (user_name, user_fullname, user_address, user_phone)
VALUES
('john_doe', 'John Doe', '123 Main St, City', '0123456789'),
('jane_smith', 'Jane Smith', '456 Oak Ave, City', '0987654321'),
('admin_user', 'Admin User', '789 Pine Rd, City', '0912345678');
-- Thêm bản ghi vào bảng employees:
INSERT INTO employees (emp_id, user_id, emp_position, emp_hire_date, salary, emp_status)
VALUES
('E001', 3, 'Manager', '2022-01-15', 5000.00, 'đang làm'),
('E002', 2, 'Sales Representative', '2023-03-01', 3000.00, 'đang làm'),
('E003', 1, 'Support Staff', '2021-06-20', 2500.00, 'đang nghỉ');
-- Thêm bản ghi vào bảng orders:
INSERT INTO orders (user_id, order_date, order_total_amount, order_status)
VALUES
(1, '2025-02-10', 250.00, 'Pending'),
(2, '2025-02-11', 150.50, 'Processing'),
(1, '2025-02-12', 320.75, 'Completed');
-- Thêm bản ghi vào bảng products:
INSERT INTO products (pro_id, pro_name, pro_price, pro_quantity, pro_status)
VALUES
('P001', 'Laptop', 500.00, 10, 'in_stock'),
('P002', 'Smartphone', 300.00, 20, 'in_stock'),
('P003', 'Headphones', 50.00, 50, 'in_stock');
INSERT INTO products (pro_id, pro_name, pro_price, pro_quantity, pro_status)
VALUES
('P004', 'Mobile', 500.00, 10, 'in_stock');
-- Thêm bản ghi vào bảng order_detail:
INSERT INTO order_detail (order_id, pro_id, order_detail_quantity, order_detail_price)
VALUES
(1, 'P001', 1, 500.00),
(1, 'P002', 1, 300.00),
(2, 'P003', 2, 50.00);
INSERT INTO order_detail (order_id, pro_id, order_detail_quantity, order_detail_price)
VALUES
(2, 'P001', 3, 500.00);
-- Viết truy vấn lấy danh sách tất cả các đơn hàng, bao gồm: Mã đơn hàng, ngày đặt hàng, tổng tiền, trạng thái đơn hàng.
select order_id,order_date,order_total_amount, order_status from orders;
-- Viết truy vấn lấy danh sách tên khách hàng đã đặt hàng, không trùng lặp
select distinct user_name
from users join orders
on users.user_id=orders.user_id
;
-- Viết truy vấn lấy danh sách tất cả sản phẩm đã từng được đặt hàng, hiển thị: Tên sản phẩm,số lượng đã bán.
select pro_name,sum(order_detail_quantity)
from products p join order_detail o
on p.pro_id=o.pro_id
group by  pro_name;
-- Viết truy vấn lấy tổng doanh thu từ từng sản phẩm, sắp xếp theo doanh thu giảm dần.
select pro_name,sum(order_detail_quantity*order_detail_price)
from products p join order_detail o
on p.pro_id=o.pro_id
group by  pro_name
order by sum(order_detail_quantity*order_detail_price) desc;
-- Viết truy vấn tìm số lượng đơn hàng của từng khách hàng, hiển thị: Tên khách hàng, số lượngđơn hàng đã đặt.
-- Viết truy vấn lấy danh sách 5 khách hàng có tổng giá trị đơn hàng cao nhất, hiển thị: tên kháchhàng, tổng tiền đã chi.
select user_name,sum(total_order_amount)
from orders o join users u
on u.user_id=o.user_id
order by sum(total_order_amount) desc limit 5;
-- cau 8
select user_name,emp_position,count( o.order_id)
from users u left join employees e 
on u.user_id=e.user_id
left join orders o on
o.user_id=u.user_id
group by user_name,emp_position;
-- Viết truy vấn lấy tên khách hàng có giá trị đơn hàng cao nhất, hiển thị: Tên khách hàng, tổng tiền
-- của đơn hàng lớn nhất mà họ đã đặt.
SELECT u.user_name, o.order_total_amount
FROM users u
JOIN orders o ON u.user_id = o.user_id
WHERE o.order_total_amount = (SELECT MAX(order_total_amount) FROM orders);
-- Viết truy vấn lấy tất cả sản phẩm chưa từng được đặt hàng, hiển thị: mã sản phẩm, tên sản phẩm,
-- số lượng tồn kho.
select p.pro_id,p.pro_name,p.pro_quantity
from products p left join order_detail o 
on p.pro_id=o.pro_id
where o.pro_id is null;