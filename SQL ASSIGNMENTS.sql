CREATE DATABASE company;
USE company; /*using the existing database datascience*/
CREATE TABLE department(
deptId CHAR(5) PRIMARY KEY,
deptName VARCHAR(15) NOT NULL,
deptOff VARCHAR(10) NOT NULL,
deptHead INT
);

CREATE TABLE employees(
empId INT PRIMARY KEY,
empName VARCHAR(20) NOT NULL,
department CHAR(5),
contactNo INT,
emailId VARCHAR(30),
empHeadId INT,
FOREIGN KEY( department) REFERENCES department(deptId)
);

CREATE TABLE empsalary(
empId INT PRIMARY KEY,
salary INT NOT NULL,
isPermanent VARCHAR(3),
FOREIGN KEY(empId) REFERENCES employees(empId)
);

CREATE TABLE project(
projectId CHAR(3) PRIMARY KEY,
duration INT NOT NULL
);

CREATE TABLE country(
cId CHAR(3) PRIMARY KEY,
cname VARCHAR(10) NOT NULL
);

CREATE TABLE clients(
clientId CHAR(4) PRIMARY KEY,
clientName VARCHAR(20) NOT NULL,
cId CHAR(3),
FOREIGN KEY(cId) REFERENCES country(cId)
);

CREATE TABLE employeeproject(
empId INT PRIMARY KEY,
projectId CHAR(3),
clientId CHAR(4),
startYear YEAR,
endYear YEAR,
FOREIGN KEY(empId) REFERENCES employees(empId),
FOREIGN KEY(projectId) REFERENCES project(projectId),
FOREIGN KEY(clientId) REFERENCES clients(clientId)
);

ALTER TABLE department
ADD CONSTRAINT 
FOREIGN KEY (deptHead)
REFERENCES employees (empId);

ALTER TABLE employees
ADD CONSTRAINT 
FOREIGN KEY (empHeadId)
REFERENCES employees (empId);

INSERT INTO department VALUES
('E-101','HR','Monday',105),
('E-102','Development','Tuesday',101),
('E-103','House Keeping','Saturday',103),
('E-104','Sales','Sunday',104),
('E-105','Purchase','Tuesday',104);


INSERT INTO employees VALUES
(101,'Isha','E-101',1234567890,'isha@gmail.com',105),
(102,'Priya','E-104',1234567890,'priya@yahoo.com',103),
(103,'Neha','E-101',1234567890,'neha@gmail.com',101),
(104,'Rahul','E-102',1234567890,'rahul@yahoo.com',105),
(105,'Abhishek','E-101',1234567890,'abhishek@gmail.com',102);

INSERT INTO empsalary VALUES
(101,2000,'Yes'),
(102,10000,'Yes'),
(103,5000,'No'),
(104,1900,'Yes'),
(105,2300,'Yes');

INSERT INTO project VALUES
('p-1',23),
('p-2',15),
('p-3',45),
('p-4',2),
('p-5',30);

INSERT INTO country VALUES
('c-1','India'),
('c-2','USA'),
('c-3','China'),
('c-4','Pakistan'),
('c-5','Russia');

INSERT INTO clients VALUES
('cl-1','ABC Group','c-1'),
('cl-2','PQR','c-1'),
('cl-3','XYZ','c-2'),
('cl-4','tech altum','c-3'),
('cl-5','mnp','c-5');

INSERT INTO employeeproject VALUES
(101,'p-1','cl-1',2010,2010),
(102,'p-2','cl-2',2010,2012),
(103,'p-1','cl-3',2013,NULL),
(104,'p-4','cl-1',2014,2015),
(105,'p-4','cl-5',2015,NULL);

/* 1. List all employees */
SELECT * FROM employees;

/* 2. List all departments */
SELECT * FROM department;

/* 3. List all projects */
SELECT * FROM project;

/* 4. List all countries */
SELECT * FROM country;

/* 5. List all clients */
SELECT * FROM clients;

/* 6. List all employee salaries */
SELECT * FROM empsalary;

/* 7. List all employee project details */
SELECT * FROM employeeproject;

/*8.Select the employees who are not permanent*/
SELECT empId,salary,isPermanent
FROM empsalary 
WHERE isPermanent='No';

