
USE session_11;

-- 2
DELIMITER //
CREATE PROCEDURE UpdateSalaryByID(IN employee_id INT, INOUT new_salary DECIMAL(10, 2))
BEGIN
	IF new_salary < 20000000 THEN
		SET new_salary = new_salary * 1.1;
	 ELSE
		SET new_salary = new_salary * 1.05;
	END IF;

	UPDATE employees SET Salary = new_salary WHERE EmployeeID = employee_id;
END;
// DELIMITER ;

-- 3
DELIMITER //
CREATE PROCEDURE GetLoanAmountByCustomerID(IN customer_id INT, OUT TotalLoanAmount DECIMAL(15, 2))
BEGIN
	SELECT COALESCE(SUM(LoanAmount), 0)
    INTO TotalLoanAmount
    FROM Loans 
    WHERE CustomerID = customer_id;
END;
// DELIMITER ;

-- 4
DELIMITER //
CREATE PROCEDURE DeleteAccountIfLowBalance(IN account_id INT)
BEGIN
	DECLARE v_Balance DECIMAL(15,2);
    SELECT Balance INTO v_Balance FROM Accounts WHERE AccountID = account_id;
	IF v_Balance < 1000000 THEN
        DELETE FROM Accounts WHERE AccountID = account_id;
        SELECT 'Tài khoản đã bị xóa do số dư nhỏ hơn 1 triệu' AS Message;
    ELSE
        SELECT 'Không thể xóa tài khoản vì số dư lớn hơn 1 triệu' AS Message;
    END IF;
END;
// DELIMITER ;

-- 5
DELIMITER //
CREATE PROCEDURE TransferMoney(IN fromAccountID INT, IN toAccountID INT, INOUT amount DECIMAL(15,2))
BEGIN
    DECLARE v_FromBalance DECIMAL(15,2);
    DECLARE v_ToAccountExists INT;
    SELECT Balance INTO v_FromBalance FROM Accounts WHERE AccountID = fromAccountID;
    SELECT COUNT(*) INTO v_ToAccountExists FROM Accounts WHERE AccountID = toAccountID;
    IF v_ToAccountExists = 0 THEN
        SET amount = 0;
    ELSEIF v_FromBalance >= amount THEN
        UPDATE Accounts SET Balance = Balance - amount WHERE AccountID = fromAccountID;
        UPDATE Accounts SET Balance = Balance + amount WHERE AccountID = toAccountID;
        INSERT INTO Transactions (AccountID, TransactionType, Amount) 
        VALUES (fromAccountID, 'Transfer', -amount);

        INSERT INTO Transactions (AccountID, TransactionType, Amount) 
        VALUES (toAccountID, 'Transfer', amount);
    ELSE
        SET amount = 0;
    END IF;
END;
// DELIMITER ;

-- 6
SET @new_salary = 18000000;
CALL UpdateSalaryByID(4, @new_salary);
SELECT @new_salary AS UpdatedSalary;

SET @loan_amount = 0;
CALL GetLoanAmountByCustomerID(1, @loan_amount);
SELECT @loan_amount AS TotalLoanAmount;

CALL DeleteAccountIfLowBalance(8);

SET @amount = 2000000;
CALL TransferMoney(1, 3, @amount);
SELECT @amount AS 'Số tiền cuối cùng đã chuyển';

-- 7
DROP PROCEDURE IF EXISTS UpdateSalaryByID;
DROP PROCEDURE IF EXISTS GetLoanAmountByCustomerID; 
DROP PROCEDURE IF EXISTS DeleteAccountIfLowBalance;
DROP PROCEDURE IF EXISTS TransferMoney; 
