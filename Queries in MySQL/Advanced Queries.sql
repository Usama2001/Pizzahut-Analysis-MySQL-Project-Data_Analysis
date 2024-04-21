SELECT * FROM pizzahutanalysis.pizza_types;

-- Calculate the percentage contribution of each pizza type to total revenue.
SELECT pt.name AS pizza_type, 
       SUM(p.price * od.quantity) AS total_revenue,
       SUM(p.price * od.quantity) / (SELECT SUM(p.price * od.quantity) FROM order_details od JOIN pizzas p ON od.pizza_id = p.pizza_id) * 100 
       AS revenue_percentage
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id 
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name;


-- Analyze the cumulative revenue generated over time.
SELECT order_date,
      ROUND(SUM(total_revenue),2) AS cumulative_revenue
FROM (
    SELECT DATE(o.order_data) AS order_date, 
           SUM(p.price * od.quantity) AS total_revenue
    FROM order_details od
    JOIN orders o ON od.order_id = o.order_id
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY order_date
) AS daily_revenue
GROUP BY order_date
ORDER BY order_date;


-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT category, pizza_type, total_revenue, RANK() OVER(partition by category order by total_revenue desc) AS RN
FROM (
    SELECT pt.category,
           pt.name AS pizza_type,
           SUM(p.price * od.quantity) AS total_revenue,
           ROW_NUMBER() OVER(PARTITION BY pt.category ORDER BY SUM(p.price * od.quantity) DESC) AS ranks
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
    GROUP BY pt.category, pt.name
) AS ranked_pizzas
WHERE ranks <= 3;
