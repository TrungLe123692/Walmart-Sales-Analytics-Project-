# Walmart Sales Data Analytics Project 

## Business Objective  
The goal of this project is to analyze Walmart’s sales data to uncover actionable insights that support strategic decision-making across branches. This includes identifying top and underperforming product lines, uncovering sales trends by time of day, day of week, and month, and understanding customer behavior across different segments. The analysis also compares branch-level performance to highlight regional strengths and inefficiencies, while evaluating key profitability metrics such as gross revenue, VAT, and profit margins. These insights can inform decisions related to inventory management, marketing strategy, staffing, and overall operational efficiency. 

## About the Data 
The dataset was abotained from the [Kaggle Walmart Sales Forecasting Competition](https://www.kaggle.com/c/walmart-recruiting-store-sales-forecasting). This dataset contains sales transactions from a three different branches of Walmart, respectively located in Mandalay, Yangon and Naypyitaw. The data contains 17 columns and 1000 rows:

![datadescription](https://github.com/user-attachments/assets/66e89849-2afe-48df-b88c-045c4815bdf1)


## Analysis List 

`1. Product Analysis:` Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.


`2. Sales Analysis:` This analysis aims to answer the question of the sales trends of product. The result of this can help use measure the effectiveness of each sales strategy the business applies and what modificatoins are needed to gain more sales.


`3. Customer Analyis:` This analysis aims to uncover the different customers segments, purchase trends and the profitability of each customer segment.

## Approach Used 
`1. Data Wrangling:` This is the first step where inspection of data is done to make sure NULL values and missing values are detected and data replacement methods are used to replace, missing or NULL values.
a. Build a database

b. Create table and insert data

c. Select columns with null values in them. There are no null values in our database as in creating the tables, we set NOT NULL for each field, hence null values are filtered out.

`2. Feature Engineering:` This will help use generate some new columns from existing ones.
a. Add a new column named time_of_day to give insight of sales in the Morning, Afternoon and Evening. This will help answer the question on which part of the day most sales are made.

b. Add a new column named day_name that contains the extracted days of the week on which the given transaction took place (Mon, Tue, Wed, Thur, Fri). This will help answer the question on which week of the day each branch is busiest.

c. Add a new column named month_name that contains the extracted months of the year on which the given transaction took place (Jan, Feb, Mar). Help determine which month of the year has the most sales and profit.

`Exploratory Data Analysis (EDA):` This is done to answer the listed questions and aims of this project 

`4. Conclusion`

## Business Questions to Answer 
`Generic Questions`
1. How many unique cities does the data have?

2. In which city is each brand?

`Questions about the Products`
1. How many unique product lines does the data have?

2. What is the most common payment method?

3. What is the most selling product line?

4. What is the total revenue by month?

5. What month had the largest COGS?

6. What product line had the largest revenue?

7. What is the city with largest revenue?

8. What product line had the largest VAT?

9. Which brand sold more products than average product sold?

10. What is the most common product line by gender?

11. What is the average rating of each product line?

`Questions about the Sales`
1. Number of sales made in each time of the day per weekday?

2. Which of the customer types brings the most revenue

3. Which cty has the largest tax percent?

4. Which customer type pays the most in VAT?

`Questions about the Customers`
1. How many unique customer types does the data have?

2. How many unique payement methods does the data have?

3. What is the most common customer type?

4. Which csutomer type buys the most?

5. What is the gender of most of the customers?

6. What is the gender distribution per branch?

7. Which time of day do customers give most ratings?

8. Which day of the week has the best average ratings?

9. Which day of the week has the best average ratings per week?

## Revenue and Profit Calculations                                     
1. Cogs = Unit Price * QUantity

2. VAT = 5% * COGS (VAT is added to the COGS and this is what is billed to the customer

3. Total(Gross_sales) = VAT + COGS

4. Gross Profit (Gross_income) = total(gross_sales) - COGS (Gross Margin is gross profit expressed in percentage of the total(gross prodit/revenue)

## Key Insights 
1. Yangoon branch generates the highest revenue and tax

2. Food and Beverages is the top-performing product line

3. Member customers contribute the most to total sales

4. Evenings and Saturdays are peak sales periods

5. March records the highest monthly revenue

## Code 
For SQL queries, check the [Walmart Sales Analytic SQL-queries](https://github.com/TrungLe123692/Walmart-Sales-Analytics-Project-/blob/main/Walmart%20Sales%20Analytic%20Project%20SQL%20Script.sql) file








