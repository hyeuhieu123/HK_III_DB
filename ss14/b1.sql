CREATE DATABASE ss14_1;

USE ss14_1;

-- 1. Bảng customers (Khách hàng)
CREATE TABLE customers (
    customer_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Bảng orders (Đơn hàng)
CREATE TABLE orders (
    order_id INT PRIMARY KEY AUTO_INCREMENT,
    customer_id INT NOT NULL,
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0,
    status ENUM('Pending', 'Completed', 'Cancelled') DEFAULT 'Pending',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);

-- 3. Bảng products (Sản phẩm)
CREATE TABLE products (
    product_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Bảng order_items (Chi tiết đơn hàng)
CREATE TABLE order_items (
    order_item_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- 5. Bảng inventory (Kho hàng)
CREATE TABLE inventory (
    product_id INT PRIMARY KEY,
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES products(product_id) ON DELETE CASCADE
);

-- 6. Bảng payments (Thanh toán)
CREATE TABLE payments (
    payment_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    amount DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash') NOT NULL,
    status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- Thêm dữ liệu vào bảng customers (Khách hàng)
INSERT INTO customers (name, email, phone, address) VALUES
('Nguyễn Văn A', 'nguyenvana@example.com', '0987654321', 'Hà Nội'),
('Trần Thị B', 'tranthib@example.com', '0978123456', 'TP. Hồ Chí Minh'),
('Lê Văn C', 'levanc@example.com', '0911222333', 'Đà Nẵng');

-- Thêm dữ liệu vào bảng products (Sản phẩm)
INSERT INTO products (name, price, description) VALUES
('Laptop Dell XPS 15', 35000000, 'Laptop cao cấp dành cho dân văn phòng và designer'),
('iPhone 14 Pro Max', 27000000, 'Điện thoại flagship của Apple năm 2022'),
('Samsung Galaxy S23', 25000000, 'Điện thoại cao cấp của Samsung với màn hình Dynamic AMOLED');

-- Thêm dữ liệu vào bảng inventory (Kho hàng)
INSERT INTO inventory (product_id, stock_quantity) VALUES
(1, 10),
(2, 15),
(3, 20);

-- Thêm dữ liệu vào bảng orders (Đơn hàng)
INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 0, 'Pending'),
(2, 0, 'Pending'),
(3, 0, 'Pending');

-- Thêm dữ liệu vào bảng order_items (Chi tiết đơn hàng)
INSERT INTO order_items (order_id, product_id, quantity, price) VALUES
(1, 1, 2, 35000000),  -- 2 Laptop Dell XPS 15
(1, 2, 1, 27000000),  -- 1 iPhone 14 Pro Max
(2, 3, 3, 25000000),  -- 3 Samsung Galaxy S23
(3, 1, 1, 35000000);  -- 1 Laptop Dell XPS 15

-- Thêm dữ liệu vào bảng payments (Thanh toán)
INSERT INTO payments (order_id, amount, payment_method, status) VALUES
(1, 97000000, 'Credit Card', 'Completed'),
(2, 75000000, 'PayPal', 'Pending'),
(3, 35000000, 'Cash', 'Completed');

-- 2
DELIMITER //
CREATE TRIGGER before_insert_order_item
BEFORE INSERT ON order_items
FOR EACH ROW
BEGIN
    DECLARE stock INT;
    SELECT stock_quantity INTO stock FROM inventory WHERE product_id = NEW.product_id;
    IF stock IS NULL OR stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không đủ hàng trong kho!';
    END IF;
END;
// DELIMITER ;

-- 3
DELIMITER //
CREATE TRIGGER after_insert_order_item
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET total_amount = total_amount + (NEW.price * NEW.quantity)
    WHERE order_id = NEW.order_id;
END;
// DELIMITER ;

-- 4
DELIMITER //
CREATE TRIGGER before_update_order_item
BEFORE UPDATE ON order_items
FOR EACH ROW
BEGIN
    DECLARE stock INT;
    SELECT stock_quantity INTO stock FROM inventory WHERE product_id = NEW.product_id;
    IF stock IS NULL OR stock < NEW.quantity THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không đủ hàng trong kho để cập nhật số lượng!';
    END IF;
END;
// DELIMITER ;

-- 5
DELIMITER //
CREATE TRIGGER after_update_order_item
AFTER UPDATE ON order_items
FOR EACH ROW
BEGIN
    UPDATE orders
    SET total_amount = total_amount - (OLD.price * OLD.quantity) + (NEW.price * NEW.quantity)
    WHERE order_id = NEW.order_id;
END;
// DELIMITER ;

-- 6
DELIMITER //
CREATE TRIGGER before_delete_order
BEFORE DELETE ON orders
FOR EACH ROW
BEGIN
    IF OLD.status = 'Completed' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Không thể xóa đơn hàng đã thanh toán!';
    END IF;
END;
// DELIMITER ;

-- 7
DELIMITER //
CREATE TRIGGER after_delete_order_item
AFTER DELETE ON order_items
FOR EACH ROW
BEGIN
    UPDATE inventory
    SET stock_quantity = stock_quantity + OLD.quantity
    WHERE product_id = OLD.product_id;
END;
// DELIMITER ;

-- Cập nhật tổng tiền trong bảng orders
SET SQL_SAFE_UPDATES = 0;
UPDATE orders 
SET total_amount = (
    SELECT SUM(quantity * price) 
    FROM order_items 
    WHERE orders.order_id = order_items.order_id
);

SELECT * FROM customers;
SELECT * FROM products;
SELECT * FROM inventory;
SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM payments;

-- 8
DROP TRIGGER IF EXISTS before_insert_order_item;
DROP TRIGGER IF EXISTS after_insert_order_item;
DROP TRIGGER IF EXISTS before_update_order_item;
DROP TRIGGER IF EXISTS after_update_order_item;
DROP TRIGGER IF EXISTS before_delete_order;
DROP TRIGGER IF EXISTS after_delete_order_item;