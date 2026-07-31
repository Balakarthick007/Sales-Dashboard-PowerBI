use salesDB
go
--Module 1: Data validation------------------------------------------------

--Total rows
select count(*) as Total_rows from dbo.salesDb;
--preview data
select top 10 * from dbo.salesDB;
--check null values
select count(*)  as null_values from dbo.salesDB where order_id is null;
--check duplicate orders
select order_id,count(*) as duplicate_count from dbo.salesDB group by order_id having count(*)>1;
--  verify data types
select column_name,data_type from information_schema.columns where table_name ='salesDB';


--Module 2: Basic KPI Analysis----------------------------------------------

-- Total revenue
select sum(revenue) as Total_revenue from dbo.salesDB;
--Total orders
select count(order_id) as Total_orders from dbo.salesDB;
--Total Customers
select count(distinct customer_id) as Total_customer from dbo.salesDB;
--Total Quatity sold
select count(quantity) as Product_quantity from dbo.salesDB;
--Average order value
select avg(revenue) as AVG_order_value from dbo.salesDB;
--Average customer rating
select avg(customer_rating) as Avg_delivery_rating from  dbo.salesDB;
--Average delivery days
select avg(delivery_days) as avg_delivery_days from dho.salesDB;
--Highest revenue
select max(revenue) as higest_revenue from dbo.salesDB;
--Lowest revenue
select min(revenue) as lowest_revenue from dbo.salesDB;


--Module 3: Product Analysis------------------------------------------------

--Revenue by category

select product_category,sum(revenue) 
as Total_revenue 
from dbo.salesDB 
where product_category='Electronics'
group by product_category;

--Quantity sold by regin

select Region,sum(quantity) 
as Total_Quantity 
from dbo.salesDb 
where region ='east' 
group by region;

--Qty sold by category
select product_category,sum(revenue) as Total_sales from dbo.salesDB group by product_category;

--Top 10 products

select top 10 product_category,sum(Revenue) as top_10_products from dbo.salesDB 
group by product_category
order by top_10_products desc;

--Bottom 10 products
select top 10 product_category,sum(Revenue) as top_10_products from dbo.salesDB 
group by product_category
order by top_10_products asc;

--Module 4: Customer Analysis----------------------------------------------------

--Top customers
select top 10  customer_id,count(order_id)as Total_order,sum(revenue)as Total_revenue from dbo.salesDB
group by customer_id
order by total_revenue desc;

--Customer spending
--Total spending
select customer_id,sum(revenue) as Total_Spending from dbo.salesDB group by customer_id 
order by Total_spending desc;

--Top 10 customer by spending--
select top 10 customer_id,sum(revenue) as Total_Spending from dbo.salesDB group by customer_id 
order by Total_spending desc;

--Customer spending with number of order--
select customer_id,count(order_id) as Total_orders,
sum(revenue) as Total_revenue from dbo.salesDB group by customer_id
order by Total_revenue desc;

--Customer rating Analysis--

--max cutomer rating
select customer_id,max(customer_rating)as cus_max_rating from dbo.salesDB
group by customer_id;

--min customer rating

select customer_id,min(customer_rating) cus_min_rating from dbo.salesDB
group by customer_id;

--Average customer rating

select  customer_id ,avg(customer_rating) as Avg_cus_rating from dbo.salesDB
group by customer_id;


--Region analysis--------------------------------------------------------------

--Revenue by region

select Region,sum(revenue) as Total_revenue from dbo.salesDB group by region;

--orders by  region
select Region,count(order_id) as Total_orders from dbo.salesDB group by region;

--Best performing region
select region,sum(revenue) as Total_revenue from dbo.salesDB group by region
order by Total_revenue desc;

--Module 6: Payment Analysis-------------

--Revenue by payment method
select payment_method,sum(revenue) as Total_revenue from dbo.salesDB
group by payment_method;

--orders by payment_method
select payment_method,count(order_id) as Total_orders from dbo.salesDB
group by payment_method; 


--Module 7: Delivery Analysis

--Average delivery days
select avg(delivery_days) as Avg_delivery from dbo.salesDB;

--Fastest delivery 
select min(delivery_days) as Fastest_delivery from dbo.salesDB;

--slowest delivery 
select max(delivery_days) as Fastest_delivery from dbo.salesDB;


--Module 8: Discount Analysis

--Average discount
select avg(discount) as Avg_discount from dbo.salesDB;

--Highest discount
select max(discount) as Highest_discount from dbo.salesDB;
-- lowest discount
select min(discount) as Lowest_discount from dbo.salesDB;

--Module 9:Time Analysis
exec sales_data;
--Monthly revenue
select Month(order_date)as Month,sum( revenue)as Monthly_revenue from dbo.salesDB 
group by Month(order_date) order by month;

--Yearly revenue
select year(order_date)as Year,sum( revenue)as Yearly_revenue from dbo.salesDB 
group by Year(order_date) order by year;

--Monthly orders
select month(order_date) as Month,count(order_id) as Monthly_orders from dbo.salesDB 
group by month(order_date) order by month asc;

--Module 10: Adavance SQL----------------

