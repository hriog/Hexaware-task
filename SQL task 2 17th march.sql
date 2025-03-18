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



INSERT INTO departments (dept_name) VALUES 
('HR'),
('Finance'),
('IT'),
('Marketing'),
('Operations');

INSERT INTO employees (first_name, last_name, email, salary, dept_id, join_date) VALUES
('Amit', 'Sharma', 'amit.sharma@example.com', 75000, 1, '2023-06-15'),
('Priya', 'Verma', 'priya.verma@example.com', 88000, 2, '2021-09-20'),
('Rajesh', 'Gupta', 'rajesh.gupta@example.com', 96000, 3, '2022-12-05'),
('Neha', 'Reddy', 'neha.reddy@example.com', 73000, 4, '2020-08-10'),
('Vikram', 'Patel', 'vikram.patel@example.com', 99000, 5, '2021-11-25'),
('Kiran', 'Joshi', 'kiran.joshi@example.com', 81000, 3, '2023-04-12'),
('Arjun', 'Singh', 'arjun.singh@example.com', 89000, 4, '2019-05-18');

#subquery task
#1
select e.emp_id, e.first_name, e.last_name ,e.salary, d.dept_name
from employees e join departments d on e.dept_id=d.dept_id
where e.salary>(select avg(salary) from employees 
WHERE dept_id = e.dept_id
);

#2
SELECT d.dept_name,e.first_name,e.last_name FROM departments d join employees e ON e.dept_id = d.dept_id
WHERE e.dept_id = (SELECT dept_id FROM employees WHERE first_name = 'Rajesh' AND last_name = 'Gupta');

select * from employees;
select * from departments;

#3
SELECT first_name, last_name, join_date
FROM employees
WHERE join_date > (
    SELECT MIN(join_date) FROM employees WHERE dept_id = (
        SELECT dept_id FROM departments WHERE dept_name = 'IT'
    )
);


#4
SELECT d.dept_name, e.salary 
FROM departments d join employees e on d.dept_id=e.dept_id 
WHERE d.dept_id = (  
    SELECT dept_id  
    FROM employees  
    GROUP BY dept_id  
    ORDER BY AVG(salary) DESC  
    LIMIT 1  
);

#5
select max(salary) from employees
where salary<(select max(salary) from employees);


#inline query
#6
SELECT e.first_name, e.last_name,  
       (SELECT d.dept_name FROM departments d WHERE d.dept_id = e.dept_id) AS department_name  
FROM employees e;

#7
SELECT first_name, last_name, salary,  
       IF(salary > (SELECT AVG(salary) FROM employees), 'Above Average', 'Below Average') AS salary_status  
FROM employees;

#8
SELECT e.first_name, e.last_name, e.salary, d.dept_name,  
       (SELECT COUNT(*) FROM employees WHERE dept_id = e.dept_id) AS employee_count  
FROM employees e  
JOIN departments d ON e.dept_id = d.dept_id;

#9
SELECT e.first_name, e.last_name, e.salary, d.dept_name  
FROM employees e  
JOIN departments d ON e.dept_id = d.dept_id  
ORDER BY (SELECT SUM(salary) FROM employees WHERE dept_id = e.dept_id) DESC;

#10
SELECT e.first_name, e.last_name, e.salary, d.dept_name  
FROM employees e  
JOIN departments d ON e.dept_id = d.dept_id  
WHERE e.salary >= (  
    SELECT MIN(salary)  
    FROM (  
        SELECT salary  
        FROM employees  
        WHERE dept_id = e.dept_id  
        ORDER BY salary DESC  
        LIMIT 3  
    ) AS top_salaries  
);


