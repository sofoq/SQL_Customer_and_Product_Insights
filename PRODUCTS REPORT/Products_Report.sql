-- This code performs a detailed analysis of product sales performance and categorizes products based on several metrics. 
-- It uses a series of Common Table Expressions (CTEs) to build up a base query with aggregated data, followed by product segmentation 
-- based on performance criteria such as price, profitability, sales volume, and product age. 
-- The final output is a comprehensive product report that includes key metrics such as total sales, total quantity, profit margins, 
-- average sales per customer, and market share. 
-- The report also includes segmentation for price category, profitability tier, sales category, and product age.
-- 
-- The first part of the code creates a view (Products_Report) that consolidates product, sales, and customer data 
-- for performance analysis and segmentation. The view contains aggregated data such as total sales, total cost, 
-- and profitability metrics.
-- 
-- The second part of the code defines a stored procedure (Get_Products_Report_By_Category) that generates a report 
-- filtered by product category. If no category is provided, all products are included.
-- The stored procedure uses the Products_Report view and allows for flexible querying based on category.
-- 
-- Example usage:
-- EXEC Get_Products_Report_By_Category @Category = NULL; -- Retrieves the full report for all products.
-- EXEC Get_Products_Report_By_Category @Category = 'Bikes'; -- Retrieves the report for products in the 'Bikes' category.



drop view if exists Products_Report --drop view if exists products_report
create view Products_Report as --create view products_report 
-- CTE: Base_query 
-- This part joins the product, sales, and customer tables to create the foundation for the report.
WITH Base_query AS (
    SELECT
        p.product_key,
        p.product_name,
        p.category,
        p.subcategory,
        p.cost,
        p.start_date,
        s.customer_key,
        s.order_date,
        s.sales_amount,
        s.quantity,
        s.price,
        c.customer_id
    FROM gold.dim_products p
    LEFT JOIN gold.fact_sales s  
        ON p.product_key = s.product_key
    LEFT JOIN gold.dim_customers c
        ON s.customer_key = c.customer_key
    WHERE s.sales_amount > 0 
),

-- CTE: aggregations
-- This part calculates various metrics and aggregations for products, such as total sales, total quantity,
-- average price, profit margin, and more. These are used to perform product analysis.
aggregations AS (
    SELECT
        product_name,
        category,
        subcategory,
        SUM(sales_amount) AS total_sales, 
        SUM(quantity) AS total_quantity, 
        COUNT(DISTINCT customer_key) AS total_customers, 
        COUNT(DISTINCT order_date) AS total_orders, 
        MAX(order_date) AS last_sale_date, 
        MIN(order_date) AS first_sale_date, 

        -- Average quantity per order
        SUM(quantity) / COUNT(DISTINCT order_date) AS avg_quantity_per_order, 

        -- Average sales per customer
        SUM(sales_amount) / COUNT(DISTINCT customer_key) AS avg_sales_per_customer, 

        -- Average price calculation
        SUM(sales_amount) / SUM(quantity) as avg_price, 

        SUM(cost * quantity) AS total_cost, 
        SUM(sales_amount) - SUM(cost * quantity) AS total_profit, 

        -- Profit margin calculation
        ROUND(
            (SUM(sales_amount) - SUM(cost * quantity)) / cast(SUM(sales_amount) as float), 2) AS profit_margin,

        -- Average monthly volume
        SUM(quantity) / DATEDIFF(month, MIN(order_date), MAX(order_date)) AS avg_monthly_Volume,

        -- Average monthly sales
        SUM(sales_amount) / DATEDIFF(month, MIN(order_date), MAX(order_date)) AS avg_monthly_sales,

        -- Market share calculation (based on the number of unique customers for the product)
        ROUND(
            COUNT(DISTINCT customer_id) / CAST((SELECT COUNT(DISTINCT customer_id) FROM [gold].[dim_customers]) AS FLOAT),
            2
        ) AS market_share
    FROM Base_query 
    GROUP BY product_name, category, subcategory
),

-- CTE: segmentation
-- This part segments products based on their performance, including price category, profitability tier, 
-- sales category, and product age.
segmentation AS (
    SELECT *,
        -- Price category segmentation
        CASE 
            WHEN avg_price >= 0.75 * MAX(avg_price) OVER() THEN 'High-Priced' 
            WHEN avg_price >= 0.25 * MAX(avg_price) OVER() AND avg_price < 0.5 * MAX(avg_price) OVER() THEN 'Medium Average' 
            WHEN avg_price < 0.25 * MAX(avg_price) OVER() THEN 'Low-Priced' 
        END AS price_category,

        -- Profitability tier segmentation
        CASE 
            WHEN profit_margin > 0.4 THEN 'High Margin' 
            WHEN profit_margin BETWEEN 0.2 AND 0.4 THEN 'Medium Margin'
            ELSE 'Low Margin' 
        END AS profitability_tier,

        -- Sales category segmentation
        CASE 
            WHEN total_sales >= PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_sales) OVER() THEN 'Top Selling Products' 
            WHEN total_sales >= PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_sales) OVER() 
                 AND total_sales < PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY total_sales) OVER() 
            THEN 'Mid-Tier Products' 
            WHEN total_sales < PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY total_sales) OVER() THEN 'Struggling Products' 
        END AS sales_category,

        -- Product age segmentation (based on the difference between first and last sale dates)
        CASE 
            WHEN DATEDIFF(month, first_sale_date, last_sale_date) BETWEEN 0 AND 6 THEN '0-6 months' 
            WHEN DATEDIFF(month, first_sale_date, last_sale_date) BETWEEN 6 AND 12 THEN '6-12 months'
            WHEN DATEDIFF(month, first_sale_date, last_sale_date) > 12 THEN '12+ months' 
        END AS product_age
    FROM aggregations
)

-- SELECT statement that retrieves all relevant product information from the segmentation CTE
SELECT 
    product_name,
    category,
    subcategory,
    total_sales,
    total_cost,
    total_profit,
    total_quantity,
    total_customers,
    total_orders,
    avg_quantity_per_order,
    avg_sales_per_customer,
    avg_price,
    avg_monthly_Volume,
    avg_monthly_sales,
    profit_margin,
    market_share,
    price_category, 
    profitability_tier, 
    sales_category, 
    product_age 
FROM segmentation;





--This code creates a stored procedure named Get_Products_Report_By_Category. 
--The procedure takes one input parameter, @Category, and retrieves 
--a report of product data from a pre-existing view called Products_Report

CREATE PROCEDURE Get_Products_Report_By_Category
    @Category NVARCHAR(255) 
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        product_name,
        category,
        subcategory,
        total_sales,
        total_cost,
        total_profit,
        total_quantity,
        total_customers,
        total_orders,
        avg_quantity_per_order,
        avg_sales_per_customer,
        avg_price,
        avg_monthly_Volume,
        avg_monthly_sales,
        profit_margin,
        market_share,
        price_category, 
        profitability_tier, 
        sales_category, 
        product_age 
    FROM [DataWarehouseAnalytics].gold.[Products_Report]
    WHERE @Category IS NULL OR category = @Category;
END;

EXEC Get_Products_Report_By_Category @Category = NULL;

EXEC Get_Products_Report_By_Category @Category = 'Bikes';