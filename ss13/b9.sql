CREATE DATABASE ss13_9;

USE ss13_9;

CREATE TABLE company_funds (
    fund_id INT PRIMARY KEY AUTO_INCREMENT,
    balance DECIMAL(15,2) NOT NULL -- Số dư quỹ công ty
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(50) NOT NULL,   -- Tên nhân viên
    salary DECIMAL(10,2) NOT NULL    -- Lương nhân viên
);

CREATE TABLE payroll (
    payroll_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,                      -- ID nhân viên (FK)
    salary DECIMAL(10,2) NOT NULL,   -- Lương được nhận
    pay_date DATE NOT NULL,          -- Ngày nhận lương
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

CREATE TABLE transaction_log(
	log_id INT PRIMARY KEY AUTO_INCREMENT,
    log_message TEXT NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE banks(
	bank_id INT PRIMARY KEY AUTO_INCREMENT,
    bank_name VARCHAR(255) NOT NULL,
    status ENUM('ACTIVE', 'ERROR') NOT NULL DEFAULT 'ACTIVE'
);


INSERT INTO company_funds (balance) VALUES (5000000.00);

INSERT INTO employees (emp_name, salary) VALUES
('Nguyễn Văn An', 5000.00),
('Trần Thị Bốn', 4000.00),
('Lê Văn Cường', 3500.00),
('Hoàng Thị Dung', 4500.00),
('Phạm Văn Em', 3800.00);

INSERT INTO banks (bank_name, status) VALUES 
('VietinBank', 'ACTIVE'),   
('Sacombank', 'ACTIVE'),    
('Agribank', 'ACTIVE');

-- 2
CREATE TABLE account (
    acc_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    bank_id INT,
    amount_added DECIMAL(10, 2),
    total_amount DECIMAL(10,2),
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id),
    FOREIGN KEY (bank_id) REFERENCES banks(bank_id)
);

-- 3
INSERT INTO account (emp_id, bank_id, amount_added, total_amount) VALUES
(1, 1, 0.00, 12500.00),  
(2, 1, 0.00, 8900.00),   
(3, 1, 0.00, 10200.00),  
(4, 1, 0.00, 15000.00),  
(5, 1, 0.00, 7600.00);

-- 4
DELIMITER //

CREATE PROCEDURE TransferSalaryAll()
BEGIN
    DECLARE v_emp_id INT;
    DECLARE v_salary DECIMAL(10,2);
    DECLARE v_bank_id INT;
    DECLARE v_balance DECIMAL(15,2);
    DECLARE v_total_salary DECIMAL(15,2);
    DECLARE v_total_employees INT DEFAULT 0;
    DECLARE v_error_message VARCHAR(255);
    DECLARE done INT DEFAULT 0;
    
    -- Cursor để duyệt danh sách nhân viên
    DECLARE cur CURSOR FOR 
    SELECT e.emp_id, e.salary, a.bank_id 
    FROM employees e
    JOIN account a ON e.emp_id = a.emp_id;

    -- Bắt lỗi
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
        SET v_error_message = 'FAILED: Xảy ra lỗi khi chuyển lương';
        INSERT INTO transaction_log (log_message) VALUES (v_error_message);
        ROLLBACK;
    END;

    -- Bắt lỗi khi hết dữ liệu trong con trỏ
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Bắt đầu transaction
    START TRANSACTION;

    -- Tính tổng số tiền cần chi trả
    SELECT SUM(salary) INTO v_total_salary FROM employees;

    -- Kiểm tra số dư quỹ công ty
    SELECT balance INTO v_balance FROM company_funds LIMIT 1;
    
    -- Nếu không đủ tiền, rollback và ghi log
    IF v_balance < v_total_salary THEN
        SET v_error_message = 'THẤT BẠI: Công ty không đủ tiền';
        INSERT INTO transaction_log (log_message) VALUES (v_error_message);
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Công ty không đủ tiền';
    END IF;

    -- Trừ tiền quỹ công ty trước khi trả lương
    UPDATE company_funds SET balance = balance - v_total_salary;

    -- Mở con trỏ
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO v_emp_id, v_salary, v_bank_id;
        IF done THEN 
            LEAVE read_loop;
        END IF;
        
        -- Kiểm tra trạng thái ngân hàng
        IF (SELECT status FROM banks WHERE bank_id = v_bank_id) = 'ERROR' THEN
            SET v_error_message = CONCAT('FAILED: Đã phát hiện lỗi ngân hàng cho nhân viên ', v_emp_id);
            INSERT INTO transaction_log (log_message) VALUES (v_error_message);
            ROLLBACK;
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Phát hiện lỗi ngân hàng';
        END IF;

        -- Thêm bản ghi vào payroll
        INSERT INTO payroll (emp_id, salary, pay_date) VALUES (v_emp_id, v_salary, CURDATE());

        -- Cập nhật tài khoản nhân viên
        UPDATE account 
        SET total_amount = total_amount + v_salary, 
            amount_added = v_salary
        WHERE emp_id = v_emp_id;

        -- Tăng số nhân viên nhận lương
        SET v_total_employees = v_total_employees + 1;
    END LOOP;

    -- Đóng con trỏ
    CLOSE cur;

    -- Ghi log tổng số nhân viên đã nhận lương
    INSERT INTO transaction_log (log_message) 
    VALUES (CONCAT('THÀNH CÔNG: Đã trả lương cho ', v_total_employees, ' nhân viên'));
    
    COMMIT;
END //

DELIMITER ;



-- 5
CALL TransferSalaryAll();

-- 6
SELECT * FROM company_funds;
SELECT * FROM payroll;
SELECT * FROM account;
SELECT * FROM transaction_log;