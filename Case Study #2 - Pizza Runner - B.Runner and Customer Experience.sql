# 8 Week SQL Challenge - Case Study #2 - Pizza Runner

# Case Study - B.Runner and Customer Experience - Question 1 - How many runners signed up for each 1 week period? (week starts 2021-01-01)

	/* as week starts on the 1st Monday of the year, the first step is identify if the day 01-01-2021 correspond to the last week of 2020
    or the 1st week of 2021*/

SELECT
    DAYNAME(registration_date) AS name_of_week,
    WEEKOFYEAR(registration_date) AS day_of_week,
	registration_date
FROM
	runners;
    
	/* 01-01-2021 was Friday and correspond to week 53 of 2020. To correct it and show it as week 1 we have to add 3 days
    Friday to Monday */

SELECT 
    EXTRACT(WEEK FROM registration_date + 3) AS number_of_week,
    COUNT(runner_id) AS number_of_runners
FROM
    runners
GROUP BY number_of_week;

# Case Study - B.Runner and Customer Experience - Question 2 - What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pick up the order? 

SELECT 
    ro.runner_id,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE,
                co.order_time,
                ro.pickup_time)),
            2) AS avg_diff_order_pickup
FROM
    runner_orders ro
        JOIN
    customer_orders co ON ro.order_id = co.order_id
WHERE
    ro.distance IS NOT NULL
GROUP BY ro.runner_id
ORDER BY avg_diff_order_pickup;

# Case Study - B.Runner and Customer Experience - Question 3 - Is there any relationship between the number of pizzas and how long the order takes to prepare?

WITH cte as(
SELECT 
    co.order_id,
    COUNT(co.order_id) AS num_pizzas,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE,
                co.order_time,
                ro.pickup_time)),
            2) AS avg_preparation
FROM
    customer_orders co
        JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    distance IS NOT NULL
GROUP BY co.order_id)
SELECT
num_pizzas,
avg_preparation
FROM 
cte
GROUP BY num_pizzas;

# Case Study - B.Runner and Customer Experience - Question 4 - What was the average distance traveled for each customer?

SELECT 
    co.customer_id, ROUND(AVG(ro.distance), 1) AS distance
FROM
    customer_orders co
        JOIN
    runner_orders ro ON co.order_id = ro.order_id
WHERE
    ro.distance IS NOT NULL
GROUP BY co.customer_id;

# Case Study - B.Runner and Customer Experience - Question 5 - What was the difference between the longest and shortest delivery times for all orders?

WITH cte AS(
SELECT
ro.order_id,
co.order_time,
ro.pickup_time,
    ROUND(AVG(TIMESTAMPDIFF(MINUTE,
                co.order_time,
                ro.pickup_time)),
            2) AS avg_diff_order_pickup
FROM
runner_orders ro
JOIN
customer_orders co ON ro.order_id = co.order_id
WHERE ro.distance IS NOT NULL
GROUP BY order_id)
SELECT
max(avg_diff_order_pickup) - min(avg_diff_order_pickup) AS diff_longest_shortest_delivery
FROM 
cte;

# Case Study - B.Runner and Customer Experience - Question 6 - What was the average speed for each runner for each delivery and do you notice any trend for these values?

SELECT 
    runner_id,
    order_id,
    CONCAT(ROUND(distance * 60 / duration, 1),
            ' km/h') AS avg_speed
FROM
    runner_orders
WHERE
    distance IS NOT NULL
GROUP BY runner_id , order_id;

# Case Study - B.Runner and Customer Experience - Question 7 - What is the successful delivery percentage for each runner?

SELECT 
    runner_id,
    CONCAT(ROUND((COUNT(distance IS NOT NULL OR NULL) / COUNT(*) * 100),
                    2),
            '%') AS delivery_succesful
FROM
    runner_orders
GROUP BY runner_id;
