# 📊 Customer and Product Insights

This repository contains two separate data analysis reports based on the same dataset. The analysis focuses on understanding **customer behaviors** and **product performance** within the context of sales data.

## 📑 Table of Contents

- [👥 Customer Report](./CUSTOMERS%20REPORT/)
- [📦 Product Report](./PRODUCTS%20REPORT/)

# 👥 Customer Report

## 1. 📝 Summary

- This SQL script analyzes customer behavior based on sales data by aggregating key metrics and segmenting customers into meaningful categories.
- The script extracts customer details and sales data, calculates essential metrics like total orders, total sales, and average order value, and classifies customers into segments such as "VIP," "Regular," and "New."
- The report also includes a classification by age group, recency of the last order, and average monthly spend based on customer lifespan.

## 2. 🔑 Key Insights

- **Customer Segmentation**: Customers are categorized into three groups based on their total sales and lifespan:
  - **VIP**: Customers with a lifespan of 12+ months and sales greater than 5000.
  - **Regular**: Customers with a lifespan of 12+ months and sales less than or equal to 5000.
  - **New**: Customers with a lifespan of less than 12 months.
  
- **Age Group Classification**: Customers are classified into age groups: Under 20, 20-29, 30-39, 40-49, 50-59, and 60+.
  
- **Recency of Last Order**: The recency of the customer's last order is measured in months from the most recent sales data.
  
- **Key Metrics**:
  - **Average Order Value**: The average sales amount per order for each customer.
  - **Average Monthly Spend**: The average spend per month over the customer's lifespan.

## 3. 🎯 Usage

- **Objective**: The report helps to understand customer behaviors, including how frequently they buy, their overall spend, and how recently they interacted with the brand.
  
- **Marketing & Retention**: 
  - **VIP customers** can be targeted for loyalty programs or high-value promotions.
  - **Regular customers** might be engaged with campaigns to increase their order frequency or total spend.
  - **New customers** can be nurtured with introductory offers or personalized recommendations to drive future purchases.
  
- **Customer Insights**: The age group classification can help in targeted marketing campaigns tailored to different demographics. For example, specific product offerings or promotions can be designed for certain age groups or based on recency of purchase.

Please see the [Customer Insights](./CUSTOMERS%20REPORT/Customer%20Insights.sql) for SQL queries used in this analysis.

# 📦 Product Report

1. 📝 Summary
This SQL script generates a detailed product performance report by analyzing key metrics such as total sales, quantity, profit margin, and pricing segmentation. The script first aggregates data, then segments products into various categories. The final output is a comprehensive report with metrics on product sales performance, customer interaction, and segmentation.

Key Operations:
Aggregation: The script uses various aggregation functions to calculate total sales, total quantity, average sales, and profitability metrics.
Segmentation: Products are classified into categories such as price, profitability, sales performance, and age, which help to identify trends and make strategic decisions.
Advanced Functions: The report makes use of advanced SQL features like **window functions, Common Table Expressions (CTE), procedures, and aggregate functions** to deliver a dynamic and detailed analysis of product data.

## 2. 🔑 Key Insights

- **Product Segmentation**:
  - **Price Category**: Products are classified into three categories:
    - **High-Priced**: Products with a price above 75% of the average price.
    - **Medium Average**: Products priced between 25% and 50% of the average price.
    - **Low-Priced**: Products priced below 25% of the average price.
  
  - **Profitability Tier**: Products are segmented based on profit margins:
    - **High Margin**: Profit margin greater than 40%.
    - **Medium Margin**: Profit margin between 20% and 40%.
    - **Low Margin**: Profit margin below 20%.
  
  - **Sales Category**: Products are categorized into sales performance tiers based on total sales:
    - **Top Selling Products**: Products in the top 25% of total sales.
    - **Mid-Tier Products**: Products in the middle 50% of total sales.
    - **Struggling Products**: Products in the bottom 25% of total sales.
  
  - **Product Age**: Products are segmented into age groups based on the number of months between their first and last sale:
    - **0-6 months**: Products sold within the last 6 months.
    - **6-12 months**: Products sold between 6 and 12 months.
    - **12+ months**: Products sold for over a year.

- **Key Metrics**:
  - **Total Sales**: The total sales amount for each product.
  - **Profit Margin**: The profit margin, calculated as `(Total Sales - Total Cost) / Total Sales`.
  - **Market Share**: The proportion of customers purchasing the product compared to the total customer base.
  - **Average Monthly Sales & Volume**: Calculated based on the product's lifespan.

## 3. 🎯 Usage

- **Objective**: This report is designed to help businesses assess their product performance, identify high-performing products, and understand pricing and profitability trends.
  
- **Decision-Making**:
  - **Pricing Strategy**: The **price category** segmentation helps to understand which products are priced higher or lower compared to the market, providing insights for adjusting pricing strategies.
  - **Product Focus**: **Top Selling Products** can be prioritized for marketing, production, and inventory management. Similarly, **Struggling Products** may need promotional efforts or discontinuation based on sales performance.
  - **Profitability**: The **profitability tier** helps identify products with higher margins, allowing businesses to focus on more profitable items or improve those with lower margins.
  
- **Marketing & Promotion**:
  - **High Margin Products**: These can be marketed as premium offerings to attract customers willing to pay a premium price.
  - **Mid-Tier Products**: Can be promoted with discounts or bundled offers to boost sales.
  - **Struggling Products**: Can be targeted with special campaigns to boost their sales or liquidate excess stock.

- **Customer Insights**: The **market share** metric shows how well a product is penetrating the customer base and can be used to refine targeting strategies.

Please see the [Product Insights](./PRODUCTS%20REPORT/Product%20Insights.sql) for SQL queries used in this analysis.
