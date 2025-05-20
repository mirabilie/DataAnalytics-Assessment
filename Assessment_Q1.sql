-- Customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.
SELECT a.id AS owner_id, (a.first_name + ' ' + a.last_name) AS name, COUNT(DISTINCT b.savings_id) AS savings_count,COUNT(DISTINCT c.is_a_fund) AS investment_count, 
SUM(b.amount) AS total_deposits
FROM [adashi_staging].[dbo].[users_customuser] a
JOIN [adashi_staging].[dbo].[savings_savingsaccount] b
ON a.id = b.owner_id
JOIN [adashi_staging].[dbo].[plans_plan] c
ON a.id = c.owner_id
WHERE c.is_a_fund = 1 and is_regular_savings = 1
GROUP BY a.id, a.first_name, a.last_name
ORDER BY total_deposits DESC