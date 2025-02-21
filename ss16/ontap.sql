create database quanlybanhang;
use quanlybanhang;
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    address VARCHAR(255) NULL
);

CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(100) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL CHECK (quantity >= 0),
    category VARCHAR(50) NOT NULL
);
CREATE TABLE Employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    birthday DATE Not NULL,
    position VARCHAR(50) NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    revenue DECIMAL(10,2) DEFAULT 0
);
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    employee_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);
CREATE TABLE OrderDetails (
    order_detail_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id),
    FOREIGN KEY (product_id) REFERENCES Products(product_id)
);
alter table Customers  add column email varchar(100) not null unique;
alter table Employees drop column birthday;
-- 4
-- Chèn dữ liệu vào bảng Customers
INSERT INTO Customers (customer_name, phone, address, email) VALUES
('Nguyễn Văn A', '0987654321', 'Hà Nội', 'nguyenvana@example.com'),
('Trần Thị B', '0971234567', 'TP.HCM', 'tranthib@example.com'),
('Lê Văn C', '0966543210', 'Đà Nẵng', 'levanc@example.com'),
('Phạm Thị D', '0954321678', 'Hải Phòng', 'phamthid@example.com'),
('Hoàng Văn E', '0943216789', 'Cần Thơ', 'hoangvane@example.com');

-- Chèn dữ liệu vào bảng Products
INSERT INTO Products (product_name, price, quantity, category) VALUES
('Laptop Dell', 20000000, 10, 'Electronics'),
('Điện thoại iPhone', 25000000, 15, 'Electronics'),
('Bàn phím cơ', 1500000, 30, 'Accessories'),
('Chuột gaming', 800000, 25, 'Accessories'),
('Tivi Sony', 15000000, 8, 'Electronics');

-- Chèn dữ liệu vào bảng Employees
INSERT INTO Employees (employee_name, position, salary, revenue) VALUES
('Nguyễn Văn M', 'Nhân viên bán hàng', 7000000, 1000000),
('Trần Thị N', 'Quản lý', 12000000, 3000000),
('Lê Văn P', 'Nhân viên giao hàng', 6000000, 500000),
('Phạm Thị Q', 'Nhân viên tư vấn', 8000000, 1500000),
('Hoàng Văn R', 'Nhân viên kho', 6500000, 700000);

-- Chèn dữ liệu vào bảng Orders
INSERT INTO Orders (customer_id, employee_id, order_date, total_amount) VALUES
(1, 2, '2024-02-01 10:30:00', 20000000),
(2, 1, '2024-02-02 14:15:00', 25000000),
(3, 3, '2024-02-03 09:45:00', 1500000),
(4, 4, '2024-02-04 16:20:00', 800000),
(5, 5, '2024-02-05 11:00:00', 15000000);

-- Chèn dữ liệu vào bảng OrderDetails
INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 20000000),
(2, 2, 1, 25000000),
(3, 3, 1, 1500000),
(4, 4, 1, 800000),
(5, 5, 1, 15000000);

INSERT INTO Orders (customer_id, employee_id, order_date, total_amount) 
VALUES (1, 3, '2024-02-06 15:45:00', 18000000);
INSERT INTO OrderDetails (order_id, product_id, quantity, unit_price) VALUES
(6, 3, 2, 1500000), -- 2 Bàn phím cơ, mỗi cái 1.500.000 VND
(6, 4, 1, 800000);  -- 1 Chuột gaming, giá 800.000 VND

-- 5
select * from Customers;

update Products set product_name="Products",price = 99.99 where product_id = 1 ;

