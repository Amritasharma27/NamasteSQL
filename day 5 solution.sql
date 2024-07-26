create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');

/*1- write a query to produce below output from icc_world_cup table.
team_name, no_of_matches_played , no_of_wins , no_of_losses	*/
	select * from icc_world_cup;

	with wins_by as (
	(select team_1 as team, COUNT(*)as match_played,
	 (case when team_1 = winner then 1 else 0 end)as win
	 from icc_world_cup
	 group by Team_1, Winner)
	union all
	(select Team_2 as team, count(*)as match_played,
	(case when team_2 = winner then 1 else 0 end)as win
	 from icc_world_cup
	 group by Team_2, Winner) )
	 select team, COUNT(*) as total_match, 
	 SUM(win) as match_won,(COUNT(*)-SUM(win)) as match_lost 
	 from wins_by
	 group by team

/*2- write a query to print first name and last name of a customer using orders table
(everything after first space can be considered as last name) customer_name, first_name,last_name */
	Select customer_name,
	trim(LEFT(customer_name, charindex(' ',customer_name))) as first_name,
	trim(RIGHT(customer_name,(LEN(customer_name)-charindex(' ',customer_name)))) as last_name
	from orders

	select customer_name, 
	SUBSTRING(customer_name,0, CHARINDEX(' ', customer_name))as first_name,
	SUBSTRING (customer_name,CHARINDEX(' ', customer_name)+1, LEN(customer_name)-CHARINDEX(' ', customer_name)+1 ) as last_name
	from orders

/*3- write a query to print below output using drivers table. Profit rides are the no of rides where end location of a ride is same as start location of immediate next ride for a driver
id, total_rides , profit_rides */
dri_1,5,1
dri_2,2,0

Run below script to create drivers table:
create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');

select * from drivers;

 SELECT d1.id, 
 count(d1.id) as total_rides, 
 sum(iif(d1.end_loc= d2.start_loc,1,0)) as profit_rides
FROM drivers d1
 LEFT JOIN drivers d2 
 ON d1.id=d2.id and
 d1.end_loc=d2.start_loc and 
 d1.end_time=d2.start_time
group by d1.id;

SELECT d1.id, 
 count(d1.id) as total_rides, 
 count(case when d2.id is not null then 1 end) as profit_rides
FROM drivers d1
 LEFT JOIN drivers d2 
 ON d1.id=d2.id and
 d1.end_loc=d2.start_loc and 
 d1.end_time=d2.start_time
group by d1.id;

SELECT d1.id, 
 count(d1.id) as total_rides, 
 count(d2.id) as profit_rides
FROM drivers d1
 LEFT JOIN drivers d2 
 ON d1.id=d2.id and
 d1.end_loc=d2.start_loc and 
 d1.end_time=d2.start_time
group by d1.id;

/*4- write a query to print customer name and no of occurence of character 'n' in the customer name.
customer_name , count_of_occurence_of_n*/
	select customer_name,
	(LEN(customer_name) - len(replace(customer_name, 'n', '')))	count_of_occurence_of_n
	from orders

/*5-write a query to print below output from orders data. example output
hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region
category , Technology, ,
category, Furniture, ,
category, Office Supplies, ,
sub_category, Art , ,
sub_category, Furnishings, ,
--and so on all the category ,subcategory and ship_mode hierarchies */
	select 'category' as hierarchy_type,
	category as hierarchy_name,
	sum(case when region= 'west' then sales end) as total_sales_in_west_region,
	sum(case when region= 'east' then sales end) as total_sales_in_east_region
	from orders
	group by category
	union all
	select 'sub_category' as hierarchy_type,
	sub_category as hierarchy_name,
	sum(case when region= 'west' then sales end) as total_sales_in_west_region,
	sum(case when region= 'east' then sales end) as total_sales_in_east_region
	from orders
	group by sub_category

/*6- the first 2 characters of order_id represents the country of order placed . write a query to print 
total no of orders placed in each country (an order can have 2 rows in the data 
when more than 1 item was purchased in the order but it should be considered as 1 order*/
	 select distinct LEFT(order_id,2) as country_code,
	 COUNT(distinct order_id) as order_count
	 from orders
	 group by LEFT(order_id,2)
