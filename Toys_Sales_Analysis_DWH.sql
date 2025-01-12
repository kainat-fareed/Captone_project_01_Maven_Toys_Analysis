
CREATE DATABASE TOYS_DWH_SnowFlake
USE TOYS_DWH_SnowFlake

-- SnowFlake Schema ----- creating Sub Dimenstion Tables

-- Creating the Product_Category Table
CREATE TABLE Product_Category (
    Category_ID INT PRIMARY KEY IDENTITY(1,1),
    Category_Name NVARCHAR(100) NOT NULL UNIQUE
);


-- Creating the Store_City Table
CREATE TABLE Store_City (
    City_ID INT PRIMARY KEY IDENTITY(1,1),
    City_Name NVARCHAR(100) NOT NULL UNIQUE
);

-- Creating the Store_Location Table
CREATE TABLE Store_Location (
    Location_ID INT PRIMARY KEY IDENTITY(1,1),
    Location_Type NVARCHAR(100) NOT NULL UNIQUE
);

-- Creating the Season Table
CREATE TABLE Season (
    Season_ID INT PRIMARY KEY IDENTITY(1,1),
    Season_Name NVARCHAR(10) NOT NULL UNIQUE
);

-- Populate Product_Category Table
INSERT INTO Product_Category (Category_Name)
SELECT DISTINCT Product_Category
FROM TOYS.dbo.products;

-- Populate Store_City Table
INSERT INTO Store_City (City_Name)
SELECT DISTINCT Store_City
FROM TOYS.dbo.stores;

-- Populate Store_Location Table
INSERT INTO Store_Location (Location_Type)
SELECT DISTINCT Store_Location
FROM TOYS.dbo.stores;

-- Populate Season Table
INSERT INTO Season (Season_Name)
VALUES ('Winter'), ('Spring'), ('Summer'), ('Fall');

-- Creating the Products_Dimension Table with normalized Category_ID
CREATE TABLE Products_Dimension (
    Product_ID INT PRIMARY KEY,
    Product_Name NVARCHAR(255) NOT NULL,
    Category_ID INT NOT NULL,
    Product_Cost DECIMAL(10, 2) NOT NULL,
    Product_Price DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (Category_ID) REFERENCES Product_Category(Category_ID)
);

-- Creating the Stores_Dimension Table with normalized City_ID and Location_ID
CREATE TABLE Stores_Dimension (
    Store_ID INT PRIMARY KEY,
    Store_Name NVARCHAR(255) NOT NULL,
    City_ID INT NOT NULL,
    Location_ID INT NOT NULL, -- Remove if not normalizing Store_Location
    Store_Open_Date DATE NOT NULL,
    FOREIGN KEY (City_ID) REFERENCES Store_City(City_ID),
    FOREIGN KEY (Location_ID) REFERENCES Store_Location(Location_ID) -- Remove if not normalizing
);

-- Creating the Calendar_Dimension Table with normalized Season_ID
CREATE TABLE Calendar_Dimension (
    Calendar_Date DATE PRIMARY KEY,
    Year INT NOT NULL,
    Month INT NOT NULL,
    Month_Name VARCHAR(20) NOT NULL,
    Day INT NOT NULL,
    Day_Name VARCHAR(20) NOT NULL,
    Weekday INT NOT NULL,
    IsWeekend BIT NOT NULL,
    Quarter INT NOT NULL,
    Season_ID INT NOT NULL,
    FOREIGN KEY (Season_ID) REFERENCES Season(Season_ID)
);


-- Populate Products_Dimension with normalized Category_ID
INSERT INTO Products_Dimension (Product_ID, Product_Name, Category_ID, Product_Cost, Product_Price)
SELECT 
    p.Product_ID, 
    p.Product_Name, 
    pc.Category_ID,
    p.Product_Cost, 
    p.Product_Price
FROM 
    TOYS.dbo.products p
JOIN 
    Product_Category pc ON p.Product_Category = pc.Category_Name;

-- Populate Stores_Dimension with normalized City_ID and Location_ID
INSERT INTO Stores_Dimension (Store_ID, Store_Name, City_ID, Location_ID, Store_Open_Date)
SELECT 
    s.Store_ID, 
    s.Store_Name, 
    sc.City_ID, 
    sl.Location_ID, 
    s.Store_Open_Date
FROM 
    TOYS.dbo.stores s
JOIN 
    Store_City sc ON s.Store_City = sc.City_Name
JOIN 
    Store_Location sl ON s.Store_Location = sl.Location_Type;


