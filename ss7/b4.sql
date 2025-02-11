CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    dob DATE,
    department_id INT,
    salary DECIMAL(10,2),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(50),
    start_date DATE,
    end_date DATE
);

CREATE TABLE Timesheets (
    timesheet_id INT PRIMARY KEY,
    employee_id INT,
    project_id INT,
    work_date DATE,
    hours_worked DECIMAL(2),
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    FOREIGN KEY (project_id) REFERENCES Projects(project_id)
);

CREATE TABLE WorkReports (
    report_id INT PRIMARY KEY,
    employee_id INT,
    report_date DATE,
    report_content TEXT,
    FOREIGN KEY (employee_id) REFERENCES Employees(employee_id)
);

INSERT INTO Departments VALUES
(1, 'IT Department', 'Floor 3'),
(2, 'HR Department', 'Floor 2');

INSERT INTO Employees VALUES
(1, 'John Doe', '1990-05-15', 1, 5000.00),
(2, 'Jane Smith', '1988-03-20', 2, 4500.00);

INSERT INTO Projects VALUES
(1, 'Website Development', '2024-01-01', '2024-06-30'),
(2, 'HR System', '2024-02-01', '2024-12-31');

INSERT INTO Timesheets VALUES
(1, 1, 1, '2024-02-01', 8),
(2, 2, 2, '2024-02-01', 7);

INSERT INTO WorkReports VALUES
(1, 1, '2024-02-01', 'Completed frontend development'),
(2, 2, '2024-02-01', 'Updated employee policies');

INSERT INTO Departments (department_id, department_name, location) VALUES
(1, 'IT', 'Building A'),
(2, 'HR', 'Building B'),
(3, 'Finance', 'Building C');

INSERT INTO Employees (employee_id, name, dob, department_id, salary) VALUES
(1, 'Alice Williams', '1985-06-15', 1, 5000.00),
(2, 'Bob Johnson', '1990-03-22', 2, 4500.00),
(3, 'Charlie Brown', '1992-08-10', 1, 5500.00),
(4, 'David Smith', '1988-11-30', NULL, 4700.00);

INSERT INTO Projects (project_id, project_name, start_date, end_date) VALUES
(1, 'Project A', '2025-01-01', '2025-12-31'),
(2, 'Project B', '2025-02-01', '2025-11-30');

INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES
(1, 1, '2025-01-31', 'Completed initial setup for Project A.'),
(2, 2, '2025-02-10', 'Completed HR review for Project A.'),
(3, 3, '2025-01-20', 'Worked on debugging and testing for Project A.'),
(4, 4, '2025-02-05', 'Worked on financial reports for Project B.'),
(5, NULL, '2025-02-15', 'No report submitted.');

INSERT INTO Timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
(1, 1, 1, '2025-01-10', 8),
(2, 1, 2, '2025-02-12', 7),
(3, 2, 1, '2025-01-15', 6),
(4, 3, 1, '2025-01-20', 8),
(5, 4, 2, '2025-02-05', 5);
-- 2.1
SELECT * FROM Employees;
-- 2.2
SELECT * FROM Projects;
-- 2.3
SELECT Employees.name AS employee_name, Departments.department_name
FROM Employees
JOIN Departments ON Employees.department_id = Departments.department_id;
-- 2.4
SELECT Employees.name AS employee_name, WorkReports.report_content
FROM WorkReports
JOIN Employees ON WorkReports.employee_id = Employees.employee_id;
-- 2.5
SELECT Employees.name AS employee_name, Projects.project_name, Timesheets.hours_worked
FROM Timesheets
JOIN Employees ON Timesheets.employee_id = Employees.employee_id
JOIN Projects ON Timesheets.project_id = Projects.project_id;
-- 2.6
SELECT Employees.name AS employee_name, Timesheets.hours_worked
FROM Timesheets
JOIN Employees ON Timesheets.employee_id = Employees.employee_id
JOIN Projects ON Timesheets.project_id = Projects.project_id
WHERE Projects.project_name = 'Project A';
-- 3.1
UPDATE Employees
SET salary = 6500.00
WHERE name LIKE '%Alice%';
-- 3.2
DELETE FROM WorkReports
WHERE employee_id IN (
    SELECT employee_id FROM Employees WHERE name LIKE '%Brown%'
);
-- 3.3
INSERT INTO Employees (employee_id, name, dob, department_id, salary)
VALUES (5, 'James Lee', '1996-05-20', 1, 5000.00);