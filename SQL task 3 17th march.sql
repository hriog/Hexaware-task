CREATE DATABASE company_db;
USE company_db;

CREATE TABLE departments (
    dept_id INT AUTO_INCREMENT PRIMARY KEY,
    dept_name VARCHAR(100) NOT NULL
);

CREATE TABLE employees (
    emp_id INT AUTO_INCREMENT PRIMARY KEY,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    salary DECIMAL(10,2) NOT NULL,
    dept_id INT,
    join_date DATE NOT NULL,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id) ON DELETE CASCADE
);

-- Insert Departments
INSERT INTO departments (dept_name) VALUES 
('HR'), ('Finance'), ('IT'), ('Marketing'), ('Operations');

-- Insert Employees
INSERT INTO employees (first_name, last_name, email, salary, dept_id, join_date) VALUES
('Rajesh', 'Gupta', 'rajesh.gupta@example.com', 75000, 3, '2022-06-15'),
('Neha', 'Reddy', 'neha.reddy@example.com', 90000, 3, '2021-07-10'),
('Amit', 'Sharma', 'amit.sharma@example.com', 85000, 2, '2020-03-25'),
('Priya', 'Verma', 'priya.verma@example.com', 60000, 1, '2019-08-30'),
('Suresh', 'Patil', 'suresh.patil@example.com', 95000, 4, '2023-05-20'),
('Kavita', 'Joshi', 'kavita.joshi@example.com', 72000, 5, '2022-11-05'),
('Vikram', 'Singh', 'vikram.singh@example.com', 82000, 2, '2021-01-12');


-- Retrieve all employees' details
SELECT * FROM employees;

-- Retrieve all employees in the IT department
SELECT * FROM employees WHERE dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'IT');

-- Retrieve employees who earn more than 80,000
SELECT * FROM employees WHERE salary > 80000;


-- Increase the salary of employees in Finance by 10%
UPDATE employees 
SET salary = salary * 1.10 
WHERE dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'Finance');

-- Change the department of an employee whose email is 'rajesh.gupta@example.com' to IT
UPDATE employees 
SET dept_id = (SELECT dept_id FROM departments WHERE dept_name = 'IT') 
WHERE email = 'rajesh.gupta@example.com';



-- Delete an employee who joined before 2021
DELETE FROM employees WHERE join_date < '2021-01-01';

-- Delete a department that has no employees
DELETE FROM departments 
WHERE dept_id NOT IN (SELECT DISTINCT dept_id FROM employees);


-- Find employees who earn more than the average salary of all employees
SELECT * FROM employees 
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Find employees who work in the same department as ‘Neha Reddy’
SELECT * FROM employees 
WHERE dept_id = (SELECT dept_id FROM employees WHERE first_name = 'Neha' AND last_name = 'Reddy');

-- Retrieve the department with the highest number of employees
SELECT dept_name FROM departments 
WHERE dept_id = (
    SELECT dept_id FROM employees 
    GROUP BY dept_id 
    ORDER BY COUNT(emp_id) DESC 
    LIMIT 1
);




