select * from product_data
select * from order_data
--change product id datatype to int
alter table product_data
alter column product_id int

--change product id constraint type to not null
alter table product_data
alter column product_id int not null

--make product_id the primary key
alter table product_data
add constraint pk_product_id primary key (product_id)

--selecting data drom order_data table
select * from order_data

--making order_id primary key
alter table order_data
add constraint pk_order_data primary key (order_id)

--change product_id datatype in order table to int
alter table order_data
alter column product_id int

alter table order_data
add constraint fk_product_id foreign key (product_id) references product_data (product_id)

--change unit_price to 2 decomal place
update product_data
set unit_price = convert(decimal(10,2),unit_price) 

--change unit_cost to 2 decimal place
update product_data
set unit_cost = cast(unit_cost as decimal(10,2))

select * from product_data

/* A company wants to cut down on its cost of production, producing only products that meet a 
revenue target of $1500 or a quantity target of 65 in the 1st, 2nd and 3rd quarter of 2024 */


--join order_data and product_data
select * from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id

--get revenue 
select product_name, unit_price * quantity as revenue from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id


select distinct product_name, unit_price * quantity as revenue from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id

-- get the products with revenue > $1500 in 2024
select product_name, sum (unit_price * quantity) as revenue from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id
where year(order_date) = '2024' 
group by product_name
having sum (unit_price * quantity) > 1500
order by revenue desc

--using subquery
select product_name, revenue from (select product_name, sum(unit_price * quantity) as revenue from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id
where year(order_date) = '2024'
group by product_name) as product_revenue
where revenue > 1500 
order by revenue desc


--get the order_date from order_data
select order_date from order_data
where year(order_date) = '2024' 
order by order_date desc

--get products with quantity > 65 in 2024
select product_name, sum(quantity) as total_quantity from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id
where year(order_date) = '2024' 
group by product_name
having sum(quantity) > 65 
order by total_quantity

--using subquery
select product_name, total_quantity from (select product_name, sum(quantity) as total_quantity from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id
where year(order_date) = '2024'
group by product_name) as product_quantity
where total_quantity > 65
order by total_quantity

--get products with revenue > $1500 and quantity > 65
select product_name, sum(quantity) as total_quantity, sum(unit_price * quantity) as revenue from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id
where year(order_date) = '2024' 
group by product_name
having sum(quantity) > 65 or sum(unit_price * quantity) > '1500'
order by total_quantity

--get products with revenue > $1500 in 1st quarter in year 2024
select product_name, month(order_date) as month, sum (unit_price * quantity) as revenue from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id
where month(order_date) in (01, 02, 03) and year(order_date) = '2024'
group by product_name, month(order_date)
having sum (unit_price * quantity) > 1500
order by revenue desc

--get products with revenue > $1500 in 2nd quarter in year 2024
select product_name, month(order_date) as month, sum (unit_price * quantity) as revenue from product_data as pd
inner join order_data as od
on pd.product_id = od.product_id
where month(order_date) in (04, 05, 06) and year(order_date) = '2024'
group by product_name, month(order_date)
having sum (unit_price * quantity) > 1500
order by revenue desc