-- Creating the Inventory Dimension Table (already created earlier)
CREATE TABLE Inventory_Dimension (
    Store_ID INT,
    Product_ID INT,
    Stock_On_Hand INT NOT NULL,
    PRIMARY KEY (Store_ID, Product_ID),
    FOREIGN KEY (Store_ID) REFERENCES Stores_Dimension(Store_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products_Dimension(Product_ID)
);

-- Populate Inventory_Dimension
INSERT INTO Inventory_Dimension (Store_ID, Product_ID, Stock_On_Hand)
SELECT 
    i.Store_ID, 
    i.Product_ID, 
    i.Stock_On_Hand
FROM 
    TOYS.dbo.inventory i;


	-- c. Populate Calendar_Dimension
-- Define the date range dynamically
DECLARE @StartDate DATE = '2017-01-01';
DECLARE @EndDate DATE = DATEADD(YEAR, 1, CAST(GETDATE() AS DATE)); -- One year from today

-- Use a Common Table Expression (CTE) to generate dates
WITH DateRange AS (
    SELECT @StartDate AS Calendar_Date
    UNION ALL
    SELECT DATEADD(DAY, 1, Calendar_Date)
    FROM DateRange
    WHERE DATEADD(DAY, 1, Calendar_Date) <= @EndDate
)
-- Insert dates and their attributes into the Calendar table
INSERT INTO Calendar_Dimension (
    Calendar_Date, 
    Year, 
    Month, 
    Month_Name, 
    Day, 
    Day_Name, 
    Weekday, 
    IsWeekend,
    Quarter,
    Season_ID
)
SELECT 
    Calendar_Date,
    YEAR(Calendar_Date) AS Year,
    MONTH(Calendar_Date) AS Month,
    DATENAME(MONTH, Calendar_Date) AS Month_Name,
    DAY(Calendar_Date) AS Day,
    DATENAME(WEEKDAY, Calendar_Date) AS Day_Name,
    DATEPART(WEEKDAY, Calendar_Date) AS Weekday,
    CASE 
        WHEN DATEPART(WEEKDAY, Calendar_Date) IN (1, 7) THEN 1 -- Sunday=1, Saturday=7
        ELSE 0
    END AS IsWeekend,
    DATEPART(QUARTER, Calendar_Date) AS Quarter,
    CASE 
        WHEN MONTH(Calendar_Date) IN (12, 1, 2) THEN (SELECT Season_ID FROM Season WHERE Season_Name = 'Winter')
        WHEN MONTH(Calendar_Date) IN (3, 4, 5) THEN (SELECT Season_ID FROM Season WHERE Season_Name = 'Spring')
        WHEN MONTH(Calendar_Date) IN (6, 7, 8) THEN (SELECT Season_ID FROM Season WHERE Season_Name = 'Summer')
        ELSE (SELECT Season_ID FROM Season WHERE Season_Name = 'Fall')
    END AS Season_ID
FROM 
    DateRange
OPTION (MAXRECURSION 0); -- Allows the CTE to run beyond the default recursion limit

-- Creating the Inventory Dimension Table
CREATE TABLE Inventory_Dimension (
    Store_ID INT,
    Product_ID INT,
    Stock_On_Hand INT NOT NULL,
    PRIMARY KEY (Store_ID, Product_ID),
    FOREIGN KEY (Store_ID) REFERENCES Stores_Dimension(Store_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products_Dimension(Product_ID)
);

-- Populate Inventory_Dimension
INSERT INTO Inventory_Dimension (Store_ID, Product_ID, Stock_On_Hand)
SELECT 
    i.Store_ID, 
    i.Product_ID, 
    i.Stock_On_Hand
FROM 
    TOYS.dbo.inventory i;


	-- Creating the Sales Fact Table
CREATE TABLE Sales_Fact (
    Sale_ID INT PRIMARY KEY IDENTITY(1,1),
    Calendar_Date DATE NOT NULL,
    Store_ID INT,
    Product_ID INT,
    Units_Sold INT NOT NULL,
    Total_Sales DECIMAL(10, 2) NOT NULL,
    Total_Profit DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (Store_ID) REFERENCES Stores_Dimension(Store_ID),
    FOREIGN KEY (Product_ID) REFERENCES Products_Dimension(Product_ID),
    FOREIGN KEY (Calendar_Date) REFERENCES Calendar_Dimension(Calendar_Date)
);

-- Populate Sales_Fact Table with normalized dimensions
INSERT INTO Sales_Fact (Calendar_Date, Store_ID, Product_ID, Units_Sold, Total_Sales, Total_Profit)
SELECT 
    s.Date AS Calendar_Date, 
    s.Store_ID, 
    s.Product_ID, 
    s.Units, 
    s.Units * p.Product_Price AS Total_Sales,
    (p.Product_Price - p.Product_Cost) * s.Units AS Total_Profit
FROM 
    TOYS.dbo.sales s
JOIN 
    Products_Dimension p ON s.Product_ID = p.Product_ID
JOIN 
    Calendar_Dimension c ON s.Date = c.Calendar_Date;


---**************** Table Data ****************-----------

SELECT * from Calendar_Dimension;
SELECT * from Product_Category;
SELECT * FROM Products_Dimension
SELECT * FROM season
SELECT * from Store_City
SELECT * from Store_Location
select * from Stores_Dimension
select * from Inventory_Dimension
select * from Sales_Fact


---**************** SQL Queries fo Analysis ****************-----------

--Total Sales and Profit per Store
SELECT Store_ID, 
       SUM(Total_Sales) AS Total_Store_Sales, 
       SUM(Total_Profit) AS Total_Store_Profit
FROM Sales_Fact
GROUP BY Store_ID
ORDER BY Total_Store_Profit DESC;


