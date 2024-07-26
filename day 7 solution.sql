/*1- write a query to print 3rd highest salaried employee details for each department 
(give preferece to younger employee in case of a tie). 
In case a department has less than 3 employees then print the details of highest salaried employee in that department.*/
  with cte as( 
			select *,
			dense_rank() over(partition by dept_id order by salary desc , emp_age asc) as Salary_wise_rnk
			from employee),
  cnt as(
		select dept_id, count(*) as emp_count
		from employee 
		group by dept_id)
	select cte.*  
	FROM cte
	inner join 
	cnt 
	on cte.dept_id = cnt.dept_id
	where Salary_wise_rnk= 3 or(emp_count<3 and Salary_wise_rnk =1)
	 	 
--2- write a query to find top 3 and bottom 3 products by sales in each region.
	 with total_sales as(
	 select region, product_id, sum(sales) as t_sales 
	 from orders
	 group by region, product_id
	 ), rnk as(
	 select *, 
	 dense_rank() over(partition by region order by t_sales desc) as top_product,
	 dense_rank() over(partition by region order by t_sales asc) as bottom_product
	 from total_sales)
	 
	 select region, product_id, t_sales,
	 (case when top_product<=3 then ' TOP 3' else 'Bottom 3' end) ranking
	 from rnk
	 where bottom_product <=3 or top_product <=3
	 order by region
	 	 
--3- Among all the sub categories..which sub category had highest month over month growth by sales in Jan 2020.
	 with cat_sales as(
	 select sub_category, sum (sales) as tsales, format(order_date, 'yyyyMM') as order_month 
	 from orders
	 group by sub_category,format(order_date, 'yyyyMM'))
	, lead_sales as(
		select *, lead(tsales) over (partition by sub_category order by order_month desc) prev_month_sales
	 from cat_sales)
	 select top 1 *, (tsales- prev_month_sales)/prev_month_sales as mom_growth
	 from lead_sales
	 where order_month = '202001'
	 order by mom_growth desc;					   	
			 
--4- write a query to print top 3 products in each category by year over year sales growth in year 2020.
	 with cat_sales as (
		select category,
			product_id,
			datepart(year,order_date) as order_year, sum(sales) as sales
		from orders
		group by category,
				product_id,
				datepart(year,order_date)
		)
	, prev_year_sales as (
			select *,
				lag(sales) over(partition by category order by order_year) as prev_year_sales
			from cat_sales)
	,rnk as (
			select   * ,
				rank() over(partition by category order by (sales-prev_year_sales)/prev_year_sales desc) as rn
			from prev_year_sales
			where order_year='2020')
	select * from rnk where rn<=3;

--5- create below 2 tables 

	create table call_start_logs									 
	(
	phone_number varchar(10),																						   
	start_time datetime
	);
	insert into call_start_logs values
	('PN1','2022-01-01 10:20:00'),('PN1','2022-01-01 16:25:00'),('PN2','2022-01-01 12:30:00')
	,('PN3','2022-01-02 10:00:00'),('PN3','2022-01-02 12:30:00'),('PN3','2022-01-03 09:20:00');
	create table call_end_logs
	(
	phone_number varchar(10),
	end_time datetime
	);
	insert into call_end_logs values
	('PN1','2022-01-01 10:45:00'),('PN1','2022-01-01 17:05:00'),('PN2','2022-01-01 12:55:00')
	,('PN3','2022-01-02 10:20:00'),('PN3','2022-01-02 12:50:00'),('PN3','2022-01-03 09:40:00')
	;

/*write a query to get start time and end time of each call from above 2 tables.
Also create a column of call duration in minutes.  Please do take into account that
there will be multiple calls from one phone number and each entry in start table has a corresponding entry in end table.*/

	select s.phone_number,
		s.rn,s.start_time,
		e.end_time, 
		datediff(minute,start_time,end_time) as duration
	from (
		select *,
			row_number() over(partition by phone_number order by start_time) as rn  
		from call_start_logs) s
	inner join (
		select *,
			row_number() over(partition by phone_number order by end_time) as rn  
		from call_end_logs) e
	on s.phone_number = e.phone_number and s.rn=e.rn;

/*signup on https://datalemur.com/questions --its free

solve below questions. You can write SQLs and verify on the platform itself.

Note : The platform supports only postgreSQL so there may be few diffrences in functions. Listing down some important diffrences:

SQL server -> postgreSQL
to extract a part of the date
datepart(day,order_date) -> extract (day from order_date)

to convert datetime/timestamp field to date or any other type of type casting 
cast(order_date as date) -> order_date::date*/


--6-https://datalemur.com/questions/top-fans-rank


--7-https://datalemur.com/questions/sql-highest-grossing

--8-https://datalemur.com/questions/top-drugs-sold

--9-https://datalemur.com/questions/yoy-growth-rate

--10-https://datalemur.com/questions/long-calls-growth