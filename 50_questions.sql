-- Q-1. Write an SQL query to fetch “FIRST_NAME” from Worker table using the alias name as <WORKER_NAME>.

SELECT first_name as WORKER_NAME FROM WORKER;

-- Q-2. Write an SQL query to fetch “FIRST_NAME” from Worker table in upper case.

SELECT UPPER(first_name) FROM WORKER;

-- Q-3. Write an SQL query to fetch unique values of DEPARTMENT from Worker table.

SELECT DEPARTMENT FROM WORKER GROUP BY DEPARTMENT;
SELECT DISTINCT(DEPARTMENT) FROM WORKER;

-- Q-4. Write an SQL query to print the first three characters of  FIRST_NAME from Worker table.

SELECT SUBSTRING(FIRST_NAME, 1, 3) FROM WORKER;

-- Q-5. Write an SQL query to find the position of the alphabet (‘b’) in the first name column ‘Amitabh’ from Worker table.

SELECT INSTR(FIRST_NAME, "b") FROM WORKER WHERE first_name = 'Amitabh'; 

-- Q-6. Write an SQL query to print the FIRST_NAME from Worker table after removing white spaces from the right side.

SELECT RTRIM(FIRST_NAME) FROM WORKER;

-- Q-7. Write an SQL query to print the DEPARTMENT from Worker table after removing white spaces from the left side.


SELECT LTRIM(DEPARTMENT) FROM WORKER;


-- Q-8. Write an SQL query that fetches the unique values of DEPARTMENT from Worker table and prints its length.

SELECT DEPARTMENT, LENGTH(DEPARTMENT) FROM WORKER GROUP BY DEPARTMENT;
/*OR*/
SELECT DISTINCT DEPARTMENT, LENGTH(DEPARTMENT) FROM WORKER;

-- Q-9. Write an SQL query to print the FIRST_NAME from Worker table after replacing ‘a’ with ‘A’.

SELECT REPLACE(first_name, "a", "A")  FROM WORKER;

-- Q-10. Write an SQL query to print the FIRST_NAME and LAST_NAME from Worker table into a single column COMPLETE_NAME.
-- A space char should separate them.

SELECT CONCAT(first_name , " ", last_name) as COMPLETE_NAME FROM WORKER;

-- Q-11. Write an SQL query to print all Worker details from the Worker table order by FIRST_NAME Ascending.

SELECT * FROM WORKER ORDER BY first_name ASC;

-- Q-12. Write an SQL query to print all Worker details from the Worker table order by 
-- FIRST_NAME Ascending and DEPARTMENT Descending.

SELECT * FROM WORKER ORDER BY first_name ASC, department DESC;

-- Q-13. Write an SQL query to print details for Workers with the first name as “Vipul” and “Satish” from Worker table.

SELECT * FROM WORKER WHERE first_name = 'satish' OR first_name = 'vipul';
/* OR */
SELECT * FROM WORKER WHERE first_name IN ('satish', 'vipul');

-- Q-14. Write an SQL query to print details of workers excluding first names, “Vipul” and “Satish” from Worker table.

SELECT * FROM WORKER WHERE first_name NOT IN ('Vipul', 'satish');
/* OR */
SELECT * FROM WORKER WHERE first_name <> 'Vipul' OR first_name <> 'satish';


-- Q-15. Write an SQL query to print details of Workers with DEPARTMENT name as “Admin*”.

SELECT * FROM worker WHERE department = 'Admin';

/* OR */

SELECT * FROM worker WHERE department LIKE 'Admin%';
/* 'Admin' would've worked as well we kept 'Admin%' so just in case if some values are 'administration' they
will getconsidered too.*/


-- Q-16. Write an SQL query to print details of the Workers whose FIRST_NAME contains ‘a’.

SELECT * FROM worker WHERE first_name like '%a%';

-- Q-17. Write an SQL query to print details of the Workers whose FIRST_NAME ends with ‘a’.

SELECT * FROM worker WHERE first_name like '%a';

-- Q-18. Write an SQL query to print details of the Workers whose FIRST_NAME ends with ‘h’ and contains six alphabets.

SELECT * FROM worker WHERE first_name like '%h' AND LENGTH(first_name) = 6;

/* OR BETTER WAY */
SELECT * FROM worker WHERE first_name like '_____h';

/* OR WORST WAY USING SUBQUERY*/

SELECT * FROM (SELECT * FROM (SELECT *, LENGTH(first_name) as len FROM worker) as t WHERE len = 6) as tt
WHERE first_name LIKE '%h';

-- Q-19. Write an SQL query to print details of the Workers whose SALARY lies between 100000 and 500000.

SELECT * FROM worker WHERE salary BETWEEN 100000 AND 500000;

-- Q-20. Write an SQL query to print details of the Workers who have joined in Feb’2014.

SELECT * FROM worker WHERE EXTRACT(MONTH FROM joining_date) = 2 AND EXTRACT(YEAR FROM joining_date) = 2014;

/* OR */

SELECT * FROM worker WHERE MONTH (joining_date) = 2 AND YEAR (joining_date) = 2014;
SELECT MONTH('23-02-2023');
-- Q-21. Write an SQL query to fetch the count of employees working in the department ‘Admin’.

SELECT department, COUNT(department) FROM worker WHERE department = 'Admin';
/* din't have to use groupby as after where filter there is only one department remaining'

-- Q-22. Write an SQL query to fetch worker full names with salaries >= 50000 and <= 100000.

SELECT CONCAT(first_name, " ", last_name), salary FROM worker WHERE salary BETWEEN 50000 and 100000;

-- Q-23. Write an SQL query to fetch the no. of workers for each department in the descending order.

SELECT department, COUNT(department) FROM worker GROUP BY department ORDER BY COUNT(department) DESC;

-- Q-24. Write an SQL query to print details of the Workers who are also Managers.


 SELECT w.*, t.worker_title FROM worker as w INNER JOIN title as t ON w.worker_id = t.worker_ref_id WHERE t.worker_title = 'Manager';

/* first works "FROM" it joins both tables and then applies "WHERE" title = manager */


-- Q-25. Write an SQL query to fetch number (more than 1) of same titles in the ORG of different types.

SELECT * FROM (SELECT worker_title, COUNT(worker_title) as number FROM title GROUP BY worker_title) t 
WHERE number > 1;

/* or better way we can apply filter on group by with having*/

SELECT worker_title, COUNT(worker_title) as number FROM title GROUP BY worker_title 
HAVING number > 1;

-- Q-26. Write an SQL query to show only odd rows from a table.

SELECT * FROM worker WHERE MOD(worker_id,2) = 1;

-- Q-27. Write an SQL query to show only even rows from a table. 


SELECT * FROM worker WHERE MOD(worker_id,2) = 0;


-- Q-28. Write an SQL query to clone a new table from another table.

CREATE TABLE clone_table LIKE worker;
INSERT INTO clone_table SELECT * FROM worker;


-- Q-29. Write an SQL query to fetch intersecting records of two tables.

SELECT worker.* FROM worker INNER JOIN clone_table USING (worker_id); 

-- Q-30. Write an SQL query to show records from one table that another table does not have.
-- MINUS

SELECT w.* FROM worker AS w LEFT JOIN clone_table AS cw USING (worker_id) WHERE cw.worker_id IS NULL; 

-- Q-31. Write an SQL query to show the current date and time.
-- DUAL

SELECT current_timestamp();

/* OR */

SELECT curdate();
SELECT NOW();

-- Q-32. Write an SQL query to show the top n (say 5) records of a table order by descending salary.

SELECT * FROM worker ORDER BY salary DESC LIMIT 5;

-- Q-33. Write an SQL query to determine the nth (say n=5) highest salary from a table.

SELECT * FROM (SELECT salary, ROW_NUMBER() OVER(ORDER BY salary DESC) as rnk FROM (SELECT DISTINCT salary FROM worker ORDER BY salary DESC) as T) as T2 WHERE rnk = 5;
/* OR */
SELECT salary FROM (SELECT salary, DENSE_RANK() OVER (ORDER BY salary DESC) as rnk FROM worker) as T WHERE rnk = 5;
/* OR */
SELECT salary FROM worker ORDER BY salary DESC LIMIT 4,1;

-- Q-34. Write an SQL query to determine the 5th highest salary without using LIMIT keyword.




 
-- Q-35. Write an SQL query to fetch the list of employees with the same salary.


SELECT w1.* FROM worker as w1, worker as w2 WHERE w1.salary = w2.salary AND w1.worker_id <> w2.worker_id;
/* first we joined same table where salaries were equal then we gave condition that worker_id shouldn't be
same coz we want to compare salary with ever person except that person himself */

SELECT * FROM worker WHERE salary = (
SELECT Salary FROM (SELECT COUNT(SALARY) as salcnt, salary FROM worker GROUP BY salary) as t WHERE salcnt > 1
);

/* OR */


SELECT * FROM worker WHERE salary IN (
SELECT salary FROM worker GROUP BY salary HAVING COUNT(salary) >1);



-- Q-36. Write an SQL query to show the second highest salary from a table using sub-query.


SELECT DISTINCT MAX(salary) as maximum_salary FROM worker WHERE salary <> (SELECT MAX(salary) FROM worker);

