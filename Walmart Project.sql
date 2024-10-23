-------------------------------------------------------------PRODUCT----------------------------------------------------------
SELECT * FROM Sales

-- Unique Cities
SELECT 
	DISTINCT(City)
FROM Sales

--Branch in each city

SELECT 
	DISTINCT(City),
	Branch
FROM Sales

--Product
--How many unique product lines does the data have?

SELECT 
	ROW_NUMBER() OVER(ORDER BY Product_line) No,
	Product_line
FROM(
	SELECT 
		DISTINCT(Product_line)
	FROM Sales
) t

--What is the most common payment method?

SELECT 
	Payment,
	COUNT(Payment)
FROM Sales
GROUP BY Payment

--What is the most selling product line?

SELECT 
	Product_line,
	SUM(Quantity) Sum_Of_Unit,
	SUM(Total) Total_Spending
FROM Sales
GROUP BY Product_line

-- What is the total revenue by month?

SELECT 
	month_name Month,
	ROUND(SUM(gross_income),2) Revenue,
	RANK() OVER( ORDER BY SUM(gross_income) DESC) Standing
FROM Sales
GROUP BY month_name

--What month had the largest COGS?

SELECT 
	*
FROM(SELECT
	month_name Month,
	ROUND(SUM(Unit_price*Quantity),2) Total_Cogs,
	RANK() OVER(ORDER BY SUM(cogs) DESC) Standing
FROM Sales	
GROUP BY month_name
) t WHERE Standing = 1

-- What product line had the largest revenue?

SELECT
	*
FROM(SELECT
	Gender,
	Product_line Product,
	ROUND(SUM(gross_income),0) Income,
	RANK() OVER(PARTITION BY Gender ORDER BY SUM(gross_income) DESC) RANK
FROM Sales
GROUP BY Gender, Product_line
) t WHERE Gender = 'Male'


-- What is the city with the largest revenue?

SELECT	
	*
FROM(SELECT 
	City,
	ROUND(SUM(gross_income),0) Revenue,
	RANK() OVER(ORDER BY SUM(gross_income)) RANK
	FROM Sales
	GROUP BY City
) S WHERE RANK = 1

-- What product line had the largest VAT?
SELECT * FROM SALES

SELECT 
	*
FROM(SELECT 
	Product_line,
	ROUND(SUM(cogs*0.05),2) Total_Tax,
	RANK() OVER(ORDER BY SUM(Tax_5) DESC) Rank
	FROM Sales
	GROUP BY Product_line
) A WHERE Rank = 1

--Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales

SELECT 
	COUNT(*) 
FROM(SELECT
	Product_line,
	Total,
	AVG(Total) OVER(PARTITION BY Product_line) Average_Sales,
	CASE
		WHEN Total > AVG(Total) OVER(PARTITION BY Product_line) THEN 'Good'
		WHEN Total = AVG(Total) OVER(PARTITION BY Product_line) THEN 'Neutral'
		Else 'Bad'
	END Rank
	FROM Sales
) R WHERE Product_line = 'Electronic accessories' AND Rank = 'Good'

-- Which branch sold more products than average product sold?

WITH Branch_Sales AS (
    SELECT 
        Branch,
        SUM(Quantity) AS Total_Products_Sold
    FROM Sales
    GROUP BY Branch
)
SELECT 
    Branch,
    Total_Products_Sold,
    (SELECT AVG(Total_Products_Sold) FROM Branch_Sales) AS Average_Products_Sold
FROM Branch_Sales
WHERE Total_Products_Sold > (SELECT AVG(Total_Products_Sold) FROM Branch_Sales)

--What is the most common product line by gender?
WITH Cm_pd_line AS (
    SELECT
        Gender,
        Product_line, 
        COUNT(*) OVER(PARTITION BY Gender) AS Count_Gender,
        COUNT(*) OVER(PARTITION BY Product_line) AS Count_Product
    FROM Sales
)
SELECT 
	*
FROM(SELECT
    Gender,
    Product_line,
    Count_Product,
	RANK() OVER(ORDER BY Count_Product DESC) Rank
FROM Cm_pd_line
GROUP BY Gender, Product_line, Count_Product
) J
WHERE Rank = 1

