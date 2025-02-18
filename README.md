# Walmart Sales Data Analysis 
## About
This project aims to explore the Walmart Sales data to understand top performing branches and products, sales trend of of different products, customer behaviour. The aims is to study how sales strategies can be improved and optimized. The dataset was obtained from the Kaggle Walmart Sales Forecasting Competition.

"In this recruiting competition, job-seekers are provided with historical sales data for 45 Walmart stores located in different regions. Each store contains many departments, and participants must project the sales for each department in each store. To add to the challenge, selected holiday markdown events are included in the dataset. These markdowns are known to affect sales, but it is challenging to predict which departments are affected and the extent of the impact." [source](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting)

# Purposes Of The Project
The major aim of thie project is to gain insight into the sales data of Walmart to understand the different factors that affect sales of the different branches.

# About Data
The dataset was obtained from the Kaggle Walmart Sales Forecasting Competition. This dataset contains sales transactions from a three different branches of Walmart, respectively located in Mandalay, Yangon and Naypyitaw. The data contains 17 columns and 1000 rows:

| Column                 | Description                                  | Data Type        |
|------------------------|----------------------------------------------|------------------|
| `invoice_id`           | Invoice of the sales made                    | `VARCHAR(30)`    |
| `branch`               | Branch at which sales were made              | `VARCHAR(5)`     |
| `city`                 | The location of the branch                   | `VARCHAR(30)`    |
| `customer_type`        | The type of the customer                     | `VARCHAR(30)`    |
| `gender`               | Gender of the customer making purchase       | `VARCHAR(10)`    |
| `product_line`         | Product line of the product sold             | `VARCHAR(100)`   |
| `unit_price`           | The price of each product                    | `DECIMAL(10, 2)` |
| `quantity`             | The amount of the product sold               | `INT`            |
| `VAT`                  | The amount of tax on the purchase            | `FLOAT(6, 4)`    |
| `total`                | The total cost of the purchase               | `DECIMAL(10, 2)` |
| `date`                 | The date on which the purchase was made      | `DATE`           |
| `time`                 | The time at which the purchase was made      | `TIMESTAMP`      |
| `payment_method`       | The total amount paid                        | `DECIMAL(10, 2)` |
| `cogs`                 | Cost of Goods sold                           | `DECIMAL(10, 2)` |
| `gross_margin_percentage` | Gross margin percentage                   | `FLOAT(11, 9)`   |
| `gross_income`         | Gross Income                                 | `DECIMAL(10, 2)` |
| `rating`               | Rating                                       | `FLOAT(2, 1)`    |


## Analysis List

1. **Product Analysis**

   Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.

2. **Sales Analysis**

   This analysis aims to answer the question of the sales trends of products. The result of this can help use measure the effectiveness of each sales strategy the business applies and what modifications are needed to gain more sales.

3. **Customer Analysis**

   This analysis aims to uncover the different customer segments, purchase trends, and the profitability of each customer segment.

---

## Approach Used

1. **Data Wrangling**: 
   
   This is the first step where inspection of data is done to make sure `NULL` values and missing values are detected and data replacement methods are used to replace, missing or `NULL` values.

   1. Build a database.
   2. Create tables and insert the data.
   3. Select columns with `NULL` values in them. There are no `NULL` values in our database as in creating the tables, we set `NOT NULL` for each field, hence `NULL` values are filtered out.

2. **Feature Engineering**:
   
   This will help generate some new columns from existing ones.

   1. Add a new column named `time_of_day` to give insight into sales in the Morning, Afternoon, and Evening. This will help answer the question of which part of the day most sales are made.
   2. Add a new column named `day_name` that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.
   3. Add a new column named `month_name` that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.

3. **Exploratory Data Analysis (EDA)**:
   
   Exploratory data analysis is done to answer the listed questions and aims of this project.
## Business Questions to Answer

### Generic Questions
1. How many unique cities does the data have?
2. In which city is each branch located?

### Product Analysis
1. How many unique product lines does the data have?
2. What is the most common payment method?
3. What is the most selling product line?
4. What is the total revenue by month?
5. What month had the largest COGS?
6. What product line had the largest revenue?
7. What is the city with the largest revenue?
8. What product line had the largest VAT?
9. Fetch each product line and add a column to those product lines showing "Good" or "Bad" based on sales:
    - **Good** if it's greater than average sales.
    - **Bad** if it's below average sales.
10. Which branch sold more products than the average product sold?
11. What is the most common product line by gender?
12. What is the average rating of each product line?

### Sales Analysis
1. Number of sales made in each time of the day per weekday.
2. Which customer type brings the most revenue?
3. Which city has the largest tax percent / VAT (Value Added Tax)?
4. Which customer type pays the most in VAT?

### Customer Analysis
1. How many unique customer types does the data have?
2. How many unique payment methods does the data have?
3. What is the most common customer type?
4. Which customer type buys the most?
5. What is the gender of most of the customers?
6. What is the gender distribution per branch?
7. Which time of the day do customers give the most ratings?
8. Which time of the day do customers give the most ratings per branch?
9. Which day of the week has the best average ratings?
10. Which day of the week has the best average ratings per branch?

    ## Power BI Dashboards

### 1. Sales Overview Dashboard

This dashboard provides a comprehensive view of the sales performance, including total revenue, top-selling products, and sales trends over time.

![Sales Overview Dashboard](images/sales_overview.png)

### 2. Customer Insights Dashboard

This dashboard presents insights into customer demographics, purchase behavior, and customer segmentation by city and product lines.

![Customer Insights Dashboard](images/Customer_overview.png)

### 3.General Overview Performance 

This dashboard highlights the performance of various product lines, identifying the top revenue-generating products, profit margins, and the impact of discounts on sales.

![Product Line Performance Dashboard](images/Overview.png)

## Code

For the rest of the code, check the [Walmart Project.sql](WalmartProject.sql) file.

```sql
-- Create database if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.databases WHERE name = 'walmartSales')
BEGIN
    CREATE DATABASE walmartSales;
END
GO

-- Use the walmartSales database
USE walmartSales;
GO

-- Create table if it doesn't exist
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'sales')
BEGIN
    CREATE TABLE sales (
        invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
        branch VARCHAR(5) NOT NULL,
        city VARCHAR(30) NOT NULL,
        customer_type VARCHAR(30) NOT NULL,
        gender VARCHAR(10) NOT NULL,
        product_line VARCHAR(100) NOT NULL,
        unit_price DECIMAL(10, 2) NOT NULL,
        quantity INT NOT NULL,
        tax_pct FLOAT NOT NULL, -- SQL Server FLOAT does not support precision like FLOAT(6,4)
        total DECIMAL(12, 4) NOT NULL,
        date DATETIME NOT NULL,
        time TIME NOT NULL,
        payment VARCHAR(15) NOT NULL,
        cogs DECIMAL(10, 2) NOT NULL,
        gross_margin_pct FLOAT, -- Removing precision as FLOAT doesn't have a precision format
        gross_income DECIMAL(12, 4),
        rating FLOAT
    );
END
GO




