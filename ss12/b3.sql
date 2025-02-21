USE ss12;

-- 2
CREATE TABLE deleted_orders(
	deleted_id INT PRIMARY KEY AUTO_INCREMENT,
    order_id INT NOT NULL,
    customer_name VARCHAR(100) NOT NULL,
    product VARCHAR(100) NOT NULL,
    order_date DATE NOT NULL,
    deleted_at DATETIME NOT NULL
);

-- 3
DELIMITER //
CREATE TRIGGER after_delete_order
AFTER DELETE ON orders
FOR EACH ROW
BEGIN
    INSERT INTO deleted_orders(order_id, customer_name, product, order_date, deleted_at)
    VALUES (OLD.order_id, OLD.customer_name, OLD.product, OLD.order_date, NOW());
END;
//
DELIMITER ;

-- 4
SET SQL_SAFE_UPDATES = 0;
DELETE FROM orders WHERE order_id = 4;
DELETE FROM orders WHERE order_id = 5;

-- 5
SELECT * FROM deleted_orders;