-- What is the average rating of each product line?

SELECT 
	Product_line,
	Round(AVG(Rating),2) Average_rating,
	RANK() OVER(ORDER BY AVG(Rating) DESC) Standing
FROM Sales
GROUP BY Product_line

---------------------------------------------------------SALES--------------------------------------------------------------
SELECT * FROM Sales

-- Number of sales made in each time of the day per weekday
SELECT 
	COUNT(Invoice_ID) No_of_Sales,
	time_of_day,
	day_name,
	RANK() OVER(ORDER BY COUNT(Invoice_ID) DESC) Rank
FROM Sales
GROUP BY time_of_day,day_name

--Which of the customer types brings the most revenue?

SELECT 
    Customer_type,
    ROUND(SUM(gross_income), 2) AS Revenue,
    RANK() OVER(ORDER BY SUM(gross_income) DESC) AS Standing
FROM Sales
GROUP BY Customer_type;

--Which city has the largest tax percent/ VAT (Value Added Tax)?

SELECT 
	City,
	ROUND(AVG(Tax_5), 2) AS Tax,
	Rank() OVER(ORDER BY AVG(Tax_5) DESC) AS Standing
FROM Sales
GROUP BY City;

-- Which customer type pays the most in VAT?

SELECT 
	Customer_type,
	ROUND(AVG(0.05*cogs), 2) AS Payment,
	RANK() OVER(ORDER BY AVG(0.05*cogs) DESC) AS Standing
FROM Sales
GROUP BY Customer_Type

----------------------------------------------------------------CUSTOMER-----------------------------------------------------
 SELECT * FROM SALES

-- How many unique customer types does the data have?

SELECT 
	DISTINCT(Customer_type)
FROM Sales

-- How many unique payment methods does the data have?

SELECT 
	DISTINCT(Payment)
FROM Sales

-- What is the most common customer type?

SELECT 
	Customer_type,
	COUNT(Customer_type) Count
FROM Sales
GROUP BY Customer_type
ORDER BY COUNT(Customer_type) DESC

-- Which customer type buys the most?

SELECT 
	*
FROM(SELECT 
	Customer_type,
	COUNT(Invoice_ID) Count, 
	RANK() OVER(ORDER BY COUNT(Invoice_ID) DESC) AS Standing
FROM Sales
GROUP BY Customer_type
) F WHERE Standing = 1

--What is the gender of most of the customers?

SELECT 
	Gender,
	COUNT(Invoice_ID) Count
FROM Sales
GROUP BY Gender
ORDER BY Count DESC

-- What is the gender distribution per branch?

SELECT 
	Branch,
	Gender,
	COUNT(Invoice_ID) Distribution_Gender
FROM Sales
GROUP BY Branch,Gender
ORDER BY Branch,Distribution_Gender DESC

--Which time of the day do customers give most ratings?

SELECT 
	time_of_day Time,
	COUNT(Rating) Count,
	RANK() OVER(ORDER BY COUNT(Rating) DESC) Standing
FROM Sales
GROUP BY time_of_day

--  Which time of the day do customers give most ratings per branch?

SELECT 
	Branch,
	time_of_day Time,
	COUNT(Rating) Count,
	RANK() OVER(PARTITION BY Branch ORDER BY COUNT(Rating) DESC) Standing
FROM Sales
GROUP BY Branch, time_of_day

-- Which day fo the week has the best avg ratings?

SELECT 
	day_name Day,
	ROUND(AVG(Rating),2) AS Rating,
	RANK() OVER(ORDER BY AVG(Rating) DESC) Standing
FROM Sales
GROUP BY day_name

--Which day of the week has the best average ratings per branch?

SELECT
	Branch,
	Day,
	Rating
FROM(SELECT 
	Branch,
	day_name Day,
	ROUND(AVG(Rating),2) AS Rating,
	RANK() OVER(PARTITION BY Branch ORDER BY AVG(Rating) DESC) Standing
	FROM Sales
	GROUP BY Branch, day_name
) V WHERE Standing = 1