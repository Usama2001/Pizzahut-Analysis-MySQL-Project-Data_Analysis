-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT pt.category, SUM(od.quantity) AS total_quantity
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category;

-- Determine the distribution of orders by hour of the day.
SELECT HOUR(order_time) AS hour_of_day, COUNT(*) AS order_count
FROM orders
GROUP BY HOUR(order_time)
ORDER BY hour_of_day;

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT category, COUNT(*) AS pizza_count
FROM pizza_types 
GROUP BY category;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
    
SELECT AVG (quantity) 
FROM 
    (SELECT orders.order_data, SUM(order_details.quantity) AS quantity
    FROM orders
    JOIN order_details ON orders.order_id = order_details.order_id 
    GROUP BY orders.order_data) AS order_quantity; 
 
-- Determine the top 3 most ordered pizza types based on revenue.
SELECT pt.name AS pizza_type, SUM(p.price * od.quantity) AS total_revenue
FROM order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN pizza_types pt ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.name
ORDER BY total_revenue DESC
LIMIT 3;

