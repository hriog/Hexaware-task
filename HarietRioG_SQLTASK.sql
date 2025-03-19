-- Create the database
CREATE DATABASE company1_db;
USE company1_db;

-- Create departments table
CREATE TABLE departments (
    dept_id INT PRIMARY KEY,
    dept_name VARCHAR(255) UNIQUE
);

-- Create employees table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    emp_name VARCHAR(255),
    dept_id INT,
    hire_date DATE,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

-- Create salaries table
CREATE TABLE salaries (
    salary_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    salary DECIMAL(10,2),
    salary_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

-- Insert data into departments
INSERT INTO departments (dept_id, dept_name) VALUES
(1, 'HR'),
(2, 'Engineering'),
(3, 'Sales'),
(4, 'Marketing'),
(5, 'Finance');

-- Insert data into employees
INSERT INTO employees (emp_id, emp_name, dept_id, hire_date) VALUES
(101, 'Alice Johnson', 1, '2022-01-15'),
(102, 'Bob Smith', 2, '2021-07-23'),
(103, 'Charlie Brown', 3, '2020-05-10'),
(104, 'David Wilson', 4, '2023-03-19'),
(105, 'Emma Davis', 5, '2019-11-01'),
(106, 'Frank Thomas', NULL, '2022-06-25'),
(107, 'Grace Hall', 2, '2018-09-30'),
(108, 'Henry White', NULL, '2020-12-14'),
(109, 'Isla Green', 3, '2021-04-28'),
(110, 'Jack Black', 5, '2022-08-09');

-- Insert data into salaries
INSERT INTO salaries (emp_id, salary, salary_date) VALUES
(101, 60000, '2022-01-31'),
(102, 75000, '2021-07-31'),
(103, 55000, '2020-05-31'),
(104, 58000, '2023-03-31'),
(105, 70000, '2019-11-30'),
(106, 50000, '2022-06-30'),
(107, 90000, '2018-09-30'),
(108, 48000, '2020-12-31'),
(109, 63000, '2021-04-30'),
(110, 71000, '2022-08-31'),
(101, 62000, '2023-01-31'), 
(102, 77000, '2022-07-31'); 


-- Retrieve all employees with their department names (INNER JOIN)
SELECT e.emp_id, e.emp_name, d.dept_name 
FROM employees e 
INNER JOIN departments d ON e.dept_id = d.dept_id;

-- Retrieve all employees, including those without a department (LEFT JOIN)
SELECT e.emp_id, e.emp_name, d.dept_name 
FROM employees e 
LEFT JOIN departments d ON e.dept_id = d.dept_id;

-- Retrieve all departments, including those without employees (RIGHT JOIN)
SELECT e.emp_id, e.emp_name, d.dept_name 
FROM employees e 
RIGHT JOIN departments d ON e.dept_id = d.dept_id;

-- Retrieve employees with their latest salary (Subquery)
SELECT e.emp_id, e.emp_name, s.salary 
FROM employees e 
JOIN salaries s ON e.emp_id = s.emp_id 
WHERE s.salary_date = (SELECT MAX(salary_date) FROM salaries WHERE emp_id = e.emp_id);

-- Find the department with the highest average salary (Aggregate Function & JOIN)
SELECT d.dept_name, AVG(s.salary) AS avg_salary 
FROM employees e 
JOIN salaries s ON e.emp_id = s.emp_id 
JOIN departments d ON e.dept_id = d.dept_id 
GROUP BY d.dept_name 
ORDER BY avg_salary DESC 
LIMIT 1;

-- Find employees who joined before the average joining date (Subquery)
SELECT emp_id, emp_name, hire_date 
FROM employees 
WHERE hire_date < (SELECT AVG(hire_date) FROM employees);

-- Find the highest-paid employee in each department (GROUP BY & JOIN)
SELECT e.emp_name, d.dept_name, s.salary FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
JOIN departments d ON e.dept_id = d.dept_id
WHERE (e.dept_id, s.salary) IN (SELECT e.dept_id, MAX(s.salary) FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id GROUP BY e.dept_id);



-- Retrieve the top 3 highest-paid employees in the company (ORDER BY & LIMIT)
SELECT e.emp_id, e.emp_name, s.salary 
FROM employees e 
JOIN salaries s ON e.emp_id = s.emp_id 
ORDER BY s.salary DESC 
LIMIT 3;


-- 1. Get all employees in a given department
DELIMITER $$  
CREATE PROCEDURE GetEmployeesByDepartment(IN deptName VARCHAR(255))  
BEGIN  
    SELECT e.emp_id, e.emp_name, d.dept_name  
    FROM employees e  
    JOIN departments d ON e.dept_id = d.dept_id  
    WHERE d.dept_name = deptName;  
END $$  
DELIMITER ;  
CALL GetEmployeesByDepartment('Engineering');

-- 2. Update an employee’s salary by a given percentage   
DELIMITER $$
CREATE PROCEDURE UpdateSalary(IN empID INT, IN percentage DECIMAL(5,2))
BEGIN
    UPDATE salaries SET salary = salary * (1 + percentage / 100) WHERE emp_id = empID;
END $$
DELIMITER ;
CALL UpdateSalary(107,10);
SELECT * FROM salaries WHERE emp_id = 107;

-- 3. Retrieve employees earning above the average salary  
DELIMITER $$  
CREATE PROCEDURE GetHighEarners()  
BEGIN  
    SELECT e.emp_id, e.emp_name, s.salary  
    FROM employees e  
    JOIN salaries s ON e.emp_id = s.emp_id  
    WHERE s.salary > (SELECT AVG(salary) FROM salaries);  
END $$  
DELIMITER ;  
CALL GetHighEarners();


-- 4. Insert a new employee along with their salary (Transaction Handling)  
DELIMITER $$  
CREATE PROCEDURE InsertEmployeeWithSalaries(
    IN empName VARCHAR(100),  
    IN deptID INT,  
    IN hireDate DATE,  
    IN empSalary DECIMAL(10,2)
)  
BEGIN  
    DECLARE empID INT;  
    SELECT IFNULL(MAX(emp_id), 100) + 1 INTO empID FROM employees;  
    START TRANSACTION;   
    INSERT INTO employees (emp_id, emp_name, dept_id, hire_date)  
    VALUES (empID, empName, deptID, hireDate);   
    INSERT INTO salaries (emp_id, salary, salary_date)  
    VALUES (empID, empSalary, CURDATE());  
    COMMIT;  
END $$  
DELIMITER ;  
CALL InsertEmployeeWithSalaries('John Doe', 3, '2024-03-01', 65000);


-- 5. Delete an employee and their salary records (Cascade Deletion)  
DELIMITER $$  
CREATE PROCEDURE DeleteEmployee(IN empID INT)  
BEGIN  
    START TRANSACTION;  
    DELETE FROM salaries WHERE emp_id = empID;  
    DELETE FROM employees WHERE emp_id = empID;  
    COMMIT;  
END $$  
DELIMITER ;  
CALL DeleteEmployee(101);


-- 6. Get the total salary expenditure for a department  
DELIMITER $$  
CREATE PROCEDURE GetDepartmentSalaryExpenditure(IN deptName VARCHAR(255))  
BEGIN  
    SELECT d.dept_name, SUM(s.salary) AS total_salary_expenditure  
    FROM employees e  
    JOIN salaries s ON e.emp_id = s.emp_id  
    JOIN departments d ON e.dept_id = d.dept_id  
    WHERE d.dept_name = deptName  
    GROUP BY d.dept_name;  
END $$  
DELIMITER ;  
CALL GetDepartmentSalaryExpenditure('Engineering');




