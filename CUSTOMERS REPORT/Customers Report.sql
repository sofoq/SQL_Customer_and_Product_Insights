-- This SQL script creates a view called 'customer_report' that provides insights into customer behavior.
-- It extracts customer details, aggregates sales data, segments customers into categories, and calculates key metrics.
-- The final report includes:
--   - Total orders, total sales, and total quantity purchased.
--   - Customer lifespan and segmentation (VIP, Regular, New).
--   - Age group classification and recency of last order.
--   - Average order value and average monthly spend.



--CREATE VIEW customer_report AS 

-- Step 1: Extracts base-level sales and customer details
WITH base_query AS (
    SELECT
        f.order_number,
        f.product_key,
        f.order_date,
        f.sales_amount,
        f.quantity,
        c.customer_key,
        c.customer_number,
        CONCAT_WS(' ', c.first_name, c.last_name) AS full_name,
        c.birthdate,
        DATEDIFF(YEAR, c.birthdate, GETDATE()) AS age
    FROM gold.fact_sales f
    LEFT JOIN gold.dim_customers c ON f.customer_key = c.customer_key
    WHERE f.order_date IS NOT NULL
),

-- Step 2: Aggregates customer-level metrics
customer_aggregation AS (
    SELECT
        customer_key,
        customer_number,
        full_name,
        age,
        COUNT(DISTINCT order_number) AS total_orders,
        SUM(sales_amount) AS total_sales,
        SUM(quantity) AS total_quantity,
        COUNT(DISTINCT product_key) AS total_products,
        MAX(order_date) AS last_order_date,
        DATEDIFF(MONTH, MIN(order_date), MAX(DATETRUNC(MONTH, order_date))) AS lifespan
    FROM base_query
    GROUP BY customer_key, customer_number, full_name, age
)

-- Step 3: Segments customers and calculates additional metrics
SELECT
    customer_key,
    customer_number,
    full_name,
    age,
    total_orders,
    total_sales,
    total_quantity,
    total_products,
    last_order_date,
    lifespan,

    -- Customer segmentation based on lifespan and total sales
    CASE
        WHEN lifespan >= 12 AND total_sales > 5000 THEN 'VIP'
        WHEN lifespan >= 12 AND total_sales <= 5000 THEN 'Regular'
        ELSE 'New'
    END AS customer_segment,

    -- Age group classification
    CASE
        WHEN age < 20 THEN 'Under 20'
        WHEN age BETWEEN 20 AND 29 THEN '20-29'
        WHEN age BETWEEN 30 AND 39 THEN '30-39'
        WHEN age BETWEEN 40 AND 49 THEN '40-49'
        WHEN age BETWEEN 50 AND 59 THEN '50-59'
        ELSE '60+'
    END AS age_group,

    DATEDIFF(MONTH, last_order_date, (SELECT MAX(order_date) FROM base_query)) AS recency_in_months, -- Recency of last order
    CASE WHEN total_orders = 0 THEN 0 ELSE total_sales / total_orders END AS avg_order_value, -- Average order value
    CASE WHEN lifespan = 0 THEN 0 ELSE total_sales / lifespan END AS avg_monthly_spend -- Average monthly spend
FROM customer_aggregation;

-- Step 4: Retrieve the final report
SELECT * FROM customer_report;
