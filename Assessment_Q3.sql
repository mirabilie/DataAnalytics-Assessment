-- Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days)
WITH AccountActivity AS (
 SELECT a.id plan_id, b.owner_id owner_id,
 CASE 
 WHEN a.is_regular_savings = 1 THEN 'Savings' 
 ELSE 'Investment'
 END AS type,
 b.transaction_date AS last_transaction_date,
 DATEDIFF(DAY, b.transaction_date, GETDATE()) AS inactivity_days,
 ROW_NUMBER() OVER (
            PARTITION BY b.owner_id 
            ORDER BY b.transaction_date DESC
        ) AS rn
    FROM [adashi_staging].[dbo].[plans_plan] a
    LEFT JOIN [adashi_staging].[dbo].[savings_savingsaccount] b
        ON a.owner_id = b.owner_id
		WHERE a.is_a_fund = 1 or a.is_regular_savings = 1
)

SELECT plan_id, owner_id, type, last_transaction_date
FROM AccountActivity
WHERE last_transaction_date < DATEADD(DAY, -365, GETDATE())
  AND rn = 1;
