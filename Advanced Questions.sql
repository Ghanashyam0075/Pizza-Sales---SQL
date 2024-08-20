use pizzahut;

-- Advanced Questions

-- 1) Calculate the percentage contribution of each pizza type to total revenue.


SELECT 
    pizza_types.category,
    ROUND(SUM(order_details.quantity * pizzas.price)) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;

-- Below is final output


SELECT 
    pizza_types.category,
    ROUND((SUM(order_details.quantity * pizzas.price) / (SELECT 
                    ROUND(SUM(order_details.quantity * pizzas.price)) AS total_sales
                FROM
                    order_details
                        JOIN
                    pizzas ON pizzas.pizza_id = order_details.pizza_id)) * 100,
            1) AS revenue
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN
    order_details ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.category
ORDER BY revenue DESC;




-- 2) Analyze the cumulative revenue generated over time.

select order_date,
sum(daily_revenue)
over (order by order_date) as cumulative_revenue
from 
(select orders.order_date,
sum(order_details.quantity * pizzas.price) as daily_revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders
on orders.order_id = order_details.order_id
group by order_date) as sales;


-- 3) Determine the top 3 most ordered pizza types based on revenue for each pizza category.

select name, category, revenue, rn
from
(select category, name, revenue,
rank() over(partition by category order by revenue desc) as rn
from
(select pizza_types.name, pizza_types.category,sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join
pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join 
order_details
on 
order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category, pizza_types.name) as a) as b
where rn <=3;
