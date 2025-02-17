USE ss12;

-- 2
CREATE TABLE price_changes(
	change_id INT PRIMARY KEY AUTO_INCREMENT,
    product VARCHAR(100) NOT NULL,
    old_price DECIMAL(10, 2) NOT NULL,
    new_price DECIMAL(10, 2) NOT NULL
);

-- 3
DELIMITER //
CREATE TRIGGER after_update_price
AFTER UPDATE ON orders
FOR EACH ROW
BEGIN
	INSERT INTO price_changes(product, old_price, new_price)
	VALUES (OLD.product, OLD.price, NEW.price);
END;
//
DELIMITER ;

-- 4
SET SQL_SAFE_UPDATES = 0;
UPDATE orders SET price = 1400.00 WHERE product = 'Laptop';
UPDATE orders SET price = 800.00 WHERE product = 'Smartphone';

-- 5
SELECT * FROM price_changes;