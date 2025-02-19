CREATE DATABASE comparison_db;

USE comparison_db;

-- myisam ko ho tro giao dich
CREATE TABLE sales_myisam (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    item VARCHAR(255),
    price DECIMAL(10,2)
) ENGINE=MyISAM;

START TRANSACTION;
INSERT INTO sales_myisam (item, price) VALUES ('Laptop', 1500.00);
ROLLBACK; -- ko co tac dung, du lieu van luu

-- innodb ho tro giao dich
CREATE TABLE sales_innodb (
    sale_id INT AUTO_INCREMENT PRIMARY KEY,
    item VARCHAR(255),
    price DECIMAL(10,2)
) ENGINE=InnoDB;

START TRANSACTION;
INSERT INTO sales_innodb (item, price) VALUES ('Laptop', 1500.00);
ROLLBACK; -- du lieu ko duoc luu

-- myisam khoa toan bo bang
CREATE TABLE customers_myisam (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    age INT
) ENGINE=MyISAM;

START TRANSACTION;
UPDATE customers_myisam SET age = 35 WHERE customer_id = 1;
-- toan bo bang bi khoa

-- innodb khoa theo dong
CREATE TABLE customers_innodb (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100),
    age INT
) ENGINE=InnoDB;

START TRANSACTION;
UPDATE customers_innodb SET age = 35 WHERE customer_id = 1;
-- chi khoa dong co customer_id = 1

-- myisam nhanh hon voi fulltext
CREATE TABLE articles_myisam (
    article_id INT AUTO_INCREMENT PRIMARY KEY,
    headline VARCHAR(255),
    content TEXT,
    FULLTEXT(headline, content)
) ENGINE=MyISAM;

SELECT * FROM articles_myisam WHERE MATCH(headline, content) AGAINST ('database');

-- innodb ho tro like nhung ko toi uu
CREATE TABLE articles_innodb (
    article_id INT AUTO_INCREMENT PRIMARY KEY,
    headline VARCHAR(255),
    content TEXT
) ENGINE=InnoDB;

SELECT * FROM articles_innodb WHERE headline LIKE '%database%';

-- myisam ghi cham hon khi co nhieu giao dich
INSERT INTO customers_myisam (full_name, age) VALUES ('Tran Van C', 29);
-- ko co rollback neu loi

-- innodb ho tro giao dich giup ghi nhanh hon
START TRANSACTION;
INSERT INTO customers_innodb (full_name, age) VALUES ('Le Thi D', 32);
COMMIT;

-- myisam ko ho tro khoa ngoai
CREATE TABLE orders_myisam (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers_myisam(customer_id) -- loi do myisam ko ho tro
) ENGINE=MyISAM;

-- innodb ho tro khoa ngoai
CREATE TABLE orders_innodb (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    FOREIGN KEY (customer_id) REFERENCES customers_innodb(customer_id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- myisam ko ho tro rollback
START TRANSACTION;
INSERT INTO sales_myisam (item, price) VALUES ('Tablet', 700.00);
ROLLBACK; -- ko co tac dung

-- innodb co the rollback
START TRANSACTION;
INSERT INTO sales_innodb (item, price) VALUES ('Tablet', 700.00);
ROLLBACK; -- du lieu ko duoc luu

-- myisam toi uu cho truy van doc, ko ho tro giao dich va khoa ngoai
-- innodb ho tro acid, khoa ngoai, rollback, ghi nhanh hon khi co nhieu thao tac
