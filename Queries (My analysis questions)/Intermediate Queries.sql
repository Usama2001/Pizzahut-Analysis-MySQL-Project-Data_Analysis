-- Determine the distribution of orders by hour of the day.
SELECT pt.category, SUM(p.price * od.quantity) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

-- Find the distribution of orders by day of the week.
SELECT DAYOFWEEK(order_date) AS day_of_week, COUNT(*) AS order_count
FROM orders
GROUP BY day_of_week
ORDER BY day_of_week;

-- Determine the category-wise distribution of pizzas for each size.
SELECT pt.category, p.size, COUNT(*) AS pizza_count
FROM pizzas p
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category, p.size;


-- Calculate the average revenue per day.
SELECT order_date, AVG(total_revenue) AS avg_revenue_per_day
FROM (
    SELECT DATE(o.order_date) AS order_date, SUM(p.price * od.quantity) AS total_revenue
    FROM order_details od
    JOIN orders o ON od.order_id = o.order_id
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY order_date
) AS daily_revenue
GROUP BY order_date;


-- Identify the top 3 highest revenue-generating pizza types for each pizza category.
SELECT category, pizza_type, total_revenue
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