/*9.Select all employees whose employeehead is 105 */
SELECT empId,empName,department,contactNo,emailId,empHeadId
FROM employees 
WHERE empId = 105;

/*10. Select the details of the employee whose name starts with P */
select empId,empName,department,contactNo,emailId,empHeadId 
FROM employees 
WHERE empName LIKE 'P%';

/*11. Select the details of the employee who work either for department E-104 or E-102.*/
SELECT empId,empName,department,contactNo,emailId,empHeadId 
FROM employees 
WHERE department = 'E-104' OR department ='E-102';
#select empId,empName,department,contactNo,emailId,empHeadId from employees where department in ('E-104','E-102');


/*12. What is the department name for DeptID E-102? */
SELECT deptName 
FROM department 
WHERE deptId='E-102';

/*13. What is total salary that is paid to permanent employees? */
SELECT SUM(salary) AS totalSalary
FROM empsalary 
WHERE isPermanent="Yes";

/*14. How many permanent candidate take salary more than 5000. */
SELECT COUNT(empId) AS totalCount 
FROM empsalary 
WHERE isPermanent="Yes" AND salary > 5000;

/*15. Select the detail of employee whose emailId is in gmail.*/
SELECT empId,empName,department,contactNo,emailId,empHeadId 
FROM employees 
WHERE emailId LIKE '%gmail%';

/*16. List name of all employees whose name ends with a.*/
SELECT empName 
FROM employees 
WHERE empName LIKE "%a";

/*17. List the number of employees in each project. */
SELECT projectId,COUNT(empId) AS totalEmployees 
FROM employeeproject 
GROUP BY projectId;

/*18. How many project started in year 2010.*/
SELECT COUNT(projectId) AS totalProjects 
FROM employeeproject 
WHERE startYear="2010";

/*19. How many project started and finished in the same year.*/
SELECT COUNT(projectId) AS totalProjects 
FROM employeeproject 
WHERE startYear=endYear;

/*20. select the name of the employee whose name's 3rd character is 'h'. */
SELECT empName 
FROM employees 
WHERE empName LIKE "__h%";

/*21. Fetch the first record from employee project table */
SELECT empId,projectId,clientId,startYear,endYear 
FROM employeeproject 
LIMIT 1 ;

/*22.Display first 50% records from the country table */

SELECT * 
FROM country 
LIMIT 3;

/*23. Display all employees where name not in Isha and Neha*/
SELECT empId,empName,department,contactNo,emailId,empHeadId 
FROM employees 
WHERE empName NOT IN ('Isha','Neha');

/*24. Display all departments whose Off day is Sunday */
SELECT deptId,deptName,deptOff,deptHead 
FROM department 
WHERE deptOff = "Sunday";

/*25. Display only the odd rows from the employee table*/
SELECT * 
FROM (SELECT *,ROW_NUMBER() OVER (ORDER BY empId) AS rowNum FROM employees) AS numberedRows 
WHERE MOD(rowNum,2)=1;

/*26. Display the names of all clients in uppercase*/
SELECT UPPER(clientName) AS clients 
FROM clients;

/*27. Display the years in which the projects started */
SELECT DISTINCT startYear 
FROM employeeproject;

/*28. Display the first three characters of country name */
SELECT LEFT(cname,3) AS firstThree 
FROM country; 
#select substring(cname,1,3) as firstThree from country; 

/*29. Display the first three characters of country name in uppercase with the title country code */
SELECT UPPER(LEFT(cname,3)) AS countryCode 
FROM country; 

/*30. Sort and display employees in the ascending order of their names */
SELECT empId,empName,department,contactNo,emailId,empHeadId 
FROM employees 
ORDER BY empName ;

/*31. Sort and display employees in the descending order of their names*/
SELECT empId,empName,department,contactNo,emailId,empHeadId 
FROM employees 
ORDER BY empName DESC;

/* JOIN QUERIES */

/* 1. Select the department name of the company which is assigned to the employee 
whose employee id is greater than 103. */

SELECT empId,empName,department,deptName
FROM employees em
JOIN department de
ON em.department = de.deptId
WHERE empId > 103 ;

