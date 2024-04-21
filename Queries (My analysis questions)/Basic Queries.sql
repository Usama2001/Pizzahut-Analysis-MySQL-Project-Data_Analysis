-- Retrieve the total number of orders placed for each month.
SELECT MONTH(order_data) AS month, COUNT(*) AS total_orders
FROM orders
GROUP BY MONTH(order_data);

-- Calculate the average revenue per order.
SELECT AVG(total_revenue) AS avg_revenue_per_order
FROM (
    SELECT SUM(p.price * od.quantity) AS total_revenue
    FROM order_details od
    JOIN pizzas p ON od.pizza_id = p.pizza_id
    GROUP BY od.order_id
) AS order_revenues;

-- Identify the pizza type with the highest total quantity ordered.
SELECT pt.name AS pizza_type, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 1;

-- Identify the most common pizza size ordered for each pizza type.
SELECT pt.name AS pizza_type, p.size, COUNT(*) AS total_orders
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name, p.size
ORDER BY pt.name, total_orders DESC;

-- List the top 5 highest revenue-generating pizza types along with their revenue.
SELECT pt.name AS pizza_type, SUM(p.price * od.quantity) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 5;


