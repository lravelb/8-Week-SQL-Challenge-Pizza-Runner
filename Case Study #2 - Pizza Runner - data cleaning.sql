# 8 Week SQL Challenge - Case Study #2 - Pizza Runner

# data cleaning - runner_orders table

# dealing the null values. Convert text type "null" and empty cells to NULL

UPDATE pizza_runner.runner_orders
SET pickup_time = NULL
WHERE pickup_time = 'null' or pickup_time = '';

UPDATE pizza_runner.runner_orders
SET distance = NULL
WHERE distance = 'null' or distance = '';

UPDATE pizza_runner.runner_orders
SET duration = NULL
WHERE duration = 'null' or duration = '';

UPDATE pizza_runner.runner_orders
SET cancellation = NULL
WHERE cancellation = 'null' or cancellation = '';

# extract text "km" from distance and "minutes,mins,minute" from duration

UPDATE pizza_runner.runner_orders
SET distance = TRIM('km' FROM distance)
WHERE distance LIKE '%km';

UPDATE pizza_runner.runner_orders
SET duration = TRIM('%min%' FROM distance)
WHERE duration LIKE '%min%';

# convert data type: pickup_time to timestamp, distance FLOAT and duration to INT

ALTER TABLE pizza_runner.runner_orders
MODIFY pickup_time TIMESTAMP NULL,
MODIFY distance FLOAT NULL,
MODIFY duration INT NULL;

# data cleaning - customer_orders table

# dealing the null values. Convert text type "null" and empty cells to NULL

UPDATE pizza_runner.customer_orders
SET exclusions = NULL
WHERE exclusions = 'null' or exclusions = '';

UPDATE pizza_runner.customer_orders
SET extras = NULL
WHERE extras = 'null' or extras = '';

# EXTRA and EXCLUSION TABLE normalization: values separated by commas. Creation of two new tables:

CREATE TABLE extras (
    order_id INT,
    pizza_id INT,
    extra_id INT
);

INSERT INTO extras (order_id, pizza_id, extra_id)
SELECT DISTINCT order_id, pizza_id, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(extras, ',', n), ',', -1)) AS extra_id
FROM customer_orders
JOIN (
    SELECT 1 as n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
) nums ON LENGTH(extras) - LENGTH(REPLACE(extras, ',', '')) >= n - 1;

CREATE TABLE exclusions (
    order_id INT,
    pizza_id INT,
    exclusion_id INT
);

INSERT INTO exclusions (order_id, pizza_id, exclusion_id)
SELECT DISTINCT order_id, pizza_id, TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(exclusions, ',', n), ',', -1)) AS exclusion_id
FROM customer_orders
JOIN (
    SELECT 1 as n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4
) nums ON LENGTH(exclusions) - LENGTH(REPLACE(exclusions, ',', '')) >= n - 1;

# data cleaning - pizza_recipes

# creation of a new table separating values by comas in differents rows

DROP TABLE IF EXISTS pizza_recipes_normalized;
CREATE TABLE pizza_recipes_normalized (
    pizza_id INT,
    topping_id INT
);

INSERT INTO pizza_recipes_normalized (pizza_id, topping_id)
SELECT 
    pizza_id, 
    TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(toppings, ',', n), ',', -1)) AS topping_id
FROM pizza_recipes
JOIN (
    SELECT 1 as n UNION SELECT 2 UNION SELECT 3 UNION SELECT 4 UNION SELECT 5 UNION SELECT 6 UNION SELECT 7 UNION SELECT 8
) nums ON LENGTH(toppings) - LENGTH(REPLACE(toppings, ',', '')) >= n - 1;