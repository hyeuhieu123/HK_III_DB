CREATE DATABASE ss14_4;

USE ss14_4;

-- 1. Bảng departments (Phòng ban)
CREATE TABLE departments (
    department_id INT PRIMARY KEY AUTO_INCREMENT,
    department_name VARCHAR(255) NOT NULL
);

-- 2. Bảng employees (Nhân viên)
CREATE TABLE employees (
    employee_id INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    phone VARCHAR(20),
    hire_date DATE NOT NULL,
    department_id INT NOT NULL,
    FOREIGN KEY (department_id) REFERENCES departments(department_id) ON DELETE CASCADE
);

-- 3. Bảng attendance (Chấm công)
CREATE TABLE attendance (
    attendance_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    check_in_time DATETIME NOT NULL,
    check_out_time DATETIME,
    total_hours DECIMAL(5,2),
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- 4. Bảng salaries (Bảng lương)
CREATE TABLE salaries (
    employee_id INT PRIMARY KEY,
    base_salary DECIMAL(10,2) NOT NULL,
    bonus DECIMAL(10,2) DEFAULT 0,
    last_updated TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

-- 5. Bảng salary_history (Lịch sử lương)
CREATE TABLE salary_history (
    history_id INT PRIMARY KEY AUTO_INCREMENT,
    employee_id INT NOT NULL,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    change_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id) ON DELETE CASCADE
);

INSERT INTO departments (department_name) VALUES 
('Phòng Nhân Sự'),
('Phòng Kỹ Thuật');

INSERT INTO employees (name, email, phone, hire_date, department_id) VALUES 
('Nguyễn Văn A', 'nguyenvana', '0987654321', '2024-02-17', 1),
('Trần Thị B', 'tranthib@company.com', '0912345678', '2024-02-17', 2);

INSERT INTO salaries (employee_id, base_salary, bonus) VALUES 
(1, 10000.00, 2000.00), 
(2, 12000.00, 1500.00);

-- 2
DELIMITER //
CREATE PROCEDURE IncreaseSalary(
    IN emp_id INT,
    IN salary_increment DECIMAL(10,2),
    IN reason TEXT
)
BEGIN
    DECLARE old_salary DECIMAL(10,2);
    DECLARE new_salary DECIMAL(10,2);
    
    SELECT base_salary INTO old_salary FROM salaries WHERE employee_id = emp_id;

    IF old_salary IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nhân viên không tồn tại!';
    END IF;
    
    SET new_salary = old_salary + salary_increment;
    
    START TRANSACTION;

    INSERT INTO salary_history (employee_id, old_salary, new_salary, reason)
    VALUES (emp_id, old_salary, new_salary, reason);
    
    UPDATE salaries SET base_salary = new_salary WHERE employee_id = emp_id;
    
    COMMIT;
END;
// DELIMITER ;

-- 3
DELIMITER //
CREATE PROCEDURE DeleteEmployee(IN emp_id INT)
BEGIN
    DECLARE old_salary DECIMAL(10,2);
    SELECT base_salary INTO old_salary FROM salaries WHERE employee_id = emp_id;

    IF old_salary IS NULL THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Nhân viên không tồn tại!';
    END IF;

    START TRANSACTION;

    INSERT INTO salary_history (employee_id, old_salary, new_salary, reason)
    VALUES (emp_id, old_salary, 0, 'Nhân viên bị xóa');

    DELETE FROM salaries WHERE employee_id = emp_id;
    DELETE FROM employees WHERE employee_id = emp_id;
    
    COMMIT;
END;
// DELIMITER ;


-- 4
CALL DeleteEmployee(2);

-- 5
CALL IncreaseSalary(1, 5000.00, 'Tăng lương định kỳ');