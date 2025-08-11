# 🛒 Walmart Sales Data Analytics
![Language](https://img.shields.io/badge/Language-SQL-blue)
![Visualization](https://img.shields.io/badge/Visualization-Tableau-purple)
![Status](https://img.shields.io/badge/Project-Completed-brightgreen)
![Data](https://img.shields.io/badge/Data-Walmart-orange)

---

## 1. Business Objective
* Analyze sales to find **top vs underperforming product lines**.
* Uncover **trends by hour, weekday, and month** to guide staffing and promos.
* Understand **customer behavior** by type, payment, and gender.
* Compare **branch performance** to reveal regional strengths and gaps.
* Evaluate **profitability** with revenue, VAT, gross margin, and gross income.

---

## 📂 Resources

- SQL Script: [Walmart Sales Analytics SQL Script](https://github.com/TrungLe123692/Walmart-Sales-Analytics-Project-/blob/main/Walmart%20Sales%20Analytic%20Project%20SQL%20Script.sql) 
- Dataset Source: [Walmart Sales Dataset](https://github.com/TrungLe123692/Walmart-Sales-Analytics-Project-/blob/main/Walmart%20Sales%20Data.csv)
- ETL Process: [Project ETL Structure](https://github.com/TrungLe123692/Walmart-Sales-Analytics-Project-/blob/main/ETL%20Process) 

---

## 2. About the Data

* Source, **Kaggle: Walmart Sales Forecasting**.
* Scope, three branches in **Mandalay, Yangon, Naypyitaw**.
* Shape, **1,000 rows**, **17 columns** of transaction-level data.

### 2.1 Column Dictionary
| Column | Description | Data Type |
|---|---|---|
| `invoice_id` | Invoice of the sales | VARCHAR(30) |
| `branch` | Branch where sale occurred | VARCHAR(5) |
| `city` | Branch city | VARCHAR(30) |
| `customer_type` | Member or Normal | VARCHAR(30) |
| `gender` | Customer gender | VARCHAR(10) |
| `product_line` | Product line | VARCHAR(100) |
| `unit_price` | Price per unit | DECIMAL(10,2) |
| `quantity` | Quantity purchased | INT |
| `tax_pct` | VAT percent on purchase | FLOAT(6,4) |
| `total` | Line total (COGS + VAT) | DECIMAL(12,4) |
| `date` | Purchase date | DATETIME |
| `time` | Purchase time | TIMESTAMP |
| `payment` | Payment method | VARCHAR(15) |
| `cogs` | Cost of goods sold | DECIMAL(10,2) |
| `gross_margin_pct` | Gross margin percentage | FLOAT(11,9) |
| `gross_income` | Gross income | DECIMAL(12,4) |
| `rating` | Customer rating | FLOAT(2,1) |

[Project Structure](https://github.com/TrungLe123692/Walmart-Sales-Analytics-Project-/blob/main/Project%20Structure)

```
pizza-sales-analysis/
│
├── data/
│   └── Pizza_Data.xlsx
│
├── sql/
│   └── pizza_sales_analysis_queries.sql
│
├── visuals/
│   ├── sales_by_category.png
│   ├── sales_by_size.png
│   ├── daily_order_trend.png
│   ├── hourly_order_trend.png
│   ├── top_5_best_sellers.png
│   ├── bottom_5_best_sellers.png
│   └── monthly_category_sales.png
│
├── dashboard/
│   └── NYC_Andiamo_Pizza_Sales_Dashboard.xlsx
│
├── output/
│   └── Pizza_Sales_Analysis_Report.pdf
│
├── README.md
├── LICENSE
└── .gitignore
```

---

## 3. ETL Structure

> ✅ This project’s ETL process extracted Walmart sales data from Kaggle, cleaned and transformed it with feature engineering and metric calculations in MySQL, then loaded it into a production table for analysis and dashboarding.

### 3.1 Extract
* **Source**
  ▪ Kaggle Walmart Sales CSV, three branches: Mandalay, Yangon, Naypyitaw  
  ▪ Single flat file with 1,000 rows and 17 columns
* **Ingestion**
  ▪ Manual download or scripted pull  
  ▪ Staged to `/data/walmart_sales.csv`
* **Landing → Staging**
  ▪ Load into MySQL staging schema for validation
* **Data Validation (Extract)**
  ▪ File integrity check (row count, column count)  
  ▪ Schema conformity check (headers, types)  

```sql
-- Create database and staging table
CREATE DATABASE IF NOT EXISTS walmartSales;

CREATE TABLE IF NOT EXISTS staging_sales (
  invoice_id VARCHAR(30),
  branch VARCHAR(5),
  city VARCHAR(30),
  customer_type VARCHAR(30),
  gender VARCHAR(30),
  product_line VARCHAR(100),
  unit_price DECIMAL(10,2),
  quantity INT,
  tax_pct FLOAT(6,4),
  total DECIMAL(12,4),
  date DATETIME,
  time TIME,
  payment VARCHAR(15),
  cogs DECIMAL(10,2),
  gross_margin_pct FLOAT(11,9),
  gross_income DECIMAL(12,4),
  rating FLOAT(2,1)
);
```

---

### 3.2 Transform
* **Cleaning**
  ▪ Trim, uppercase or title-case categorical fields (`branch`, `city`, `product_line`, `payment`)  
  ▪ Enforce NOT NULL business-critical columns (invoice, date, product, price, quantity)  
  ▪ Remove exact duplicates on `invoice_id, product_line, unit_price, quantity`
* **Type Casting**
  ▪ Cast numerics: `unit_price`, `quantity`, `tax_pct`, `total`, `cogs`, `gross_income`  
  ▪ Ensure `date` as `DATETIME`, `time` as `TIME`
* **Feature Engineering**
  ▪ `time_of_day` = Morning, Afternoon, Evening  
  ▪ `day_name` = DAYNAME(`date`)  
  ▪ `month_name` = MONTHNAME(`date`)
* **Business Metrics (row-level)**
  ▪ `cogs` = `unit_price` × `quantity`  
  ▪ `vat_amount` = 0.05 × `cogs`  
  ▪ `gross_sales` = `cogs` + `vat_amount`  
  ▪ `gross_income` = `gross_sales` − `cogs`  
  ▪ `gross_margin_pct` = `gross_income` / `gross_sales`
* **Data Validation (Transform)**
  ▪ Non-negative checks on `unit_price`, `quantity`, `cogs`, `total`  
  ▪ Referential checks on controlled vocabularies (branch A, B, C; known product lines; payment methods)

```sql
-- Create production table with constraints
CREATE TABLE IF NOT EXISTS sales (
  invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
  branch VARCHAR(5) NOT NULL,
  city VARCHAR(30) NOT NULL,
  customer_type VARCHAR(30) NOT NULL,
  gender VARCHAR(30) NOT NULL,
  product_line VARCHAR(100) NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL,
  tax_pct FLOAT(6,4) NOT NULL,
  total DECIMAL(12,4) NOT NULL,
  date DATETIME NOT NULL,
  time TIME NOT NULL,
  payment VARCHAR(15) NOT NULL,
  cogs DECIMAL(10,2) NOT NULL,
  gross_margin_pct FLOAT(11,9),
  gross_income DECIMAL(12,4),
  rating FLOAT(2,1)
);

-- Load from staging into production with cleaned values
INSERT INTO sales
SELECT
  TRIM(invoice_id),
  UPPER(TRIM(branch)),
  INITCAP(TRIM(city)),
  INITCAP(TRIM(customer_type)),
  INITCAP(TRIM(gender)),
  INITCAP(TRIM(product_line)),
  CAST(unit_price AS DECIMAL(10,2)),
  CAST(quantity AS SIGNED),
  CAST(tax_pct AS FLOAT),
  CAST(total AS DECIMAL(12,4)),
  date,
  time,
  INITCAP(TRIM(payment)),
  -- recompute COGS to ensure accuracy
  CAST(unit_price * quantity AS DECIMAL(10,2)) AS cogs,
  NULL AS gross_margin_pct,
  NULL AS gross_income,
  rating
FROM staging_sales
WHERE invoice_id IS NOT NULL;

-- Feature engineering
ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);
UPDATE sales
SET time_of_day = CASE
  WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
  WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
  ELSE 'Evening'
END;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);
UPDATE sales SET day_name = DAYNAME(date);

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);
UPDATE sales SET month_name = MONTHNAME(date);

-- Row-level business metrics
ALTER TABLE sales ADD COLUMN vat_amount DECIMAL(12,4);
ALTER TABLE sales ADD COLUMN gross_sales DECIMAL(12,4);

UPDATE sales
SET
  vat_amount = ROUND(0.05 * cogs, 4),
  gross_sales = ROUND(cogs + (0.05 * cogs), 4),
  gross_income = ROUND((cogs + (0.05 * cogs)) - cogs, 4),
  gross_margin_pct = CASE
    WHEN (cogs + (0.05 * cogs)) > 0
    THEN ((cogs + (0.05 * cogs)) - cogs) / (cogs + (0.05 * cogs))
    ELSE NULL
  END;
```

---

### 3.3 Load
* **Target**
  ▪ Production schema `sales` table as the single source of truth  
  ▪ Indexed for analytics
* **Indexing for Performance**
  ▪ Index on `date`, `day_name`, `month_name`  
  ▪ Index on `branch`, `city`, `product_line`, `payment`  
  ▪ Composite index examples for common filters

```sql
-- Helpful indexes
CREATE INDEX idx_sales_date ON sales(date);
CREATE INDEX idx_sales_day ON sales(day_name);
CREATE INDEX idx_sales_month ON sales(month_name);
CREATE INDEX idx_sales_branch ON sales(branch);
CREATE INDEX idx_sales_city ON sales(city);
CREATE INDEX idx_sales_product_line ON sales(product_line);
CREATE INDEX idx_sales_payment ON sales(payment);

-- Optional composite
CREATE INDEX idx_sales_branch_month ON sales(branch, month_name);
```

---

### 3.4 Orchestration & Outputs
* **Orchestration**
  ▪ Manual run or scheduled via cron or Airflow style task  
  ▪ Order, Extract → Transform → Load → Quality checks → Publish
* **Outputs**
  ▪ Clean SQL table `sales` for queries  
  ▪ Tableau workbook for KPI and trend dashboards  
  ▪ Reusable SQL scripts in `/sql/walmart_sales_queries.sql`
* **Quality Gates**
  ▪ Row counts match between staging and production  
  ▪ Aggregates sanity checks, `SUM(total)` close to `SUM(gross_sales)`  
  ▪ Spot checks on engineered fields (`time_of_day`, `day_name`, `month_name`)


---

## 4. 📊 Analysis List

> ✅ The analysis covered products, sales, and customers: ranking product lines by performance and preferences, tracking revenue trends and peak sales times, and profiling customer segments, payment habits, and satisfaction patterns.

### 4.1 Product Analysis
* Count **unique product lines** and rank by **revenue**, **quantity**, **VAT**.
* Identify **gender preferences** by product line.
* Compute **average rating** per product line.

### 4.2 Sales Analysis
* Track **monthly revenue** and **COGS** to spot peaks.
* Compare **branch revenue** and city tax characteristics.
* Find **busy times** by hour and weekday for staffing.

### 4.3 Customer Analysis
* Profile **customer types** and **payment methods**.
* Determine **who buys most** and **who pays most VAT**.
* Assess **ratings** by **time of day** and **weekday**, including per-branch cuts.

---

## 5. SQL Script 

> ✅ The SQL script builds a clean sales table, engineers time-based and categorical features, and answers business questions on products, customers, and sales trends using aggregations, filtering, and grouping.

- **5.1 Setup, Schema, and Initial Checks**
   - Created `walmartSales` database.  
   - Defined `sales` table with strict types, `NOT NULL` constraints, and `PRIMARY KEY` on `invoice_id`.  
   - Added columns for product, customer, financial, and time data.  
```sql
-- Create database
CREATE DATABASE IF NOT EXISTS walmartSales;

-- Create table
CREATE TABLE IF NOT EXISTS sales (
  invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
  branch VARCHAR(5) NOT NULL,
  city VARCHAR(30) NOT NULL,
  customer_type VARCHAR(30) NOT NULL,
  gender VARCHAR(30) NOT NULL,
  product_line VARCHAR(100) NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  quantity INT NOT NULL,
  tax_pct FLOAT(6,4) NOT NULL,
  total DECIMAL(12, 4) NOT NULL,
  date DATETIME NOT NULL,
  time_of_day TIME NOT NULL,
  payment VARCHAR(15) NOT NULL,
  cogs DECIMAL(10,2) NOT NULL,
  gross_margin_pct FLOAT(11,9),
  gross_income DECIMAL(12, 4),
  rating FLOAT(2, 1)
);

-- Data cleaning check
SELECT * FROM salesdatawalmart.sales;
```

- **5.2 Feature Engineering, Time Dimensions**
   - Categorized purchase `time` into Morning, Afternoon, or Evening using `CASE`.  
   - Added `time_of_day` column to store these categories.  
   - Extracted day of week with `DAYNAME()` into new `day_name` column.  
   - Extracted month name with `MONTHNAME()` into new `month_name` column.  
```sql
-- Categorize purchase time into Morning/Afternoon/Evening
SELECT
  time,
  (CASE
     WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
     WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
     ELSE "Evening"
   END) AS time_of_day
FROM salesdatawalmart.sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

-- Note, this updates `time` with labels; typically you'd update `time_of_day`
UPDATE salesdatawalmart.sales
SET time = (
  CASE
    WHEN `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
    WHEN `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
    ELSE "Evening"
  END
);

-- Day of week
SELECT date, DAYNAME(date) FROM salesdatawalmart.sales;
ALTER TABLE salesdatawalmart.sales ADD COLUMN day_name VARCHAR(10);
UPDATE salesdatawalmart.sales SET day_name = DAYNAME(date);

-- Month name
SELECT date, MONTHNAME(date) FROM salesdatawalmart.sales;
ALTER TABLE salesdatawalmart.sales ADD COLUMN month_name VARCHAR(10);
UPDATE salesdatawalmart.sales SET month_name = MONTHNAME(date);
```

- **5.3 Generic Profile Questions**
   - Retrieved unique list of cities from the dataset.  
   - Retrieved unique city–branch combinations to map branch locations.  
```sql
-- Unique cities
SELECT DISTINCT city
FROM salesdatawalmart.sales;

-- City per branch
SELECT DISTINCT city, branch
FROM salesdatawalmart.sales;
```

- **5.4 Product Analysis**
   - Listed unique product lines and top sellers by quantity and revenue.  
   - Analyzed monthly revenue, COGS, and city/branch performance.  
   - Identified highest VAT product lines and classified them as Good/Bad.  
   - Found top product lines by gender and average rating.  
```sql
-- Unique product lines
SELECT DISTINCT product_line
FROM salesdatawalmart.sales;

-- Most selling product lines by quantity
SELECT
  SUM(quantity) AS qty,
  product_line
FROM salesdatawalmart.sales
GROUP BY product_line
ORDER BY qty DESC;

-- Monthly total revenue
SELECT
  month_name AS month,
  SUM(total) AS total_revenue
FROM salesdatawalmart.sales
GROUP BY month_name
ORDER BY total_revenue;

-- Month with largest COGS
SELECT
  month_name AS month,
  SUM(cogs) AS cogs
FROM salesdatawalmart.sales
GROUP BY month_name
ORDER BY cogs;

-- Product line with largest revenue
SELECT
  product_line,
  SUM(total) AS total_revenue
FROM salesdatawalmart.sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- City with largest revenue
SELECT
  branch,
  city,
  SUM(total) AS total_revenue
FROM salesdatawalmart.sales
GROUP BY city, branch
ORDER BY total_revenue;

-- Product line with largest VAT (average tax percent)
SELECT
  product_line,
  AVG(tax_pct) AS avg_tax
FROM salesdatawalmart.sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Tag product lines as Good/Bad vs threshold (example uses > 6)
SELECT AVG(quantity) AS avg_qnty
FROM salesdatawalmart.sales;

SELECT
  product_line,
  CASE WHEN AVG(quantity) > 6 THEN "Good" ELSE "Bad" END AS remark
FROM salesdatawalmart.sales
GROUP BY product_line;

-- Branches selling above average quantity
SELECT
  branch,
  SUM(quantity) AS qnty
FROM salesdatawalmart.sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM salesdatawalmart.sales);

-- Most common product line by gender
SELECT
  gender,
  product_line,
  COUNT(gender) AS total_cnt
FROM salesdatawalmart.sales
GROUP BY gender, product_line
ORDER BY total_cnt DESC;

-- Average rating per product line
SELECT
  ROUND(AVG(rating), 2) AS avg_rating,
  product_line
FROM salesdatawalmart.sales
GROUP BY product_line
ORDER BY avg_rating DESC;
```

- **5.5 Customer Analysis**
   - Profiled customer types, payment methods, and gender distribution (overall and per branch).  
   - Compared ratings by time of day, branch, and weekday.  
   - Identified best rating days and top sales days for specific branches.  
```sql
-- Unique customer types
SELECT DISTINCT customer_type
FROM salesdatawalmart.sales;

-- Unique payment methods
SELECT DISTINCT payment
FROM salesdatawalmart.sales;

-- Most common customer type
SELECT
  customer_type,
  COUNT(*) AS count
FROM salesdatawalmart.sales
GROUP BY customer_type
ORDER BY count DESC;

-- Which customer type buys the most
SELECT
  customer_type,
  COUNT(*)
FROM salesdatawalmart.sales
GROUP BY customer_type;

-- Gender distribution
SELECT
  gender,
  COUNT(*) AS gender_cnt
FROM salesdatawalmart.sales
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Gender distribution for a branch (example C)
SELECT
  gender,
  COUNT(*) AS gender_cnt
FROM salesdatawalmart.sales
WHERE branch = "C"
GROUP BY gender
ORDER BY gender_cnt DESC;

-- Ratings by time of day
SELECT
  time_of_day,
  AVG(rating) AS avg_rating
FROM salesdatawalmart.sales
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Ratings by time of day for branch A
SELECT
  time_of_day,
  AVG(rating) AS avg_rating
FROM salesdatawalmart.sales
WHERE branch = "A"
GROUP BY time_of_day
ORDER BY avg_rating DESC;

-- Best avg rating day
SELECT
  day_name,
  AVG(rating) AS avg_rating
FROM salesdatawalmart.sales
GROUP BY day_name
ORDER BY avg_rating DESC;

-- Sales count by weekday for branch C
SELECT
  day_name,
  COUNT(day_name) AS total_sales
FROM salesdatawalmart.sales
WHERE branch = "C"
GROUP BY day_name
ORDER BY total_sales DESC;
```

- **5.6 Sales, Time Trends, and Tax**
   - Analyzed Sunday sales by time of day.  
   - Compared revenue across customer types.  
   - Found city with highest average VAT.  
   - Identified customer type paying the most VAT.  
```sql
-- Sales by time of day for Sunday
SELECT
  time_of_day,
  COUNT(*) AS total_sales
FROM salesdatawalmart.sales
WHERE day_name = "Sunday"
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Revenue by customer type
SELECT
  customer_type,
  SUM(total) AS total_revenue
FROM salesdatawalmart.sales
GROUP BY customer_type
ORDER BY total_revenue;

-- City with highest average VAT percent
SELECT
  city,
  ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM salesdatawalmart.sales
GROUP BY city
ORDER BY avg_tax_pct DESC;

-- Which customer type pays most VAT
SELECT
  customer_type,
  AVG(tax_pct) AS total_tax
FROM salesdatawalmart.sales
GROUP BY customer_type
ORDER BY total_tax;
```

---

## 6. Key Insights
* **Yangon** branch leads in **revenue** and **tax**.
* **Food & Beverages** is the **top product line**.
* **Member** customers contribute the **largest share of sales**.
* **Evenings** and **Saturdays** show **peak demand**.
* **March** records **highest monthly revenue** in this sample.

---

## 7. Business Impacts
* **Inventory**, prioritize top lines and reduce low performers.
* **Marketing**, target high-value segments and popular slots.
* **Staffing**, align shifts to peak hours and days.
* **Profitability**, emphasize high-margin lines and cities with favorable tax dynamics.
* **Branch ops**, compare A, B, C to focus improvement.


