# Gadgethub-Business-Analysis-SQL

## Project Overview
This project helps a company optimize its production strategy by identifying products that meet specific revenue and quantity targets. The goal is to reduce production costs by ensuring only profitable products are manufactured.

## Problem Statement
A company wants to cut down on its cost of production, producing only products that meet a revenue target of $1500 or a quantity target of 65 in the 1st, 2nd and 3rd quarter of 2024

## Criteria
A product qualifies for production if it meets at least one of the following conditions in Q1, Q2, or Q3 of 2024:

-Generates a minimum revenue of $1,500
-Has a sales quantity of at least 65 units

## Data Cleaning
1. Checked for duplicates and removed them to maintain data integrity.
2. Handled missing values in the dataset to prevent analysis errors.
3. Converted incorrect data formats to their appropriate types.
4.Identified and managed outliers to ensure high-quality data analysis.

``` sql
--change product id datatype to int
alter table product_data
alter column product_id INT;
```

```sql
--change product id constraint type to not null
alter table product_data
alter column product_id INT NOT NULL;
```

```sql
--make product_id the primary key
alter table product_data
add constraint pk_product_id primary key (product_id);
```

```sql
--selecting data drom order_data table
select * FROM order_data;
```

```sql
--making order_id primary key
alter table order_data
add constraint pk_order_data primary key (order_id);
```

```sql
--change product_id datatype in order table to int
alter table order_data
alter column product_id int;
```

```sql
alter table order_data
add constraint fk_product_id foreign key (product_id) references product_data (product_id);
```

```sql
--change unit_price to 2 decomal place
update product_data
set unit_price = convert(decimal(10,2),unit_price);
```

```sql
--change unit_cost to 2 decimal place
update product_data
set unit_cost = cast(unit_cost as decimal(10,2));
```

```sql
--selecting all data from product data
select * from product_data;
```

## Exploratory Data Analysis
1. Products that meet a revenue target of $1500

```sql
--join order_data and product_data
select * from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id;
```

```sql
--get revenue
select distinct product_name, unit_price * quantity as revenue from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id;
```

```sql
-- get the products with revenue > $1500 in 2024
select product_name, sum (unit_price * quantity) as revenue from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id
where year(order_date) = '2024' 
group by product_name
having sum (unit_price * quantity) > 1500
order by revenue desc;
```

2. Products that meets a quantity target of 65 in the 1st, 2nd and 3rd quarter of 2024

```sql
--get products with quantity > 65 in 2024
select product_name, sum(quantity) as total_quantity from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id
where year(order_date) = '2024' 
group by product_name
having sum(quantity) > 65 
order by total_quantity;
```

```sql
--using subquery
select product_name, total_quantity from (select product_name,
sum(quantity) as total_quantity from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id
where year(order_date) = '2024'
group by product_name) as product_quantity
where total_quantity > 65
order by total_quantity;
```

3. Products that meets a revenue target of $1500 quantity target of 65 in the 1st, 2nd and 3rd quarter of 2024
```sql
--get products with revenue > $1500 or quantity > 65 in 1st quarter in year 2024
select product_name, month(order_date) as month,
sum (unit_price * quantity) as revenue from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id
where month(order_date) in (01, 02, 03) and year(order_date) = '2024'
group by product_name, month(order_date)
having sum (unit_price * quantity) > 1500
order by revenue desc;
```

```sql
--get products with revenue > $1500 or quantity > 65 in 2nd quarter in year 2024
select product_name, month(order_date) as month,
sum (unit_price * quantity) as revenue from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id
where month(order_date) in (04, 05, 06) and year(order_date) = '2024'
group by product_name, month(order_date)
having sum (unit_price * quantity) > 1500
order by revenue desc;
```

## Key Insights & Recommendations

## Insights:

1. The dataset contain data of products details from jan to april which are Qtr 1 and Qtr 2 in 2024.
2. There are no product that sold more than 65 quantity in the 1st, 2nd and 3rd quarter of 2024.
3. Only 12 Products met the target and generated more than $1500 in revenue.

   

## Recommendations
1.






