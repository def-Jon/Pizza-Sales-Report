-- Data View
SELECT *
FROM pizza_sales


-- Total Revenue
SELECT SUM(total_price) AS Total_Revenue
FROM pizza_sales


-- Total Pizza Sold
SELECT COUNT(quantity) AS Total_Pizza_Sold
FROM pizza_sales

-- Total Orders
SELECT COUNT(DISTINCT order_id)
FROM pizza_sales

-- Average Order Value
SELECT CAST( CAST(SUM(total_price) AS DECIMAL (10,2))/ 
		CAST(COUNT(DISTINCT order_id)AS decimal (10,2)) AS decimal(10,2)) AS Avg_Order_Value
FROM pizza_sales;

-- Average Pizza Sold Per Order
SELECT CAST(CAST(COUNT(quantity)AS DECIMAL (10, 2)) / 
		CAST (COUNT(DISTINCT order_id) AS decimal (10,2)) AS DECIMAL (10, 2)) AS Avg_Pizza_Sold
FROM pizza_sales


-- Hourly Trend
SELECT DATEPART(HOUR,order_time) AS hour_of_day, Count(DISTINCT order_id) AS Hourly_Orders
FROM pizza_sales
GROUP BY DATEPART(HOUR,order_time)
ORDER BY DATEPART(HOUR,order_time) ASC;

--Daily Trend
SELECT DATENAME(DW, order_date) AS order_day, COUNT(DISTINCT order_id) AS Total_orders
FROM pizza_sales
GROUP BY DATENAME(DW, order_date);

--Monthly/seasons of the year

SELECT DISTINCT MONTH(order_date) AS Months,

(CASE WHEN MONTH(order_date) IN (12, 1, 2) THEN 'WINTER'

WHEN MONTH(order_date) IN (3, 4, 5) THEN 'SPRING'

WHEN MONTH(order_date) IN (6, 7, 8) THEN 'SUMMER'

WHEN MONTH(order_date) IN (9, 10, 11) THEN 'AUTUMN'

END) as Season

FROM pizza_sales
GROUP BY MONTH(order_date)
ORDER BY Months;



 -- Sales per Seasons of the year

WITH CTE ( Months, Revenue, Seasons) AS 
			
			(SELECT DISTINCT MONTH(order_date),

			CAST(SUM(total_price) AS DECIMAL (10,2)),

			(CASE WHEN MONTH(order_date) IN (12, 1, 2) THEN 'WINTER'

				WHEN MONTH(order_date) IN (3, 4, 5) THEN 'SPRING'

				WHEN MONTH(order_date) IN (6, 7, 8) THEN 'SUMMER'

				WHEN MONTH(order_date) IN (9, 10, 11) THEN 'AUTUMN'

				END)

			 FROM pizza_sales 
			 GROUP BY MONTH(order_date))
	SELECT DISTINCT Seasons, SUM(Revenue) AS Seasonal_Revenue
	FROM CTE
	GROUP BY Seasons
	ORDER BY SUM(Revenue) DESC;



--Percent of revenue by Pizza Category

SELECT DISTINCT pizza_category, CAST(SUM(total_price) * 100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL (10,2)) AS Revenue_per_Cat
FROM pizza_sales
GROUP BY pizza_category
ORDER BY Revenue_per_Cat ASC;

--Percent of Sales by pizza size

SELECT pizza_size, CAST(SUM(total_price)*100 / (SELECT SUM(total_price) FROM pizza_sales) AS DECIMAL (10,2)) AS Sales_percent_of_pizzaSize
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Sales_percent_of_pizzaSize DESC;


--Most Order Pizza Size

SELECT pizza_size, COUNT(quantity) AS Orders
FROM pizza_sales
GROUP BY pizza_size
ORDER BY Orders DESC;





