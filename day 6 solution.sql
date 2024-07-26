/*1- write a query to find premium customers from orders data.
Premium customers are those who have done more orders than average no of orders per customer. */
	with cte as (
	select customer_id, COUNT(distinct order_id) as order_count
	from orders
	group by customer_id
	)
	select * 
	from cte
	where order_count > (select avg(order_count) from cte)
	
	select customer_id, COUNT(distinct order_id) as order_count
	from orders
	group by customer_id 
	having COUNT(distinct order_id) > (select (count(*)/COUNT(distinct order_id)) from orders)

	 																							 				
--2- write a query to find employees whose salary is more than average salary of employees in their department
	 select e2.emp_name,e.dept_id,e2.salary  
	 from
	 (select dept_id,avg(salary) as avg_salary
	 from employee
	 group by dept_id)e
	 inner join
	 (select emp_name, dept_id, salary 
	 from employee) e2
	 on e.dept_id = e2.dept_id
	 where e2.salary> e.avg_salary

	 select e2.*
	 from employee e2
	 inner join
	 (select dept_id,avg(salary) as avg_salary
	 from employee
	 group by dept_id)e
	 on e.dept_id = e2.dept_id
	 where e2.salary> e.avg_salary
		 		 
--3- write a query to find employees whose age is more than average age of all the employees.
	  select * 
	  from employee
	  where emp_age > (select avg(emp_age)  as avg_age 
						from  employee)

--4- write a query to print emp name, salary and dep id of highest salaried employee in each department 
	select * 
	from employee 
	where salary in (select max(salary) as highest_salary 
					from employee
					group by dept_id)

	select e.* 
	from employee e
	inner join 
	(select dept_id,max(salary) as max_sal 
	from employee 
	group by dept_id)  d
	on e.dept_id=d.dept_id
	where salary=max_sal

--5- write a query to print emp name, salary and dep id of highest salaried overall
	 select * 
	 from employee
	 where salary = (select max(salary) from employee)

--6- write a query to print product id and total sales of highest selling products (by no of units sold) in each category
	 with total_units_sold as(
	 select category, product_id, sum(quantity) as quantity_sold
	 from orders
	 group by category, product_id),
	 cat_max_sold as(
	 select category, max(quantity_sold) as highest_selling_prod 
	 from total_units_sold
	 group by category)

	 select t.*
	 from total_units_sold t
	 left join 
	 cat_max_sold c
	 on t.category = c.category
	 where t.quantity_sold = c.highest_selling_prod
	 

/*signup on https://datalemur.com/questions --its free

solve below questions. You can write SQLs and verify on the platform itself.

Note : The platform supports only postgreSQL so there may be few diffrences in functions. Listing down some important diffrences:

SQL server -> postgreSQL
to extract a part of the date
datepart(day,order_date) -> extract (day from order_date)

to convert datetime/timestamp field to date or any other type of type casting 
cast(order_date as date) -> order_date::date */


--7- https://datalemur.com/questions/signup-confirmation-rate

/*New TikTok users sign up with their emails. They confirmed their signup by replying to the text confirmation to activate their accounts. Users may receive multiple text messages for account confirmation until they have confirmed their new account.

A senior analyst is interested to know the activation rate of specified users in the emails table. Write a query to find the activation rate. Round the percentage to 2 decimal places.

Definitions:

emails table contain the information of user signup details.
texts table contains the users' activation information.
Assumptions:

The analyst is interested in the activation rate of specific users in the emails table, which may not include all users that could potentially be found in the texts table.
For example, user 123 in the emails table may not be in the texts table and vice versa.
Effective April 4th 2023, we added an assumption to the question to provide additional clarity.

emails Table:
---------------------------
| Column Name |	Data Type |
| email_id	  | 	INT	  |
| user_id	  |	INT		  |
| signup_date |	DATETIME  |
---------------------------

emails Example Input:
---------------------------------------------
| email_id|	user_id	|	signup_date		    |
| 125	  |	7771	|	06/14/2022 00:00:00	|	
| 236	  |	6950	|	07/01/2022 00:00:00	|
| 433	  |	1052	|	07/09/2022 00:00:00	|
---------------------------------------------

texts Table:
-------------------------
|Column Name  |	Type	|
|text_id	  | integer	|
|email_id	  | integer	|
|signup_action|	varchar	|
-------------------------

texts Example Input:
---------------------------------------
| text_id |	email_id |	signup_action |
| 6878	  |	125		 |	Confirmed	  |
| 6920	  | 236		 |	Not Confirmed |
| 6994	  | 236		 |	Confirmed	  |
---------------------------------------

'Confirmed' in signup_action means the user has activated their account and successfully completed the signup process.

Example Output:
---------------
|confirm_rate |
---------------
| 0.67		  |
 --------------	 */
PostgreSQL 14

 SELECT 
round(count(t.email_id)::decimal /COUNT(distinct e.email_id),2) as confirm_rate  
FROM emails E   
LEFT JOIN 
texts T
on e.email_id = t.email_id
and t.signup_action = 'Confirmed';

In MSSQL
Select 
round(cast(count(t.email_id) as  decimal)/ nullif(count(distinct e.email_id),0),2) as confirm_rate 
from emails e
left join texts t
on e.email_id = t.email_id 
and t.signUp_action = 'confirmed';

--8- https://datalemur.com/questions/supercloud-customer
/*
A Microsoft Azure Supercloud customer is defined as a customer who has purchased at least one product 
from every product category listed in the products table.

Write a query that identifies the customer IDs of these Supercloud customers.

customer_contracts Table:
--------------------------
|Column Name |	Type	 |
|customer_id |	integer	 |
|product_id	 |	integer	 |
|amount		 |	integer	 |
--------------------------

customer_contracts Example Input:
-------------------------------------
| customer_id |	product_id | amount |
| 1			  |		1	   | 1000	|
| 1			  |		3	   | 2000	|
| 1			  |		5	   | 1500	|
| 2			  |		2	   | 3000	|
| 2			  |		6	   | 2000	|
-------------------------------------
products Table:
-----------------------------
|Column Name 	  |	Type	|
|product_id		  |	integer	|
|product_category |	string	|
|product_name	  |	string	|
-----------------------------

products Example Input:
---------------------------------------------------------
|product_id | product_category|	product_name			 |
| 1			| Analytics		  |	Azure Databricks		 |
| 2			| Analytics		  |	Azure Stream Analytics	 |
| 4			| Containers	  |	Azure Kubernetes Service |
| 5			| Containers	  |	Azure Service Fabric	 |
| 6			| Compute		  |	Virtual Machines		 |
| 7			| Compute		  |	Azure Functions			 |
----------------------------------------------------------
Example Output:
---------------
|customer_id  |
|1			  |
---------------

Explanation:
Customer 1 bought from Analytics, Containers, and Compute categories of Azure, 
and thus is a Supercloud customer. Customer 2 isn't a Supercloud customer, 
since they don't buy any container services from Azure.
*/
SELECT c.customer_id
FROM customer_contracts c
inner JOIN
products P
on p.product_id = c.product_id
group by c.customer_id
having count(DISTINCT p.product_category)=
(SELECT COUNT(DISTINCT product_category)from products)
