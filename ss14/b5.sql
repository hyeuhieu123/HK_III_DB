CREATE DATABASE ss14_5;

USE ss14_5;

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
CREATE TRIGGER before_insert_payment
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE order_total DECIMAL(10,2);

    SELECT total_amount INTO order_total 
    FROM orders 
    WHERE order_id = NEW.order_id;

    IF NEW.amount <> order_total THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số tiền thanh toán không khớp với tổng đơn hàng!';
    END IF;
END;
// DELIMITER ;

-- 3
CREATE TABLE order_logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    old_status ENUM('Pending', 'Completed', 'Cancelled'),
    new_status ENUM('Pending', 'Completed', 'Cancelled'),
    log_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE
);

-- 4
DELIMITER //
CREATE TRIGGER after_update_order_status
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
    IF OLD.status <> NEW.status THEN
        INSERT INTO order_logs (order_id, old_status, new_status, log_date)
        VALUES (NEW.order_id, OLD.status, NEW.status, NOW());
    END IF;
END;
// DELIMITER ;

-- 5
DELIMITER //
CREATE TRIGGER before_insert_check_payment
BEFORE INSERT ON payments
FOR EACH ROW
BEGIN
    DECLARE order_total DECIMAL(10,2);

    SELECT total_amount INTO order_total
    FROM orders
    WHERE order_id = NEW.order_id;

    IF NEW.amount <> order_total THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Số tiền thanh toán không khớp với tổng đơn hàng!';
    END IF;
END;
// DELIMITER ;

DELIMITER //
CREATE PROCEDURE sp_update_order_status_with_payment(
    IN p_order_id INT,
    IN p_new_status ENUM('Pending', 'Completed', 'Cancelled'),
    IN p_payment_method ENUM('Credit Card', 'PayPal', 'Bank Transfer', 'Cash'),
    IN p_amount DECIMAL(10,2)
)
BEGIN
    DECLARE current_status ENUM('Pending', 'Completed', 'Cancelled');
    DECLARE order_total DECIMAL(10,2);

    START TRANSACTION;

    SELECT status INTO current_status
    FROM orders
    WHERE order_id = p_order_id;

    IF current_status = p_new_status THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Đơn hàng đã có trạng thái này!';
    END IF;

    IF p_new_status = 'Completed' THEN
        -- Lấy tổng tiền đơn hàng
        SELECT total_amount INTO order_total
        FROM orders
        WHERE order_id = p_order_id;

        IF p_amount <> order_total THEN
            SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Số tiền thanh toán không khớp với tổng đơn hàng!';
        END IF;

        INSERT INTO payments (order_id, payment_date, amount, payment_method, status)
        VALUES (p_order_id, NOW(), p_amount, p_payment_method, 'Completed');
    END IF;

    UPDATE orders
    SET status = p_new_status
    WHERE order_id = p_order_id;
    
    COMMIT;
END;
// DELIMITER ;

-- 6
CALL sp_update_order_status_with_payment(1, 'Completed', 'Credit Card', 10000000);

-- 7
SELECT * FROM order_logs;

-- 8
DROP TRIGGER IF EXISTS before_insert_check_payment;
DROP TRIGGER IF EXISTS after_update_order_status;
DROP PROCEDURE IF EXISTS sp_update_order_status_with_payment;