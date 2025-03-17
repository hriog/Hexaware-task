CREATE DATABASE school_db;
use school_db;

CREATE TABLE students(
id INT AUTO_INCREMENT PRIMARY KEY,
first_name VARCHAR(50) NOT NULL,
last_name VARCHAR(50) NOT NULL,
email VARCHAR(255) UNIQUE NOT NULL,
age INT NOT NULL,
grade VARCHAR(255) NOT NULL,
enrollment_date DATE NOT NULL);


INSERT INTO students (first_name, last_name, email, age, grade, enrollment_date)
VALUES
('Hariet','Rio','harietrior0@gmail.com',15,'A+','2025-06-12'),
('aaren','jo','aarenjo@gmail.com',13,'A','2025-07-12'),
('ayden','luke','aydenluke@gmail.com',14,'B+','2025-04-12'),
('andrea','mia','andreamia@gmail.com',12,'B+','2025-05-12'),
('daliya','jo','daliyajo@gmail.com',16,'A+','2025-03-12');

SELECT * FROM students;

#SELECTING STUDENT OVER 15 AGE
SELECT first_name, last_name, age, grade FROM students 
WHERE age>15;

#UPDATING STUDENT
UPDATE students
SET grade = 'A+'
WHERE id = 3;

#DELETING STUDENT
DELETE FROM students 
WHERE id = 5;

#GET STUDENTS ENROLLED IN LAST 6 MONTHS
SELECT * FROM students
WHERE enrollment_date >= NOW() - INTERVAL 6 MONTH;

# TO RETRIVE GRADE IN DESC ORDER
SELECT * FROM students
ORDER BY FIELD(grade, 'A+','A','B+','B') DESC;
