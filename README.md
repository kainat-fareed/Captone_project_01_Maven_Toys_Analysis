# Toys Store Data Analysis Project

## Project Overview
This project performs a comprehensive SQL-based analysis of the **Toys Store dataset** from [Kaggle](https://www.kaggle.com/datasets/mysarahmadbhat/toy-sales) to extract actionable insights on sales performance, product success, inventory management, and profitability. The goal is to help toy store managers make **data-driven decisions** to optimize operations, enhance revenue, and improve inventory strategies.

---

## Dataset Description
The project utilizes four CSV tables containing store, product, sales, and inventory information:

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
- Identify top-performing and low-performing stores based on sales and profit.  
- Calculate total sales and profit for each store.  
- Analyze daily running sales and profit per store.  
- Determine best-selling products per store.  
- Identify unsold units per store.

### Sales Analysis
- Track sales trends over time (monthly/seasonal patterns).  
- Calculate total running sales for each month.  
- Identify cities surpassing $1 million in sales and their profits.

### Inventory Analysis
- Correlate inventory levels with sales to identify overstock or stock-outs.  
- Determine product availability across all stores.  
- Analyze monthly product sales per store.

### Product Analysis
- Analyze revenue and profit contribution by product category.  
- Identify top-performing and worst-performing products.  
- Calculate total units sold, sales, and profit per product.  
- Determine daily and monthly product sales per store.

### Revenue and Profit Analysis
- Calculate revenue and profit from remaining stock across all stores.

---

## Tools & Technologies
- **SQL**: Data querying, aggregation, and analysis   
- **Power BI**: Dashboards and data visualization  