--Case
--categorize by spending
select customer_id,sum(revenue) as Total_revenue,exec sales_data
case
 when sum(revenue)>=5000 then 'Gold'
 when sum(revenue)>=3000 then 'Silver'
 else 'Bronze' 
 end as Customer_type from dbo.salesDB
 group by customer_id;

  --product categoies generated more than 20,000
  select product_category,sum(revenue) as  Total_revenue from dbo.salesDB
  group by product_category having sum(revenue)>20000;



  --Subqueries for customer spent more than avg customer
  select * from( select Customer_id,sum(revenue) as Total_spending
  from dbo.salesDB group by customer_id)as customer_sales where total_spending>
  (select avg(Total_spending) from
  (select sum(revenue) as Total_spending
  from dbo.salesDB group by customer_id) as Avg_sales);

--CTE--
With Top_10_Customer_revenue
as( select Customer_id,sum(revenue) 
as Total_revenue from dbo.salesDB 
group by customer_id)
select Top 10 * from Top_10_customer_revenue order by Total_revenue desc;

--Monthly revenue--
With MonthlyRevenue
as(select Year(order_date)as Year,month(order_date) as Month ,sum(revenue) 
as Total_revenue
from dbo.salesDB group by year(order_date),month(order_date))
select* from monthlyRevenue order by year,month;

--View---
--customerRevenue--
 create view CustomerRevenue
 as select customer_id,sum(revenue) as Total_revenue from dbo.salesDB
 group by customer_id;

 --CustomerMonthlyRevenue--
 create view MonthlyRevenue
 as select year(order_date)as Year,Month(order_date) as Month ,sum(revenue) 
as Total_revenue
from dbo.salesDB group by year(order_date),month(order_date);

select* from monthlyRevenue order by year,month asc;


--Windows function---
--Top 5 customer by revenue---
--Row_number--

select top 5 Customer_id,sum(revenue) as Total_revenue,ROW_NUMBER() 
over(order by sum(revenue) desc) 
from dbo.salesDB group by customer_id;

--Rank--
select  Customer_id,sum(revenue) as Total_revenue,
RANK() over(order by sum(revenue) desc) from dbo.salesDB 
group by customer_id;

--Dense rank--

select  Customer_id,sum(revenue) as Total_revenue,
DENSE_RANK() over(order by sum(revenue) desc) from dbo.salesDB 
group by customer_id;

--Lag---
 --Monthly revenue lag
 with MonthlyRevenue as
 (
 select year(order_date) as Year,month(order_date) as Month, sum(revenue) as Total_revenue  
 from dbo.salesDB 
 group by  year(order_date),month(order_date))
 select Year,Month,Total_revenue, 
 lag(Total_revenue) over(order by year,month) as Previous_Month,
 Total_revenue - 
 lag(Total_revenue) over(order by year,month) as Revenue_Growth
 from MonthlyRevenue 
 order by Year,Month;
 
 --Monthly  revenue growth
 with MonthlyRevenueGrowth as
 ( select year(order_date) as Year, Month(order_date) as Month, sum(revenue) as Total_revenue 
 from dbo.salesDB
 group by year(order_date),Month(order_date))
 select year,Month,Total_revenue,lead(Total_revenue) over(order by year, month) as Next_Month_revenue,
 lead(Total_revenue) over(order by year, month) -Total_revenue as Expected_change 
 from MonthlyRevenueGrowth
 order by year,Month;


 ---Stored Procedure
 -- For salesboard

 Exec sales_data;

 --For Top 10 customers

 create procedure Top_10_customer as
 begin
 select top 10 customer_id, sum(revenue) as Total_revenue from dbo.salesDB 
 group by customer_id 
 order by Total_revenue desc;
 end;

 exec top_10_customer;

 --Monthly revenue
  create procedure Monthly_revenue as
  begin
  select year(order_date)as Year,Month(order_date) as Month,sum(revenue) as Total_revenue
  from dbo.salesDB 
  group by year(order_date),Month(order_date)
  order by year,month;
  end;

 Exec Monthly_revenue

 --revenue by region

 create procedure region_revenue as
 begin
 select Region, sum(revenue)as Total_revenue from dbo.salesDB 
 group by region
 order by region;
 end;
 
 exec Region_revenue;

 --Revenue by Category 
 create procedure Revenue_category as
 begin
 select product_category,sum(revenue) as Total_revenue from dbo.salesDB group by product_category;
 end;

  exec revenue_category;

  --Top product

  create procedure Top_product as
  begin
  select top 10 product_category,sum(revenue) as Total_revenue
  from dbo.salesDB 
  group by product_category 
  order by Total_revenue desc;
  end;

  exec Top_product;

  --Delivery Analysis

 create  procedure deliveryDays as
 begin
 select Customer_id,Product_Category,Delivery_days 
 from dbo.salesDB 
 order by delivery_days asc;
 end;

 exec deliveryDays;

 --Discount Analysis

 create procedure Discount_percent as
 begin
 select Discount,sum(revenue)As Total_revenue ,count(order_id) as Total_orders
 from dbo.salesDB 
 group by discount 
 order by discount;
 end;

 exec Discount_percent;

 --Index for customer_id
  create Nonclustered index IX_customer
  on dbo.salesDB(customer_id);
  
  select * from dbo.salesDB where customer_id='1000';
  
  --Index for order_id

  create Nonclustered index IX_order_id
  on dbo.salesDB (order_id);

  exec sp_helpindex 'dbo.salesDB';

  select * from dbo.salesDB where order_id='10001';

  -- index for region

  create Nonclustered index IX_region
  on dbo.salesDB(region);

  select * from dbo.salesDB where region='East';

  create Nonclustered index IX_product_Category
  on dbo.salesDB(product_category);

  select * from dbo.salesDB where product_category='clothing';
