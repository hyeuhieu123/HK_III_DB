USE ss13_3;

-- 2
CREATE TABLE transaction_log(
	log_id INT PRIMARY KEY AUTO_INCREMENT,
    log_message TEXT NOT NULL,
    log_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3
ALTER TABLE employees ADD COLUMN last_pay_date DATE NULL;

-- 4
DELIMITER //
CREATE PROCEDURE PaySalary(IN p_emp_id INT)
BEGIN
    DECLARE v_salary DECIMAL(10,2);
    DECLARE v_balance DECIMAL(15,2);
    DECLARE v_emp_exists INT;

    SELECT COUNT(*) INTO v_emp_exists FROM employees WHERE emp_id = p_emp_id;

    SELECT balance INTO v_balance FROM company_funds;

    SELECT salary INTO v_salary FROM employees WHERE emp_id = p_emp_id;

    START TRANSACTION;

    IF v_emp_exists = 0 THEN
        INSERT INTO transaction_log (log_message) 
        VALUES (CONCAT('Lỗi: Nhân viên ID ', p_emp_id, ' không tồn tại.'));
        ROLLBACK;
    ELSEIF v_balance < v_salary THEN
        INSERT INTO transaction_log (log_message) 
        VALUES (CONCAT('Lỗi: Quỹ công ty không đủ tiền để trả lương cho nhân viên ID ', p_emp_id));
        ROLLBACK;
    ELSE
        UPDATE company_funds SET balance = balance - v_salary;

        INSERT INTO payroll (emp_id, salary, pay_date) 
        VALUES (p_emp_id, v_salary, CURDATE());

        UPDATE employees SET last_pay_date = CURDATE() WHERE emp_id = p_emp_id;

        INSERT INTO transaction_log (log_message) 
        VALUES (CONCAT('Thành công: Đã trả ', v_salary, ' cho nhân viên ID ', p_emp_id));
        
        COMMIT;
    END IF;
END;
// DELIMITER ;

-- 5
SET SQL_SAFE_UPDATES = 0;
CALL PaySalary(1);