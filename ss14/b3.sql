CREATE DATABASE ss14_3;

USE ss14_3;

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

INSERT INTO customers (name, email, phone, address) VALUES
('Nguyễn Văn A', 'a@example.com', '0987654321', 'Hà Nội'),
('Trần Thị B', 'b@example.com', '0976543210', 'TP. Hồ Chí Minh'),
('Lê Văn C', 'c@example.com', '0965432109', 'Đà Nẵng');

INSERT INTO products (name, price, description) VALUES
('Laptop Dell XPS 15', 35000000, 'Laptop cao cấp dành cho dân văn phòng và designer'),
('iPhone 14 Pro Max', 27000000, 'Điện thoại flagship của Apple năm 2022'),
('Samsung Galaxy S23', 25000000, 'Điện thoại cao cấp của Samsung với màn hình Dynamic AMOLED');

INSERT INTO inventory (product_id, stock_quantity) VALUES
(1, 10),
(2, 15),
(3, 20);

INSERT INTO orders (customer_id, total_amount, status) VALUES
(1, 0, 'Pending'),
(2, 0, 'Pending'),
(3, 0, 'Pending');

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
CREATE PROCEDURE sp_create_order(
    IN p_customer_id INT,
    IN p_product_id INT,
    IN p_quantity INT,
    IN p_price DECIMAL(10,2)
)
BEGIN
    DECLARE v_stock INT;
    DECLARE v_order_id INT;
    
    START TRANSACTION;

    SELECT stock_quantity INTO v_stock FROM inventory WHERE product_id = p_product_id;

    IF v_stock < p_quantity THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không đủ hàng trong kho!';
        ROLLBACK;
    ELSE
        INSERT INTO orders (customer_id, total_amount, status) 
        VALUES (p_customer_id, 0, 'Pending');

        SET v_order_id = LAST_INSERT_ID();

        INSERT INTO order_items (order_id, product_id, quantity, price)
        VALUES (v_order_id, p_product_id, p_quantity, p_price);

        UPDATE inventory 
        SET stock_quantity = stock_quantity - p_quantity
        WHERE product_id = p_product_id;

        UPDATE orders 
        SET total_amount = (p_quantity * p_price)
        WHERE order_id = v_order_id;

        COMMIT;
    END IF;
END;
// DELIMITER ;

-- 3
DELIMITER //
CREATE PROCEDURE sp_pay_order(
    IN p_order_id INT,
    IN p_payment_method VARCHAR(20)
)
BEGIN
    DECLARE v_status ENUM('Pending', 'Completed', 'Cancelled');
    DECLARE v_total DECIMAL(10,2);

    START TRANSACTION;

    SELECT status, total_amount INTO v_status, v_total 
    FROM orders WHERE order_id = p_order_id;

    IF v_status <> 'Pending' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chỉ có thể thanh toán đơn hàng ở trạng thái Pending!';
        ROLLBACK;
    ELSE
        INSERT INTO payments (order_id, payment_date, amount, payment_method, status)
        VALUES (p_order_id, NOW(), v_total, p_payment_method, 'Completed');

        UPDATE orders 
        SET status = 'Completed' 
        WHERE order_id = p_order_id;

        COMMIT;
    END IF;
END;
// DELIMITER ;

-- 4
DELIMITER //
CREATE PROCEDURE sp_cancel_order(
    IN p_order_id INT
)
BEGIN
    DECLARE v_status ENUM('Pending', 'Completed', 'Cancelled');

    START TRANSACTION;

    SELECT status INTO v_status FROM orders WHERE order_id = p_order_id;

    IF v_status <> 'Pending' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Chỉ có thể hủy đơn hàng ở trạng thái Pending!';
        ROLLBACK;
    ELSE
        UPDATE inventory i
        JOIN order_items oi ON i.product_id = oi.product_id
        SET i.stock_quantity = i.stock_quantity + oi.quantity
        WHERE oi.order_id = p_order_id;

        DELETE FROM order_items WHERE order_id = p_order_id;

        UPDATE orders 
        SET status = 'Cancelled' 
        WHERE order_id = p_order_id;

        COMMIT;
    END IF;
END;
// DELIMITER ;

CALL sp_create_order(1, 2, 2, 500000);
CALL sp_pay_order(1, 'Credit Card');
CALL sp_cancel_order(2);

SELECT * FROM orders;
SELECT * FROM order_items;
SELECT * FROM inventory;
SELECT * FROM payments;

-- 5
DROP PROCEDURE IF EXISTS sp_create_order;
DROP PROCEDURE IF EXISTS sp_make_payment;
DROP PROCEDURE IF EXISTS sp_cancel_order;