select od.order_id,cs.customer_name,ep.employee_name,od.total_amount,od.order_date from orders od 
join Customers cs on od.customer_id=cs.customer_id
join Employees ep on od.employee_id=ep.employee_id;
-- 6
--  6.1 Đếm số lượng đơn hàng của mỗi khách hàng. Thông tin gồm : mã khách hàng, tên khách hàng, tổng số đơn 
select cs.customer_id,cs.customer_name,count(od.order_id) as tongsodon  from orders od join Customers cs on od.customer_id=cs.customer_id group by  cs.customer_id;
-- 6.2 Thống kê tổng doanh thu của từng nhân viên trong năm hiện tại. Thông tin gồm : mã nhân viên, tên nhân viên, doanh thu 
select ep.employee_id,ep.employee_name,sum(od.total_amount) as tongdoanhthu  from orders od join Employees ep on od.employee_id=ep.employee_id group by  ep.employee_id;
-- 6.3
/*
Thống kê những sản phẩm có số lượng đặt hàng lớn hơn 100 trong tháng hiện tại. Thông tin gồm : mã sản phẩm, tên sản phẩm, số lượt đặt và sắp xếp theo số lượng giảm dần 
*/
select pd.product_id,pd.product_name,sum(odd.quantity) as tongsosanpham from Products pd
join OrderDetails odd on odd.product_id=pd.product_id
join Orders od on odd.order_id=od.order_id
where month(od.order_date)=month(curdate())  group by pd.product_id having tongsosanpham>1 order by  tongsosanpham desc;
-- 7
/*
7.1 Lấy danh sách khách hàng chưa từng đặt hàng. Thông tin gồm : mã khách hàng và tên khách hàng 
*/
select * from customers 
left join (select customer_id from orders group by customer_id) as subquery on subquery.customer_id=customers.customer_id 
where subquery.customer_id is null;
/*
7.2 Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm 
*/
select * from products where price>(select avg(price) as gia_trung_binh from products);
/*
7.3 Tìm những khách hàng có mức chi tiêu cao nhất.Thông tin gồm : mã khách hàng, tên khách hàng và tổng chi tiêu .(Nếu các khách hàng có cùng mức chi tiêu thì lấy hết) 
*/
select  cs.customer_id,cs.customer_name,sum(total_amount) as tongtien1 from customers cs 
join Orders od on cs.customer_id=od.customer_id  group by cs.customer_id
having tongtien1=(select max(subquery.tongtien) from (select sum(total_amount) as tongtien from Orders group by customer_id) as subquery);
-- 8
-- 1
create view view_order_list as
select od.order_id, cs.customer_name, ep.employee_name, od.total_amount, 
od.order_date
from orders od
join customers cs on od.customer_id = cs.customer_id
join employees ep on od.employee_id = ep.employee_id
order by od.order_date desc;
-- 2
create view view_order_detail_product as
select odd.order_detail_id, pd.product_name, odd.quantity, odd.unit_price
from orderdetails odd
join products pd on odd.product_id = pd.product_id
order by odd.quantity desc;
-- 9
-- 1
DELIMITER //
CREATE PROCEDURE proc_insert_employee(
    IN emp_name VARCHAR(100),
    IN emp_position VARCHAR(50),
    IN emp_salary DECIMAL(10,2)
)
BEGIN
    INSERT INTO Employees (employee_name, position, salary, revenue)
    VALUES (emp_name, emp_position, emp_salary, 0);
    SELECT LAST_INSERT_ID() AS new_employee_id;
END //
DELIMITER ;
CALL proc_insert_employee('Nguyễn Văn A', 'Nhân viên kinh doanh', 10000000);
-- 2
DELIMITER //
CREATE PROCEDURE proc_get_orderdetails(IN order_id_param INT)
BEGIN
    SELECT odd.order_detail_id, odd.order_id, pd.product_name, odd.quantity, odd.unit_price
    FROM OrderDetails odd
    JOIN Products pd ON odd.product_id = pd.product_id
    WHERE odd.order_id = order_id_param;
END //
DELIMITER ;
-- 3
DELIMITER //
CREATE PROCEDURE proc_cal_total_amount_by_order(IN order_id_param INT)
BEGIN
    SELECT COUNT(DISTINCT product_id) AS total_product_types
    FROM OrderDetails
    WHERE order_id = order_id_param;
END //
DELIMITER ;
-- 10
DELIMITER //
CREATE TRIGGER trigger_after_insert_order_details
AFTER INSERT ON OrderDetails
FOR EACH ROW
BEGIN
    DECLARE current_stock INT;
    SELECT quantity INTO current_stock
    FROM Products
    WHERE product_id = NEW.product_id;
    IF current_stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số lượng sản phẩm trong kho không đủ';
    ELSE
        UPDATE Products SET quantity = quantity - NEW.quantity WHERE product_id = NEW.product_id;
    END IF;
END //
DELIMITER ;
-- 11
delimiter //
create procedure proc_insert_order_details(in order_id_param int,in product_id_param int,in quantity_param int,in unit_price_param decimal(10,2))
begin
    declare current_stock int;
    start transaction;
    select quantity into current_stock from products where product_id = product_id_param;
    if current_stock < quantity_param then
        signal sqlstate '45000'
        set message_text = 'Số lượng sản phẩm trong kho không đủ';
    else
        insert into orderdetails (order_id, product_id, quantity, unit_price)values (order_id_param, product_id_param, quantity_param, unit_price_param);
        update products set quantity = quantity - quantity_param where product_id = product_id_param;
        commit;
    end if;
end //
delimiter ;