-- create databases
Drop database if exists retails_project;
create database retails_project;
show databases;

-- using database

use retails_project;

-- create table`retails_project`
Drop table if exists retail_sales;
create table if not exists retail_sales (
transactions_id int primary key,
sale_date date,
sale_time time,
customer_id int,
gender varchar(10),
age int,
category varchar(10),
quantiy int,
price_per_unit int,
cogs int,
total_sale int
);

-- Data preparation and cleaning
select * from retail_sales;
select count(*) from retail_sales;
select * from retail_sales 
where 
	transactions_id is null
    or sale_date is null
    or sale_time is null
    or customer_id is null
    or gender is null
    or age is null
    or category is null
    or quantiy is null
    or price_per_unit is null
    or cogs is null
    or total_sale is null;
    
    
-- Data Exploration

select count(*) as  total_sales from retail_sales;

select count(distinct customer_id) as  total_customers, count(distinct transactions_id) as  total_transactions from retail_sales;

select  distinct category  from retail_sales group by category;

select gender  from retail_sales group by gender;

select sale_date, count(sale_date) as  total_transaction  from retail_sales group by sale_date;


-- Aalysis and business problems

-- Business problems
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)


-- Write a SQL query to retrieve all columns for sales made on '2022-11-05' or '2023-11-22'?
select * 
from retail_sales 
where sale_date = '2022-11-05' 
		or sale_date = '2023-11-22';
        
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 3 in the month of Nov-2022
select * from retail_sales
	where category = 'Clothing' and  date_format(sale_date,'%Y-%m')='2022-11' and quantiy>=3;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select category, sum(total_sale) as total_sales, count(*) as total_orders from retail_sales
	group by category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

select round(avg(age),0) as average_age from retail_sales
	where category = 'Beauty';
    
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
select * 
from retail_sales 
where total_sale>1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
select gender,category, count(transactions_id) as total_transactions
from retail_sales 
group by 1,2;


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
select * from (
	select 
		extract(YEAR from sale_date)as year,
		extract(MONTH from sale_date)as Month,
		round(avg(total_sale),2) as average_sale,
		rank() over(partition by year order by average_sale desc) as RANK
			from retail_sales
			GROUP BY 1,2
) as t1
where RANK=1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
	
    SELECT customer_id,gender, sum(total_sale) as total_sale FROM retail_sales
		group by 1 order by total_sale desc limit 5;


-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

select category,count(distinct customer_id) as unique_customers 
from retail_sales 
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
select
	case 
		when extract(HOUR from sale_time) <12 then 'morning'
		when extract(HOUR from sale_time) between 12 and 17 then 'afternoon'
    else 'evening'
END as shift, count(transactions_id) as total_orders
from retail_sales group by shift;
 
