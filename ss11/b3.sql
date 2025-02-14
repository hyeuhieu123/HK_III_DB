USE session_11;

-- 2
DELIMITER //
CREATE PROCEDURE GetCustomerByPhone(IN phone_Number varchar(255))
BEGIN
	SELECT CustomerID, FullName, DateOfBirth,Address,Email
	FROM Customers
	WHERE phoneNumber = phone_Number;
END;
// DELIMITER ;

CALL GetCustomerByPhone('0901234567');

-- 3
DELIMITER //
CREATE PROCEDURE GetTotalBalance(IN customer_id INT, OUT TotalBalance DECIMAL(15, 2))
BEGIN
	SELECT SUM(Balance) INTO TotalBalance
	FROM Accounts
	WHERE CustomerID = customer_id
	GROUP  BY CustomerID;
END;
// DELIMITER ;

SET @total_balance = 0;

CALL GetTotalBalance(1, @total_balance);

SELECT @total_balance AS TotalBalance;

-- 4
DELIMITER //
CREATE PROCEDURE IncreaseEmployeeSalary(IN employee_id INT, INOUT NewSalary DECIMAL(10, 2))
BEGIN
	SELECT
		e.Salary * 1.1 INTO NewSalary
	FROM employees e
    WHERE e.EmployeeID = employee_id;
END;
// DELIMITER ;

SET @new_salary = 0;
CALL IncreaseEmployeeSalary(2,@new_salary);
SELECT @new_salary AS NewSalary;

-- 5

CALL GetCustomerByPhone('0901234567');

SET @total_balance = 0;
CALL GetTotalBalance(1, @total_balance);

SELECT @total_balance AS TotalBalance;

SET @new_salary = 0;
CALL IncreaseEmployeeSalary(4, @new_salary);
SELECT @new_salary AS NewSalary;

-- 6
DROP PROCEDURE IF EXISTS GetCustomerByPhone;
DROP PROCEDURE IF EXISTS GetTotalBalance; 
DROP PROCEDURE IF EXISTS IncreaseEmployeeSalary; 