/* 2. Select the name of the employee who is working under Abhishek.*/
SELECT e1.empId,e1.empName "Employee",e2.empName "Manager",e1.empHeadId "Manager ID"
FROM employees e1
JOIN employees e2
ON e1.empHeadId = e2.empId
WHERE e2.empName = "Abhishek";

/* 3. Select the name of the employee who is department head of HR. */
SELECT deptId,deptName,deptHead "Dept Head ID",empName "Dept Head"
FROM department de
JOIN employees em
ON de.deptHead = em.empId
WHERE deptName = "HR";

/*4. Select the name of the employee head who is permanent. */
SELECT DISTINCT em1.empName,es.empId "Manager ID",es.isPermanent
FROM employees em
JOIN employees em1
ON em.empHeadId = em1.empId
JOIN empSalary es
ON em.empHeadId = es.empId
WHERE isPermanent = "Yes";

/*5. Select the name and email of the Dept Head who is not Permanent. */
SELECT DISTINCT empName,emailId,deptHead "Dept Head ID",isPermanent "Status"
FROM employees em
JOIN department de
ON em.empId = de.deptHead
JOIN empsalary es
ON es.empId = em.empId
WHERE isPermanent = "Yes";

/*6. Select the employee whose department off is Monday */
SELECT empId,empName,deptName,deptOff 
FROM employees em
JOIN department de
ON em.department = de.deptId
WHERE deptOff = "Monday";

/*7. Select the Indian client’s details. */
SELECT clientId,clientName,cname 
FROM clients cl
JOIN country co
ON cl.cId = co.cId
WHERE cname = "India";

/*8. Select the details of all employees working in development department. */
SELECT empId,empName,deptName,contactNo,emailId,empHeadId 
FROM employees em
JOIN department de
ON em.department = de.deptId
WHERE deptName = "Development";

/*9. Select the name, email and salary of the employees */
SELECT em.empId,empName,emailId,salary 
FROM employees em
JOIN empsalary es
ON em.empId = es.empId;

/*10. Select the name and email of the permanent employees */
SELECT empName,emailId,isPermanent "Status"
FROM employees em
JOIN empsalary es
ON em.empId = es.empId
WHERE isPermanent = "Yes";

/*11. select employee name, department name, client name, country, project id, duration, start year,
 end year */
 SELECT empName,deptName,clientName,cname,ep.projectId,duration,startYear,endYear
 FROM employeeproject ep
 JOIN employees em
 ON ep.empId = em.empId
 JOIN department de
 ON em.department = de.deptId
 JOIN clients cl
 ON ep.clientId = cl.clientId
 JOIN country co
 ON cl.cId = co.cId
 JOIN project pr
 ON ep.projectId = pr.projectId;
 
 /*12. Display all clients and their respective projects */
 SELECT cl.clientName,ep.projectId
 FROM clients cl
 JOIN employeeproject ep
 ON  cl.clientId = ep.clientId
 GROUP BY clientName;
 
 /*13. Display all clients who doesn’t have projects*/
 SELECT cl.clientName,ep.projectId
 FROM clients cl
 LEFT JOIN employeeproject ep
 ON  cl.clientId = ep.clientId
 WHERE ep.projectId IS NULL;
 
 /*14. Display the projects not having employees assigned */
 SELECT pr.projectId,duration,empId
 FROM project pr
 LEFT JOIN employeeproject ep
 ON pr.projectId = ep.projectId
 WHERE ep.projectId IS NULL;
 
 /*15. Display all countries and client names */
 SELECT cname,co.cId,clientName
 FROM clients cl
 RIGHT JOIN country co
 ON cl.cId = co.cId;
 
 /*16. Display employee name, department name and department head name */
  SELECT em.empName,deptName,deptId,em2.empName "Dept Head"
 FROM employees em
 JOIN department de
 ON em.department = de.deptId
 JOIN employees em2
 ON de.deptHead = em2.empId;
 
 /*17. Display the employees belonging to the same department */
 SELECT deptId,deptName "Department",
 GROUP_CONCAT(em.empName)
 FROM employees em
 JOIN department de
 ON em.department = de.deptId
 GROUP BY deptName;