/* we can further find 3rd highest also with given syntax by adding some more level

SELECT MAX(salary) FROM worker WHERE salary < (
SELECT DISTINCT MAX(salary) as maximum_salary FROM worker WHERE salary <> (SELECT MAX(salary) FROM worker));
*/

-- Q-37. Write an SQL query to show one row twice in results from a table.

SELECT * FROM worker UNION ALL SELECT * FROM worker ORDER BY worker_id;

-- Q-38. Write an SQL query to list worker_id who does not get bonus.

SELECT worker_id FROM worker WHERE worker_id NOT IN (
SELECT DISTINCT w.worker_id FROM worker as w INNER JOIN bonus as b ON w.worker_id = b.worker_ref_id);

/* OR */

SELECT worker_id FROM worker WHERE worker_id NOT IN (
SELECT DISTINCT worker_ref_id FROM bonus);

-- Q-39. Write an SQL query to fetch the first 50% records from a table.

SELECT * FROM worker WHERE worker_id <= (SELECT COUNT(*)/2 FROM worker);


-- Q-40. Write an SQL query to fetch the departments that have less than 4 people in it.

SELECT department FROM worker GROUP BY department HAVING COUNT(department) <4;

-- Q-41. Write an SQL query to show all departments along with the number of people in there.

SELECT department, COUNT(department) FROM worker GROUP BY department;

-- Q-42. Write an SQL query to show the last record from a table.

SELECT * FROM worker WHERE worker_id = (SELECT COUNT(*) FROM worker);
 /* OR */
SELECT * FROM worker WHERE worker_id = (SELECT MAX(worker_id) FROM worker);
 
 
-- Q-43. Write an SQL query to fetch the first row of a table.

SELECT * FROM worker WHERE worker_id = (SELECT MIN(worker_id) FROM worker);


-- Q-44. Write an SQL query to fetch the last five records from a table.

SELECT * FROM worker WHERE worker_id >= (SELECT MAX(worker_id)-4 FROM worker);

/* OR */

(SELECT * FROM worker ORDER BY worker_id DESC LIMIT 5) ORDER BY worker_id;


-- Q-45. Write an SQL query to print the name of employees having the highest salary in each department.



SELECT t1.* FROM worker AS t1 JOIN (SELECT  MAX(salary) as salary, department FROM worker GROUP BY department) AS t2 ON t1.salary = t2. salary AND t1.department = t2.department;

/* first we derived max sal dept wise by suing aggr function max and grouping by dept. then we used this as 
a table and joined it with original table*/

/* OR */
SELECT first_name, last_name, salary FROM worker WHERE (department, SALARY) IN (SELECT department, MAX(salary) FROM worker GROUP BY department);

 
 
SELECT first_name, last_name, salary FROM worker WHERE SALARY IN (SELECT MAX(salary) FROM worker GROUP BY department);

/*ABOVE ONE is the wrong way bcz its telling max salary. For ex it said max sal dept wise were 
HR 2000
ADMIN 3000
now we using max salary as condition in original table so it will give us details of those that have 
2000 and 3000 salary but it will not tell the dept that means if it will give me details of 2000 from HR 
and ADMIN both where we reuqired detals from HR only in case of 2000. */


-- Q-46. Write an SQL query to fetch three max salaries from a table using co-related subquery






-- DRY RUN AFTER REVISING THE CORELATED SUBQUERY CONCEPT FROM LEC-9.

-- Q-47. Write an SQL query to fetch three min salaries from a table using co-related subquery




-- Q-48. Write an SQL query to fetch nth max salaries from a table.

/* TAKING n as 5 so 5th max salary*/

SELECT salary FROM worker ORDER BY salary DESC LIMIT 4,1;


-- Q-49. Write an SQL query to fetch departments along with the total salaries paid for each of them.

SELECT SUM(salary), department FROM worker GROUP BY department;


-- Q-50. Write an SQL query to fetch the names of workers who earn the highest salary.

SELECT first_name FROM worker WHERE salary = (SELECT MAX(salary) FROM worker);


CREATE TABLE t1 (a VARCHAR(1), b VARCHAR(2));

INSERT INTO t1 VALUES (1,2), (2,4),(2,1),(3,2),(4,2),(5,6),(6,5), (7, 9); 

SELECT * FROM t1;

SELECT a,b FROM (SELECT a*b, a, b, ROW_NUMBER() OVER( PARTITION BY a*b ORDER BY a*b) AS rnk FROM t1) as tt WHERE rnk =1;

/* OR */

SELECT lt.* FROM T1 AS lt LEFT JOIN T1 as rt ON lt.a = rt.b AND lt.b = rt.a 
WHERE rt.a IS NULL OR lt.a < rt.a;

