


--1. Retrieve the total number of orders placed

SELECT COUNT(order_id) [Total Orders] FROM orders


--2. Calculate the total revenue generated from pizza sales.

select round(sum(pizzas.price * order_details.quantity),0) [Total Revenue]
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id

--3. Identify the highest-priced pizza.


select top 1 ROUND( pizzas.price,0)[Pizza Price], pizza_types.name
from pizzas join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
order by pizzas.price desc


--4. Identify the most common pizza size ordered.



select TOP 1 pizzas.size,COUNT(order_details.order_details_id) [Order Count]
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size

--5. List the top 5 most ordered pizza types along with their quantities.


 select Top 5 pizza_types.name, sum(order_details.quantity) [Total Quantity]
 from pizza_types join pizzas
 on pizza_types.pizza_type_id  = pizzas.pizza_type_id
 join order_details 
 on order_details.pizza_id = pizzas.pizza_id  
 group by pizza_types.name
 order by [Total Quantity] desc


 --6.	Join the necessary tables to find the total quantity of each pizza category ordered.

select pizza_types.category,sum(order_details .quantity) [Total Quantity]
from pizza_types join pizzas 
on pizza_types .pizza_type_id = pizzas .pizza_type_id 
join order_details 
on order_details .pizza_id = pizzas.pizza_id 
group by pizza_types.category
order by [Total Quantity] desc


--7. Determine the distribution of orders by hour of the day.

select datepart (hour, order_time) as HOUR,
COUNT(order_id) [Order Count] from orders 
group by datepart (hour, order_time)
order by HOUR


--8.Join relevant tables to find the category-wise distribution of pizzas.


SELECT 
    pt.category,
    SUM(od.quantity) AS total_pizzas_sold
FROM order_details od
JOIN pizzas p 
    ON od.pizza_id = p.pizza_id
JOIN pizza_types pt 
    ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category
ORDER BY total_pizzas_sold DESC;


--9.Group the orders by date and calculate the average number of pizzas ordered per day.

SELECT 
    AVG(pizzas_per_day ) AS avg_pizzas_per_day
FROM (
    SELECT 
        o.order_date,
        SUM(od.quantity) AS pizzas_per_day
    FROM orders o
    JOIN order_details od
      ON o.order_id = od.order_id
    GROUP BY o.order_date) daily_orders;


--10.	Determine the top 3 most ordered pizza types based on revenue.

select top 5 pt.name [Pizza Name], SUM(OD.quantity* P.price) [Total Revenue]
from order_details od join pizzas p
on p.pizza_id = od.pizza_id
join pizza_types pt
on p.pizza_type_id = pt.pizza_type_id
group by pt.name
order by[Total Revenue] desc

--11. Calculate the percentage contribution of each pizza type to total revenue.


SELECT 
    pt.name AS pizza_type,
    SUM(od.quantity * p.price) AS pizza_revenue,
    ROUND(
        SUM(od.quantity * p.price) * 100.0 / tr.total_revenue,
        2
    ) AS revenue_percentage
FROM order_details od
JOIN pizzas p
  ON od.pizza_id = p.pizza_id
JOIN pizza_types pt
  ON p.pizza_type_id = pt.pizza_type_id
CROSS JOIN (
    SELECT SUM(od.quantity * p.price) AS total_revenue
    FROM order_details od
    JOIN pizzas p
      ON od.pizza_id = p.pizza_id
) tr
GROUP BY pt.name, tr.total_revenue
ORDER BY revenue_percentage DESC;

--12. Analyze the cumulative revenue generated over time.

select order_date,
round(SUM(Revenue) over(order by order_date),2) as cum_revenue
from
(select o.order_date, SUM(od.quantity* p.price) [Revenue]
from order_details od join pizzas p
on od.pizza_id = p.pizza_id
join orders o 
on od.order_id = o.order_id
group by o.order_date) as sales;



--13. Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select category, name, revenue,
RANK() over (partition by category order by revenue desc) as Rank

from
(select pt.category, pt.name,
SUM((od.quantity)*p.price) [revenue]
from pizza_types pt 
join pizzas p
on pt.pizza_type_id = p.pizza_type_id
join order_details od 
on od.pizza_id = p.pizza_id
group by pt.category, pt.name
) as asdf;


 






































































































































































































































































































































































