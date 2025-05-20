--Using CTE's to get the average number of transactions per customer per month in different categories according to transaction volume.
WITH Frequency AS (
SELECT 
    a.id AS owner_id,
    FORMAT(b.transaction_date, 'MM-yyyy') AS MonthYear,
    COUNT(b.savings_id) AS customer_count,
    CASE 
        WHEN COUNT(b.savings_id) > 9 THEN 'High Frequency'
        WHEN COUNT(b.savings_id) BETWEEN 3 AND 9 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category
FROM [adashi_staging].[dbo].[users_customuser] a
JOIN [adashi_staging].[dbo].[savings_savingsaccount] b
    ON a.id = b.owner_id
GROUP BY a.id, FORMAT(b.transaction_date, 'MM-yyyy')),
Average AS(
SELECT frequency_category, customer_count, MonthYear,
AVG(customer_count) avg_transactions_per_month
FROM Frequency 
GROUP BY frequency_category, customer_count, MonthYear
)

SELECT frequency_category, customer_count, avg_transactions_per_month
FROM Average
