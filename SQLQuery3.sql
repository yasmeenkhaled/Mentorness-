USE Corona

--Q1. Write a code to check NULL values
SELECT *
FROM [Corona Virus Dataset]
WHERE Province IS NULL
   OR Country_Region IS NULL
   OR Latitude IS NULL
   OR Longitude IS NULL
   OR Date IS NULL
   OR Confirmed IS NULL
   OR Deaths IS NULL
   OR Recovered IS NULL;

--Q2. If NULL values are present, update them with zeros for all columns.

UPDATE [Corona Virus Dataset]
SET Province = COALESCE(Province, 'Unknown'),
    Country_Region = COALESCE(Country_Region, 'Unknown'),
    Latitude = COALESCE(Latitude, 0),
    Longitude = COALESCE(Longitude, 0),
    Date = COALESCE(Date, '1900-01-01'),
    Confirmed = COALESCE(Confirmed, 0),
    Deaths = COALESCE(Deaths, 0),
    Recovered = COALESCE(Recovered, 0);

-- Q3. check total number of rows

SELECT COUNT(*) AS TotalRows
FROM [Corona Virus Dataset]

-- Q4. Check what is start_date and end_date

SELECT 
    MIN(Date) AS start_date,
    MAX(Date) AS end_date
FROM [Corona Virus Dataset];

-- Q5. Number of month present in dataset

SELECT COUNT(DISTINCT YEAR(Date) * 100 + MONTH(Date)) AS DistinctMonthCount
FROM [Corona Virus Dataset];

-- Q6. Find monthly average for confirmed, deaths, recovered

SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    AVG(CAST(Confirmed AS FLOAT)) AS AverageConfirmed,
    AVG(CAST(Deaths AS FLOAT)) AS AverageDeaths,
    AVG(CAST(Recovered AS FLOAT)) AS AverageRecovered
FROM [Corona Virus Dataset]
GROUP BY YEAR(Date), MONTH(Date)
ORDER BY Year, Month;


-- Q7. Find most frequent value for confirmed, deaths, recovered each month 

WITH RankedValues AS (
    SELECT 
        YEAR(Date) AS Year,
        MONTH(Date) AS Month,
        Confirmed,
        Deaths,
        Recovered,
        DENSE_RANK() OVER (PARTITION BY YEAR(Date), MONTH(Date) ORDER BY Confirmed DESC) AS RankConfirmed,
        DENSE_RANK() OVER (PARTITION BY YEAR(Date), MONTH(Date) ORDER BY Deaths DESC) AS RankDeaths,
        DENSE_RANK() OVER (PARTITION BY YEAR(Date), MONTH(Date) ORDER BY Recovered DESC) AS RankRecovered
    FROM [Corona Virus Dataset]
)
SELECT 
    Year,
    Month,
    Confirmed AS MostFrequentConfirmed,
    Deaths AS MostFrequentDeaths,
    Recovered AS MostFrequentRecovered
FROM RankedValues
WHERE RankConfirmed = 1 OR RankDeaths = 1 OR RankRecovered = 1
ORDER BY Year, Month, RankConfirmed, RankDeaths, RankRecovered;

-- Q8. Find minimum values for confirmed, deaths, recovered per year

SELECT 
    YEAR(Date) AS Year,
    MIN(Confirmed) AS MinimumConfirmed,
    MIN(Deaths) AS MinimumDeaths,
    MIN(Recovered) AS MinimumRecovered
FROM [Corona Virus Dataset]
GROUP BY YEAR(Date)
ORDER BY Year;


-- Q9. Find maximum values of confirmed, deaths, recovered per year

SELECT 
    YEAR(Date) AS Year,
    MAX(Confirmed) AS MaximumConfirmed,
    MAX(Deaths) AS MaximumDeaths,
    MAX(Recovered) AS MaximumRecovered
FROM [Corona Virus Dataset]
GROUP BY YEAR(Date)
ORDER BY Year;

-- Q10. The total number of case of confirmed, deaths, recovered each month

SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    SUM(CAST(Confirmed AS INT)) AS TotalConfirmed,
    SUM(CAST(Deaths AS INT)) AS TotalDeaths,
    SUM(CAST(Recovered AS INT)) AS TotalRecovered
FROM [Corona Virus Dataset]
WHERE Confirmed IS NOT NULL AND Deaths IS NOT NULL AND Recovered IS NOT NULL
GROUP BY 
    YEAR(Date),
    MONTH(Date)
ORDER BY 
    Year,
    Month;

-- Q11. Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    COUNT(Confirmed) AS TotalCases,
    AVG(CAST(Confirmed AS FLOAT)) AS AverageCases,
    VAR(CAST(Confirmed AS FLOAT)) AS VarianceCases,
    STDEV(CAST(Confirmed AS FLOAT)) AS StdDevCases
FROM [Corona Virus Dataset]
WHERE Confirmed IS NOT NULL
GROUP BY 
    YEAR(Date),
    MONTH(Date)
ORDER BY 
    Year,
    Month;

-- Q12. Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    COUNT(Deaths) AS TotalDeaths,
    AVG(CAST(Deaths AS FLOAT)) AS AverageDeaths,
    VAR(CAST(Deaths AS FLOAT)) AS VarianceDeaths,
    STDEV(CAST(Deaths AS FLOAT)) AS StdDevDeaths
FROM [Corona Virus Dataset]
WHERE Deaths IS NOT NULL
GROUP BY 
    YEAR(Date),
    MONTH(Date)
ORDER BY 
    Year,
    Month;



-- Q13. Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )

SELECT 
    YEAR(Date) AS Year,
    MONTH(Date) AS Month,
    COUNT(Recovered) AS TotalRecovered,
    AVG(CAST(Recovered AS FLOAT)) AS AverageRecovered,
    VAR(CAST(Recovered AS FLOAT)) AS VarianceRecovered,
    STDEV(CAST(Recovered AS FLOAT)) AS StdDevRecovered
FROM [Corona Virus Dataset]
WHERE Recovered IS NOT NULL
GROUP BY 
    YEAR(Date),
    MONTH(Date)
ORDER BY 
    Year,
    Month;
-- Q14. Find Country having highest number of the Confirmed case

SELECT TOP 1 Country_Region, SUM(CAST(Confirmed AS INT)) AS TotalConfirmed
FROM [Corona Virus Dataset]
GROUP BY Country_Region
ORDER BY TotalConfirmed DESC;

-- Q15. Find Country having lowest number of the death case



SELECT TOP 1 Country_Region, SUM(CAST(Deaths AS INT)) AS TotalDeaths
FROM [Corona Virus Dataset]
GROUP BY Country_Region
ORDER BY TotalDeaths ASC;


-- Q16. Find top 5 countries having highest recovered case

SELECT TOP 5 Country_Region, SUM(CAST(Recovered AS INT)) AS TotalRecovered
FROM [Corona Virus Dataset]
GROUP BY Country_Region
ORDER BY TotalRecovered DESC;