

CREATE TABLE Employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(255),
    dob DATE,
    department_id INT,
    salary DECIMAL(10, 2),
    FOREIGN KEY (department_id) REFERENCES Departments(department_id)
);

CREATE TABLE Departments (
    department_id INT PRIMARY KEY,
    department_name VARCHAR(255),
    location VARCHAR(255)
);

CREATE TABLE Projects (
    project_id INT PRIMARY KEY,
    project_name VARCHAR(255),
    start_date DATE,
    end_date DATE
);

CREATE TABLE Timesheets (
    timesheet_id INT PRIMARY KEY,
    employee_id INT,
    project_id INT,
    work_date DATE,
    hours_worked DECIMAL(5, 2),
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

-- Insert sample data into Departments table
INSERT INTO Departments (department_id, department_name, location) VALUES
(1, 'IT', 'Building A'),
(2, 'HR', 'Building B'),
(3, 'Finance', 'Building C');
-- Insert sample data into Employees table
INSERT INTO Employees (employee_id, name, dob, department_id, salary) VALUES
(1, 'Alice Williams', '1985-06-15', 1, 5000.00),
(2, 'Bob Johnson', '1990-03-22', 2, 4500.00),
(3, 'Charlie Brown', '1992-08-10', 1, 5500.00),
(4, 'David Smith', '1988-11-30', NULL, 4700.00);
-- Insert sample data into Projects table
INSERT INTO Projects (project_id, project_name, start_date, end_date) VALUES
(1, 'Project A', '2025-01-01', '2025-12-31'),
(2, 'Project B', '2025-02-01', '2025-11-30');
-- Insert sample data into WorkReports table
INSERT INTO WorkReports (report_id, employee_id, report_date, report_content) VALUES
(1, 1, '2025-01-31', 'Completed initial setup for Project A.'),
(2, 2, '2025-02-10', 'Completed HR review for Project A.'),
(3, 3, '2025-01-20', 'Worked on debugging and testing for Project A.'),
(4, 4, '2025-02-05', 'Worked on financial reports for Project B.'),
(5, NULL, '2025-02-15', 'No report submitted.');
-- Insert sample data into Timesheets table
INSERT INTO Timesheets (timesheet_id, employee_id, project_id, work_date, hours_worked) VALUES
(1, 1, 1, '2025-01-10', 8),
(2, 1, 2, '2025-02-12', 7),
(3, 2, 1, '2025-01-15', 6),
(4, 3, 1, '2025-01-20', 8),
(5, 4, 2, '2025-02-05', 5);
-- 1 
SELECT e.name, d.department_name 
FROM Employees e
LEFT JOIN Departments d ON e.department_id = d.department_id
ORDER BY e.name; 
-- 2
SELECT name, salary 
FROM Employees 
WHERE salary > 5000 
ORDER BY salary DESC;
-- 3
SELECT e.name, SUM(t.hours_worked) AS total_hours
FROM Employees e
LEFT JOIN Timesheets t ON e.employee_id = t.employee_id
GROUP BY e.name;
-- 4
SELECT d.department_name, AVG(e.salary) AS average_salary
FROM Departments d
LEFT JOIN Employees e ON d.department_id = e.department_id
GROUP BY d.department_name;
-- 5
SELECT p.project_name, SUM(t.hours_worked) AS total_hours
FROM Projects p
JOIN Timesheets t ON p.project_id = t.project_id
WHERE t.work_date BETWEEN '2025-02-01' AND '2025-02-28'
GROUP BY p.project_name;
-- 6
SELECT e.name, p.project_name, SUM(t.hours_worked) AS total_hours
FROM Employees e
JOIN Timesheets t ON e.employee_id = t.employee_id
JOIN Projects p ON t.project_id = p.project_id
GROUP BY e.name, p.project_name;
-- 7
SELECT d.department_name, COUNT(e.employee_id) AS employee_count
FROM Departments d
JOIN Employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING COUNT(e.employee_id) > 1;
-- 8
SELECT report_date, e.name, COUNT(*) AS report_count
FROM WorkReports wr
JOIN Employees e ON wr.employee_id = e.employee_id
WHERE report_content IS NOT NULL 
AND report_date BETWEEN '2025-01-01' AND '2025-02-01'
GROUP BY report_date, e.name;
-- 9
SELECT report_date, e.name, COUNT(*) AS report_count
FROM WorkReports wr
JOIN Employees e ON wr.employee_id = e.employee_id
WHERE report_content IS NOT NULL 
AND report_date BETWEEN '2025-01-01' AND '2025-02-01'
GROUP BY report_date, e.name;
-- 10
SELECT 
    e.name, 
    p.project_name, 
    SUM(t.hours_worked) AS total_hours,
    ROUND(SUM(t.hours_worked * e.salary / 160), 2) AS total_salary
FROM Employees e
JOIN Timesheets t ON e.employee_id = t.employee_id
JOIN Projects p ON t.project_id = p.project_id
GROUP BY e.name, p.project_name
HAVING total_hours > 5
ORDER BY total_salary;