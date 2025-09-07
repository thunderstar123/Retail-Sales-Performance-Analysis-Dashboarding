SELECT * FROM blinkit_data

-- CLEANING THE DATA SET --
UPDATE blinkit_data
SET Item_Fat_Content =
CASE 
WHEN Item_Fat_Content IN ('LF', 'low fat') THEN 'Low Fat'
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
ELSE Item_Fat_Content
END

SELECT DISTINCT(Item_Fat_Content) FROM blinkit_data


-- KPI RECUIREMENTS --
SELECT CAST(SUM(Total_Sales)/1000000 AS DECIMAL(10,2)) AS Total_Sales_Millions
FROM blinkit_data
WHERE Item_Fat_Content='Low Fat'

SELECT CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales FROM blinkit_data

SELECT COUNT(*) AS No_Of_Items FROM blinkit_data

SELECT CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating FROM blinkit_data


-- GRANULAR REQUIREMENTS -- 
SELECT Item_Fat_Content, 
        CAST(SUM(Total_Sales)/1000 AS DECIMAL(10,2)) AS Total_Sales_Thousands,
        CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
        COUNT(*) AS No_of_Items,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC

-- Total Sales by Item Type --
SELECT Item_Type,
        CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
        CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
        COUNT(*) AS No_of_Items,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales DESC



-- Fat Content by Outlet for Total Sales--
SELECT Outlet_Location_Type, 
       ISNULL([Low Fat], 0) AS Low_Fat, 
       ISNULL([Regular], 0) AS Regular
FROM 
(
    SELECT Outlet_Location_Type, Item_Fat_Content, 
           CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales
    FROM blinkit_data
    GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT 
(
    SUM(Total_Sales) 
    FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;


-- Total Sales by Outlet Establishment--
SELECT Outlet_Establishment_Year,
        CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
        CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
        COUNT(*) AS No_of_Items,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Outlet_Establishment_Year ASC

-- Percentage of Sales by Outlet Size--
SELECT 
    Outlet_Size, 
    CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
    CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

-- Sales by Outlet Location--
SELECT Outlet_Location_Type, 
        CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
        CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10,2)) AS Sales_Percentage,
        CAST(AVG(Total_Sales) AS DECIMAL(10,1)) AS Avg_Sales,
        COUNT(*) AS No_of_Items,
        CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC

-- ALL METRICS BY OUTLET TYPE --
SELECT Outlet_Type, 
CAST(SUM(Total_Sales) AS DECIMAL(10,2)) AS Total_Sales,
		CAST(AVG(Total_Sales) AS DECIMAL(10,0)) AS Avg_Sales,
		COUNT(*) AS No_Of_Items,
		CAST(AVG(Rating) AS DECIMAL(10,2)) AS Avg_Rating,
		CAST(AVG(Item_Visibility) AS DECIMAL(10,2)) AS Item_Visibility
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC