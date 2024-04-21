-- Retrieve the total number of orders placed.
SELECT COUNT(*) AS total_orders
FROM orders;

-- Calculate the total revenue generated from pizza sales.
SELECT ROUND (SUM(pizzas.price * order_details.quantity),1) AS total_revenue
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id;

-- Identify the highest-priced pizza.
SELECT *
FROM pizzas
WHERE price = (SELECT MAX(price) FROM pizzas);

-- Identify the most common pizza size ordered.
SELECT size, COUNT(*) AS total_orders
FROM order_details
JOIN pizzas ON order_details.pizza_id = pizzas.pizza_id
GROUP BY size
ORDER BY total_orders DESC;

-- List the top 5 most ordered pizza types along with their quantities.
SELECT pt.name AS pizza_type, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_quantity DESC
LIMIT 5;

