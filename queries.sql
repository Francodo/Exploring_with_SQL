
CREATE TABLE departments (
     dept_no VARCHAR(4) NOT NULL,
     dept_name VARCHAR(40) NOT NULL,
     PRIMARY KEY (dept_no),
     UNIQUE (dept_name)
);

CREATE TABLE employees (
	 emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR NOT NULL,
     last_name VARCHAR NOT NULL,
     gender VARCHAR NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE dept_manager (
dept_no VARCHAR(4) NOT NULL,
	emp_no INT NOT NULL,
	from_date DATE NOT NULL,
	to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
FOREIGN KEY (dept_no) REFERENCES departments (dept_no),
	PRIMARY KEY (emp_no, dept_no)
);


CREATE TABLE salaries (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  PRIMARY KEY (emp_no)
);


CREATE TABLE dept_emp (
  emp_no INT NOT NULL,
  dept_no VARCHAR (10) NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  PRIMARY KEY (emp_no)
);


CREATE TABLE title (
  emp_no INT NOT NULL,
  salary INT NOT NULL,
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  PRIMARY KEY (emp_no)
);






--7.3.1 Determine Retirement Eligibility

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

--- Search for employees born in 1952 (Jan to Dec)

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';


--- Narrow the search for retirement eligibility with birh date and hire date(two conditions)

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--- Use COUNT along with the first column(first name) to determine how many employees are affected

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--- We now want the output of our search to go into a new table using INTO ("retirement_info")

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


---Verify to see that the table "retirement_info" has been created

SELECT * FROM retirement_info;



--------------------------------------------------------------------------------------------------


--7.3.1 Determine Retirement Eligibility

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

--- Search for employees born in 1952 (Jan to Dec)

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';


--- Narrow the search for retirement eligibility with birh date and hire date(two conditions)

SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--- Use COUNT along with the first column(first name) to determine how many employees are affected

SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--- We now want the output of our search to go into a new table using INTO ("retirement_info")

SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


---Verify to see that the table "retirement_info" has been created

SELECT * FROM retirement_info;

-----------------------------------------------------------------------------
---Drop the retirement_info table so that we can recreate it with amp_no column included

DROP TABLE retirement_info;

---Create a new table with the additon emp_no column

-- Create new table for retiring employees

SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');


-- Check the table
SELECT * FROM retirement_info;



-- 7.3.3 Joining retirement_info and dept_emp tables

SELECT retirement_info.emp_no,
	retirement_info.first_name,
retirement_info.last_name,
	dept_emp.to_date
FROM retirement_info 
LEFT JOIN dept_emp ON retirement_info.emp_no = dept_emp.emp_no;

--- Shorten the table names by abrevating

SELECT d.dept_name,
     dm.emp_no,
     dm.from_date,
     dm.to_date
	 FROM departments as d
INNER JOIN dept_manager as dm
ON d.dept_no = dm.dept_no;


---Use Left Join for retirement_info and dept_emp tables (ri for retirement_info, de for dept_emp)

SELECT ri.emp_no,
	ri.first_name,
	ri.last_name,
de.to_date

INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no

WHERE de.to_date = ('9999-01-01');

-- Employee count by department number

SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no;



-- Employee count by department number with Order BY

SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;


----Checking to see the dates in salaries table

SELECT * FROM salaries

----Sort by to_date

SELECT * FROM salaries
ORDER BY to_date DESC;

---7.3.5 Reuse the old query and include gender, salary and to_date
---Part 1 List
SELECT e.emp_no,
	e.first_name,
e.last_name,
	e.gender,
	s.salary,
	de.to_date
	
INTO emp_info
FROM employees as e

INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)

INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)

WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
AND (de.to_date = '9999-01-01');



---Begin--- Module 7 Challenge
---Gather information from three tables (Employees, Salaries and Tittle)
---The information we need are 1.emp_no 2. first_name 3. last_name 4. salary 
---5. from_date 6. tittle 7. to_date. Note that table names are abreviated.

SELECT  e.emp_no,
        e.first_name,
        e.last_name,
        s.salary,
        s.from_date,
        ti.title,
		ti.to_date

--- Use INTO for writing the newly extracted data into a file (retiring_emp_info)

INTO retiring_emp_info

--- Perform joining of three tables from where to extract data for the new table.
--- In this case INNER JOIN and ON based on the columns hey have in common

FROM employees AS e
    INNER JOIN salaries AS s
        ON (e.emp_no = s.emp_no)
    INNER JOIN title AS ti
        ON (ti.emp_no = s.emp_no)

--- Filter based on employee's birth date as indicated

WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (ti.to_date = '9999-01-01');

--- Partition the data to show only most recent title per employee
--- First, create anew table "unique_title"

SELECT  emp_no,
        first_name,
        last_name,
        title,
		to_date
		
--- Second, name a new file for the table

INTO unique_title

--- Create partition based on criteria or condition
--- First, create a new table with columns of intrest 
FROM
 (SELECT  emp_no,
        first_name,
        last_name,
        title,
		to_date,
--- Do the partition. Specify from where to extract data.
--- In this case "retiring_emp_info". Also, order in descending order 
--- by to_date and emp_no  
 
ROW_NUMBER() OVER
 (PARTITION BY (emp_no)
 ORDER BY to_date DESC) rn
 FROM retiring_emp_info
 ) tmp WHERE rn = 1
ORDER BY emp_no;

---Group by Job Tittle

SELECT title, COUNT(title)

INTO new_title_group

FROM unique_title
GROUP BY title
ORDER BY COUNT(title) DESC;

---Deliverable 2 of the Challenge
--- Create a new table from three tables

SELECT  e.emp_no,
        e.first_name,
        e.last_name,
        ti.from_date,
        ti.title,
		ti.to_date,
		e.birth_date
		
--- Specify a new file for holding the new sets of data

INTO mentorship_info

--- Perform joining of two tables

FROM employees AS e
      INNER JOIN title AS ti
      ON (ti.emp_no = e.emp_no)

--- Filter as required

WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
     AND (ti.to_date = '9999-01-01');