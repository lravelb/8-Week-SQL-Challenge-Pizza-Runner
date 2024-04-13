# 8 Week SQL Challenge - Case Study #2 - Pizza Runner

# Case Study - A.Pizza Metrics - Question 1 - How many pizzas were ordered?

SELECT 
    COUNT(order_id) AS pizzas_orderer
FROM
    customer_orders;

# Case Study - A.Pizza Metrics - Question 2 - How many unique customer orders were made?

SELECT 
    COUNT(DISTINCT order_id) AS total_orders
FROM
    customer_orders;

# Case Study - A.Pizza Metrics - Question 3 - How many succesful orders were delivered by each runner?

SELECT 
	runner_id,
    COUNT(order_id) AS orders_delivered
FROM
    runner_orders
WHERE
    pickup_time IS NOT NULL
GROUP BY runner_id;

# Case Study - A.Pizza Metrics - Question 4 - How many of each type of pizza was delivered?

SELECT 
    pn.pizza_name, COUNT(co.pizza_id) AS pizza_type_delivered
FROM
    customer_orders co
        JOIN
    pizza_names pn ON co.pizza_id = pn.pizza_id
        JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    ro.pickup_time IS NOT NULL
GROUP BY co.pizza_id;

# Case Study - A.Pizza Metrics - Question 5 - How many Vegetarian and Meatlovers were ordered by each customer?

SELECT 
    co.customer_id, pn.pizza_name, COUNT(co.pizza_id) AS type_by_customer
FROM
    customer_orders co
        JOIN
    pizza_names pn ON co.pizza_id = pn.pizza_id
        JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    ro.pickup_time IS NOT NULL
GROUP BY co.customer_id, co.pizza_id;

# Case Study - A.Pizza Metrics - Question 6 - What was the maximum number of pizzas delivered is a single order?

SELECT 
    co.order_id, COUNT(co.order_id) AS pizzas_by_order
FROM
    customer_orders co
        JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    ro.pickup_time IS NOT NULL
GROUP BY co.order_id
ORDER BY pizzas_by_order DESC
LIMIT 1;

# Case Study - A.Pizza Metrics - Question 7 - For each customer, hoy many pizzas has at least 1 change and hoW many had no changes?

SELECT 
    customer_id,
    SUM(CASE
        WHEN
            exclusions IS NOT NULL
                OR extras IS NOT NULL
        THEN
            1
        ELSE 0
    END) AS at_least_1_change,
    SUM(CASE
        WHEN exclusions IS NULL AND extras IS NULL THEN 1
        ELSE 0
    END) AS no_changes
FROM
    customer_orders co
        JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    distance IS NOT NULL
GROUP BY customer_id;

# Case Study - A.Pizza Metrics - Question 8 - How many pizzas were delivered that had both exclusions and extras?

SELECT 
    COUNT(*) AS quantity_pizzas_both_exclusions
FROM
    customer_orders co
        JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    distance IS NOT NULL
        AND exclusions IS NOT NULL
        AND extras IS NOT NULL
GROUP BY customer_id;

# Case Study - A.Pizza Metrics - Question 9 - What was the total volume of pizzas ordered for each hour of the day?

SELECT 
    HOUR(order_time) AS hour_of_day, COUNT(*) AS pizzas_orderer
FROM
    customer_orders
GROUP BY hour_of_day
ORDER BY hour_of_day;

# Case Study - A.Pizza Metrics - Question 9 - What was the volume of orders for each day of the week?

SELECT
DAYNAME(order_time) AS day_of_week, COUNT(*) AS pizzas_orderer
FROM
    customer_orders
GROUP BY day_of_week
ORDER BY day_of_week;