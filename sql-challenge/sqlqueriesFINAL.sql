CREATE TABLE departments (
    dept_no varchar(30)   NOT NULL,
    dept_name varchar(30)   NOT NULL,
    CONSTRAINT pk_Departments PRIMARY KEY (
        dept_no
     )
);

CREATE TABLE employees (
    emp_no int   NOT NULL,
    birth_date date   NOT NULL,
    first_name varchar(35)   NOT NULL,
    last_name varchar(35)   NOT NULL,
    gender varchar(1)   NOT NULL,
    hire_date date   NOT NULL,
    CONSTRAINT pk_Employees PRIMARY KEY (
        emp_no
     )
);

CREATE TABLE dept_emp (
    emp_no int   NOT NULL,
    dept_no varchar(30)   NOT NULL,
    from_date date   NOT NULL,
    to_date date   NOT NULL
);

CREATE TABLE dept_manager (
    dept_no varchar(30)   NOT NULL,
    emp_no int   NOT NULL,
     from_date date   NOT NULL,
    to_date date   NOT NULL
);

CREATE TABLE salaries (
    emp_no int   NOT NULL,
    salary int   NOT NULL,
    from_date date   NOT NULL,
    to_date date   NOT NULL
);

CREATE TABLE titles (
    emp_no int   NOT NULL,
    title varchar(35)   NOT NULL,
    from_date date   NOT NULL,
    to_date date   NOT NULL
);

--Since I'm on mac
COPY public."departments" FROM '/tmp/Resources/departments.csv' DELIMITER ',' CSV HEADER;
COPY public."dept_emp" FROM '/tmp/Resources/dept_emp.csv' DELIMITER ',' CSV HEADER;
COPY public."dept_manager" FROM '/tmp/Resources/dept_manager.csv' DELIMITER ',' CSV HEADER;
COPY public."employees" FROM '/tmp/Resources/employees.csv' DELIMITER ',' CSV HEADER;
COPY public."salaries" FROM '/tmp/Resources/salaries.csv' DELIMITER ',' CSV HEADER;
COPY public."titles" FROM '/tmp/Resources/titles.csv' DELIMITER ',' CSV HEADER;

--checking to see if data imported
select * FROM dept_emp
select * FROM departments
select * FROM dept_manager
select * FROM employees
select * FROM salaries
select * FROM titles

--constraints & foreign keys
ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_emo_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE dept_emp ADD CONSTRAINT fk_dept_emp_dept_no FOREIGN KEY(dept_no)
REFERENCES departments(dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_dept_no FOREIGN KEY(dept_no)
REFERENCES departments (dept_no);

ALTER TABLE dept_manager ADD CONSTRAINT fk_dept_manager_emp_no FOREIGN KEY(emp_no)
REFERENCES employees (emp_no);

ALTER TABLE salaries ADD CONSTRAINT fk_salaries_emp_no FOREIGN KEY (emp_no)
REFERENCES employees (emp_no);

ALTER TABLE titles ADD CONSTRAINT fk_titles_emp_no FOREIGN KEY (emp_no)
REFERENCES employees (emp_no);

--checking to see if keys+constraints went through
select * FROM dept_emp
select * FROM departments
select * FROM dept_manager
select * FROM employees
select * FROM salaries
select * FROM titles

--Data Analysis
--1.employee number, last name, first name, gender, salary
select employees.emp_no,
	employees.last_name,
	employees.first_name,
	employees.gender,
	salaries.salary
FROM employees
inner join salaries on
employees.emp_no = salaries.emp_no;

--2. employees hired in 1986
select employees.emp_no,
	employees.last_name,
	employees.first_name,
	EXTRACT (YEAR FROM hire_date) AS YEAR
FROM employees
where hire_date BETWEEN '12/31/1985' AND '01/01/1987'

--3. manager of each dept with dept number, name, manager's employee number, last name, first name, and employment dates
select departments.dept_no,
	departments.dept_name,
	dept_manager.emp_no,
	employees.last_name,
	employees.first_name,
	dept_manager.from_date,
	dept_manager.to_date
FROM departments
JOIN dept_manager
ON departments.dept_no = dept_manager.dept_no
JOIN employees
ON dept_manager.emp_no = employees.emp_no;

--4. department of each employee with: employee number, last name, first name, department name
select dept_emp.emp_no,
	employees.last_name,
	employees.first_name,
	departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no

--5. List all employees whose first name is "Hercules" and last name begins with "B"
SELECT first_name,
	last_name
FROM employees
WHERE first_name = 'Hercules'
AND last_name LIKE 'B%';

--6. list all employees in sales dept, including employee num, last name, first name, dept name
SELECT dept_emp.emp_no,
	employees.last_name,
	employees.first_name,
	departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales';

--7. list all employees in sales and development departments including employee number, last+first name, department name
SELECT dept_emp.emp_no,
	employees.last_name,
	employees.first_name,
	departments.dept_name
FROM dept_emp
JOIN employees
ON dept_emp.emp_no = employees.emp_no
JOIN departments
ON dept_emp.dept_no = departments.dept_no
WHERE departments.dept_name = 'Sales'
OR departments.dept_name = 'Development';

--8. in DESC order list the freq count of employee last names
SELECT last_name,
COUNT(last_name) AS "frequency"
FROM employees
GROUP BY last_name
ORDER BY
COUNT(last_name) DESC;



