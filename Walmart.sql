
-- Created the table
CREATE TABLE Walmart
(
	Store int,
    Date date,
    Weekly_sales float,
	Holiday_flag int,
	Temperature float,
	Fuel_price float,
	CPI float,
	Unemployment float
);
-- imported the values inside the table
-- taking a overlook at the table
SELECT * FROM Walmart

---- Check for missing values in each column
SELECT 
    COUNT(*) - COUNT(Store) AS missing_store,
    COUNT(*) - COUNT(Date) AS missing_date,
    COUNT(*) - COUNT(Weekly_sales) AS missing_weekly_sales,
    COUNT(*) - COUNT(Holiday_flag) AS missing_holiday_flag,
    COUNT(*) - COUNT(Temperature) AS missing_temperature,
    COUNT(*) - COUNT(Fuel_price) AS missing_fuel_price,
    COUNT(*) - COUNT(CPI) AS missing_cpi,
    COUNT(*) - COUNT(Unemployment) AS missing_unemployment
FROM Walmart;

---- Get a sense of the numerical data ranges
SELECT
    MIN(Weekly_sales), MAX(Weekly_sales), AVG(Weekly_sales),
    MIN(Temperature), MAX(Temperature), AVG(Temperature),
    MIN(Fuel_price), MAX(Fuel_price), AVG(Fuel_price),
    MIN(CPI), MAX(CPI), AVG(CPI),
    MIN(Unemployment), MAX(Unemployment), AVG(Unemployment)
FROM Walmart;

---1.Let's analysis the sales now
-- Total, average, min, and max weekly sales across all stores
SELECT 
    SUM(Weekly_sales) AS total_sales,
    AVG(Weekly_sales) AS average_sales,
    MIN(Weekly_sales) AS minimum_sales,
    MAX(Weekly_sales) AS maximum_sales
FROM Walmart;

-- 1.1 Weekly sales by holiday vs. non-holiday weeks
SELECT 
	SUM(weekly_sales) AS total_sales,
	AVG(weekly_sales) AS avg_sales,
	holiday_flag 
FROM Walmart
GROUP BY holiday_flag;

--1.2 Sales over time to look at the trend
SELECT
	Date,
	SUM(weekly_sales) AS total_sales
FROM Walmart
	GROUP BY Date
	ORDER BY Date;
	
--2. Impact of External Factors on Sales
-- Taking a look again at the data
SELECT * FROM Walmart
--Examine how temperature, fuel prices, CPI, and unemployment rates may correlate with sales
-- 2.1 Average sales by temperature range
SELECT
    CASE 
        WHEN Temperature < 32 THEN 'Below Freezing'
        WHEN Temperature BETWEEN 32 AND 50 THEN 'Cold'
        WHEN Temperature BETWEEN 50 AND 70 THEN 'Mild'
        WHEN Temperature BETWEEN 70 AND 85 THEN 'Warm'
        ELSE 'Hot'
    END AS Temperature_Range,
    AVG(Weekly_sales) AS Average_Sales
FROM Walmart
GROUP BY Temperature_Range;

-- 2.2 Average sales by fuel price
SELECT
	CASE
		WHEN fuel_price < 2 THEN 'Below $2'
		WHEN fuel_price BETWEEN 2 AND 3 THEN '$2 to $3'
		WHEN fuel_price BETWEEN 3 AND 4 THEN '$3 to $4'
		ELSE 'Above $4'
	END AS Fuel_Price_Range,
	AVG(weekly_sales) AS Avg_sales
FROM Walmart
GROUP BY Fuel_Price_Range

--2.3 Avg sales by CPI
SELECT
    CASE 
        WHEN CPI < 100 THEN 'Below 100'
        WHEN CPI BETWEEN 100 AND 150 THEN '100 to 150'
        WHEN CPI BETWEEN 150 AND 200 THEN '150 to 200'
        ELSE 'Above 200'
    END AS CPI_Range,
    AVG(Weekly_sales) AS Avg_Sales
FROM Walmart
GROUP BY CPI_Range;

--2.4 Avg sales by unemployment 
SELECT
    CASE 
        WHEN Unemployment < 4 THEN 'Below 4%'
        WHEN Unemployment BETWEEN 4 AND 6 THEN '4% to 6%'
        WHEN Unemployment BETWEEN 6 AND 8 THEN '6% to 8%'
        ELSE 'Above 8%'
    END AS Unemployment_Range,
    AVG(Weekly_sales) AS Average_Sales
FROM Walmart
GROUP BY Unemployment_Range;

3. Store Performance
--3.1 Sales performance by store
SELECT 
    Store,
    SUM(Weekly_sales) AS total_sales,
    AVG(Weekly_sales) AS average_sales,
    MIN(Weekly_sales) AS minimum_sales,
    MAX(Weekly_sales) AS maximum_sales
FROM Walmart
GROUP BY Store
ORDER BY total_sales DESC;

--3.2 Unemployment by store
SELECT 
    Store,
    SUM(unemployment) AS total_unemployment,
    AVG(unemployment) AS average_unemployment,
    MIN(unemployment) AS minimum_unemployment,
    MAX(unemployment) AS maximum_unemployment
FROM Walmart
GROUP BY Store
ORDER BY store,total_unemployment DESC;

--3.3 cpi by store
SELECT 
    Store,
    SUM(cpi) AS total_cpi,
    AVG(cpi) AS average_cpi,
    MIN(cpi) AS minimum_cpi,
    MAX(cpi) AS maximum_cpi
FROM Walmart
GROUP BY Store
ORDER BY store,total_cpi DESC;

--4 Time Series Analysis
-- Monthly sales trends
SELECT
	EXTRACT(YEAR FROM Date) AS Year,
	EXTRACT(MONTH FROM Date) AS Month,
	SUM(Weekly_sales) AS total_sales
FROM Walmart
GROUP BY Year, Month
ORDER BY Year, Month;

-- Best and worst month
SELECT 
    EXTRACT(MONTH FROM Date) AS Month, 
    SUM(Weekly_sales) AS Total_Sales
FROM Walmart
GROUP BY Month
ORDER BY Total_Sales DESC;

-- Best and worst quarter
SELECT 
    EXTRACT(QUARTER FROM Date) AS Quarter, 
    SUM(Weekly_sales) AS Total_Sales
FROM Walmart
GROUP BY Quarter
ORDER BY Total_Sales DESC;

--5 Annual sales growth by store
WITH yearly_sales AS (
    SELECT 
        Store, 
        EXTRACT(YEAR FROM Date) AS Year, 
        SUM(Weekly_sales) AS Total_Sales
    FROM Walmart
    GROUP BY Store, Year
)
SELECT 
    current.Store, 
    current.Year, 
    current.Total_Sales - COALESCE(previous.Total_Sales, 0) AS Growth
FROM yearly_sales current
LEFT JOIN yearly_sales previous ON current.Store = previous.Store 
    AND current.Year = previous.Year + 1
ORDER BY Growth DESC;

	

	
	
