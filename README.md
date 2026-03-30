# Moven Toys Store Data Analysis Project

## Project Overview
This project performs a comprehensive SQL-based analysis of the **Toys Store dataset** from [Kaggle](https://www.kaggle.com/datasets/mysarahmadbhat/toy-sales) to extract actionable insights on sales performance, product success, inventory management, and profitability. The goal is to help toy store managers make **data-driven decisions** to optimize operations, enhance revenue, and improve inventory strategies.  

In addition to SQL-based analysis, a **data warehouse** was designed using both **star and snowflake schemas** to consolidate sales, store, product, inventory, and time data for efficient reporting and analytics.

---

## Dataset Description
The project uses four CSV tables containing store, product, sales, and inventory information:

### 1. Products Table
| Column | Description |
|--------|-------------|
| Product_ID | Unique identifier for each product |
| Product_Name | Name of the product |
| Product_Category | Category of the product |
| Product_Cost (USD) | Cost of product acquisition/manufacturing |
| Product_Price (USD) | Retail price for customers |

### 2. Stores Table
| Column | Description |
|--------|-------------|
| Store_ID | Unique identifier for each store |
| Store_Name | Name of the store |
| Store_City | City location of the store |
| Store_Location | Area classification (Downtown, Commercial, Residential, Airport) |
| Store_Open_Date | Date the store was opened |

### 3. Sales Table
| Column | Description |
|--------|-------------|
| Sale_ID | Unique identifier for each transaction |
| Date | Date of the transaction |
| Store_ID | Reference to the store |
| Product_ID | Reference to the product |
| Units | Number of units sold |

### 4. Inventory Table
| Column | Description |
|--------|-------------|
| Store_ID | Reference to the store |
| Product_ID | Reference to the product |
| Stock_On_Hand | Units available in stock |

---

## Project Objectives

### Store-wise Analysis
- Identify top-performing and low-performing stores based on sales and profit  
- Calculate total sales and profit for each store  
- Analyze daily running sales and profit per store  
- Determine best-selling products per store  
- Identify unsold units per store  

### Sales Analysis
- Track sales trends over time (monthly/seasonal patterns)  
- Calculate total running sales for each month  
- Identify cities surpassing $1 million in sales and their profits  

### Inventory Analysis
- Correlate inventory levels with sales to identify overstock or stock-outs  
- Determine product availability across all stores  
- Analyze monthly product sales per store  

### Product Analysis
- Analyze revenue and profit contribution by product category  
- Identify top-performing and worst-performing products  
- Calculate total units sold, sales, and profit per product  
- Determine daily and monthly product sales per store  

### Revenue and Profit Analysis
- Calculate revenue and profit from remaining stock across all stores  

---

## Data Warehousing & Dimensional Modeling

A **data warehouse** was created for the Toys Store dataset to support advanced analytics and reporting. Both **star schema** and **snowflake schema** approaches were implemented.  

### Star Schema
- **Fact Table:** `Sales_Fact` (Stores sales transactions, total sales, and profit metrics)  
- **Dimension Tables:**  
  - `Products_Dimension` (Product details)  
  - `Stores_Dimension` (Store details and locations)  
  - `Inventory_Dimension` (Stock on hand per store)  
  - `Calendar_Dimension` (Date attributes for time-based analysis)

**Highlights:**
- Consolidates sales, product, store, inventory, and date data  
- Enables reporting across stores, products, and time periods  
- Supports dashboards and performance monitoring  

### Snowflake Schema
- **Normalized Dimensions:**  
  - `Product_Category` → Products linked via `Category_ID`  
  - `Store_City` and `Store_Location` → Stores linked via `City_ID` and `Location_ID`  
  - `Season` → Calendar linked via `Season_ID`  

**Highlights:**
- Reduces data redundancy  
- Ensures referential integrity between dimensions  
- Provides flexibility for multi-level analysis (e.g., category-level, city-level, seasonal trends)

### SQL Implementation
- **Dimension Tables:** Populated from raw CSV tables (`products`, `stores`, `inventory`, `calendar`)  
- **Fact Table:** Populated with sales transactions joined with dimension tables, including calculated `Total_Sales` and `Total_Profit`  
- **Calendar Table:** Dynamically generated using a recursive CTE for time-based analysis  
- **Normalization:** Snowflake schema created with separate tables for categories, cities, locations, and seasons, referenced by foreign keys in main dimension tables  

This structure allows for **efficient querying, aggregation, and visualization** of store and product performance, supporting data-driven decision-making.

---

## Tools & Technologies
- **SQL**: Used for data querying, transformation, aggregation, and creating the data warehouse (fact and dimension tables). Essential for performing sales, inventory, and product analysis efficiently.
- **Power BI**: Dashboards and data visualization to present actionable insights from the data warehouse and SQL analysis.
