--Run the following command to add and update dob column in employee table
alter table  employee add dob date;
update employee set dob = dateadd(year,-1*emp_age,getdate())

/*1- write a query to print emp name , their manager name and diffrence in their age (in days) 
for employees whose year of birth is before their managers year of birth*/
   Select e.emp_name, m.emp_name as manager_name, DATEDIFF(dy, m.dob, e.dob) as age_diff from employee e
   join employee m
   on e.manager_id = m.emp_id
   where datepart(year,m.dob)> datepart(year,e.dob);

--2- write a query to find subcategories who never had any return orders in the month of november (irrespective of years)
		select o.sub_category from  orders	o
		left join  returns r
		on o.order_id = r.order_id
		where DATEPART (month, order_date) =11
		group  by o.sub_category
		having  count(r.order_id)= 0
									   	
/*3- orders table can have multiple rows for a particular order_id when customers buys more than 1 product in an order.
write a query to find order ids where there is only 1 product bought by the customer.*/
		select order_id from orders
		group by order_id
		having count(order_id)=1;

--4- write a query to print manager names along with the comma separated list(order by emp salary) of all employees directly reporting to him.
	   select m.emp_name as manager_name, STRING_AGG (e.emp_name, ',') within group (order by e.salary ) as employee_name from employee e
	   inner join employee m
	   on e.manager_id = m.emp_id
	   group by m.emp_name
		  		   
/*5- write a query to get number of business days between order_date and ship_date (exclude weekends). 
Assume that all order date and ship date are on weekdays only  */
		select order_id, order_date, ship_date,
		(DATEDIFF(DAY, order_date, ship_date)-(2* DATEDIFF(WW, order_date, ship_date))) as date_diff 
		from orders
		
--6- write a query to print 3 columns : category, total_sales and (total sales of returned orders)
		select o.category, sum(o.sales) as total_sales,
		sum(case
			when r.return_reason is not null then o.sales
		end)	as  returned_sale
		from orders o
		left join returns r
		on o.order_id =r.order_id
		group by o.category
--7- write a query to print below 3 columns
--category, total_sales_2019(sales in year 2019), total_sales_2020(sales in year 2020)
	  select category ,
	  sum(case when datepart(year, order_date) =2019 then sales end) as total_sales_2019,
	  sum(case when datepart(year, order_date) =2020 then sales end) as total_sales_2020	  
	  from orders
	  group by category;

--8- write a query print top 5 cities in west region by average no of days between order date and ship date.
	   select top 5 city,
	   avg(datediff(day,order_date, ship_date)) as avg_days_diff
	   from orders
	   where region = 'west'
	   group by city
	   order by avg_days_diff desc

--9- write a query to print emp name, manager name and senior manager name (senior manager is manager's manager)
		select * from employee
		select e.emp_name, m.emp_name as manager_name, sm.emp_name as senior_manager from employee e
		inner join employee m
		on e.manager_id = m.emp_id 
		inner join employee sm
		on m.manager_id = sm.emp_id
		order by e.emp_id;