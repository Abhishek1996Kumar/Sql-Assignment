use company_db;

CREATE TABLE employee (
    emp_id INT PRIMARY KEY,
    name VARCHAR(50),
    department_id VARCHAR(10),
    salary INT
);
INSERT INTO employee (emp_id, name, department_id, salary) VALUES
(101, 'Abhishek', 'D01', 62000),
(102, 'Shubham',  'D01', 58000),
(103, 'Priya',    'D02', 67000),
(104, 'Rohit',    'D02', 64000),
(105, 'Neha',     'D03', 72000),
(106, 'Aman',     'D03', 55000),
(107, 'Ravi',     'D04', 60000),
(108, 'Sneha',    'D04', 75000),
(109, 'Kiran',    'D05', 70000),
(110, 'Tanuja',   'D05', 65000);

CREATE TABLE department (
    department_id VARCHAR(10) PRIMARY KEY,
    department_name VARCHAR(50),
    location VARCHAR(50)
);


INSERT INTO department (department_id, department_name, location) VALUES
('D01', 'Sales',      'Mumbai'),
('D02', 'Marketing',  'Delhi'),
('D03', 'Finance',    'Pune'),
('D04', 'HR',         'Bengaluru'),
('D05', 'IT',         'Hyderabad');

CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    emp_id INT,
    sale_amount INT,
    sale_date DATE,
    FOREIGN KEY (emp_id) REFERENCES employee(emp_id)
);

INSERT INTO sales (sale_id, emp_id, sale_amount, sale_date) VALUES
(201, 101,  4500, '2025-01-05'),
(202, 102,  7800, '2025-01-10'),
(203, 103,  6700, '2025-01-14'),
(204, 104, 12000, '2025-01-20'),
(205, 105,  9800, '2025-02-02'),
(206, 106, 10500, '2025-02-05'),
(207, 107,  3200, '2025-02-09'),
(208, 108,  5100, '2025-02-15'),
(209, 109,  3900, '2025-02-20'),
(210, 110,  7200, '2025-03-01');

select * from employee;
select *from department;

Basic Level
Q1 --Retrieve the names of employees who earn more than the average salary of all employees.

SELECT name
FROM employee
WHERE salary > (SELECT AVG(salary) FROM employee);

Q2 --Find the employees who belong to the department with the highest average salary.

SELECT department_id, 
FROM employee
GROUP BY department_id
HAVING AVG(salary) = (
    SELECT MAX(avg_sal)
    FROM (
        SELECT AVG(salary) AS avg_sal
        FROM employee
        GROUP BY department_id
    ) t
);

Q3 --List all employees who have made at least one sale

SELECT name
FROM employee
WHERE emp_id IN (
    SELECT DISTINCT emp_id
    FROM sales);

Q4 --Find the employee with the highest sale amount.

SELECT name
FROM employee
WHERE emp_id = (
    SELECT emp_id
    FROM sales
    WHERE sale_amount = (
        SELECT MAX(sale_amount)
        FROM sales));

Q5 --Retrieve the names of employees whose salaries are higher than Shubham’s salary

SELECT name
FROM employee
WHERE salary > (
    SELECT salary
    FROM employee
    WHERE name = 'Shubham');

Intermediate Level

Q6 --Find employees who work in the same department as Abhishek

select name from employee
where department_id = (select department_id
from employee
where department_id ='abhishek');

Q7--List departments that have at least one employee earning more than ₹60,000

 SELECT department_name
FROM department
WHERE department_id IN (
    SELECT DISTINCT department_id
    FROM employee
    WHERE salary > 60000);


Q8 --Find the department name of the employee who made the highest sale.

SELECT department_name
FROM department
WHERE department_id = (
    SELECT department_id
    FROM employee
    WHERE emp_id = (
        SELECT emp_id
        FROM sales
        ORDER BY sale_amount DESC
        LIMIT 1));

Q9 --Retrieve employees who have made sales greater than the average sale amount.

SELECT name
FROM employee
WHERE emp_id IN (
    SELECT emp_id
    FROM sales
    WHERE sale_amount > (
        SELECT AVG(sale_amount)
        FROM sales));

Q10 --Find the total sales made by employees who earn more than the average salary

SELECT SUM(sale_amount) AS total_sales
FROM sales
WHERE emp_id IN (
    SELECT emp_id
    FROM employee
    WHERE salary > (
        SELECT AVG(salary)
        FROM employee));

Advanced Level

Q11 --Find employees who have not made any sales

SELECT  emp_id,name
FROM employee
WHERE emp_id NOT IN (
    SELECT emp_id
    FROM sales);

Q12 --List departments where the average salary is above ₹55,000.

select department_id,department_name
from department
where department_id in (select department_id
from employee
group by department_id
having avg(salary) > 55000);

Q13 --Retrieve department names where the total sales exceed ₹10,000.

SELECT department_name
FROM department
WHERE department_id IN (
    SELECT department_id
    FROM employee
    WHERE emp_id IN (
        SELECT emp_id
        FROM sales
        GROUP BY emp_id
        HAVING SUM(sale_amount) > 10000));

Q14 --Find the employee who has made the second-highest sale.

SELECT name
FROM employee
WHERE emp_id = (
    SELECT emp_id
    FROM sales
    ORDER BY sale_amount DESC
    LIMIT 1 OFFSET 1);

Q15 --Retrieve the names of employees whose salary is greater than the highest sale amount recorded.

SELECT name
FROM employee
WHERE salary > (
    SELECT MAX(sale_amount)
    FROM sales);
