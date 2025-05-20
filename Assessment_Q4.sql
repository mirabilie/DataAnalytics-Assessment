--Displays the customerid, name, account tenure, transcation volume and CLV
SELECT a.id customer_id, (a.first_name + ' ' + a.last_name) AS name,
Datediff(month, b.maturity_start_date , b.maturity_end_date) tenure_months, 
COUNT(b.Savings_id) total_transactions, 
(b.confirmed_amount/Datediff(month, b.maturity_start_date , b.maturity_end_date)) * 12 * AVG(10/100 * b.confirmed_amount) estimated_clv
FROM
[adashi_staging].[dbo].[users_customuser] a
JOIN
[adashi_staging].[dbo].[savings_savingsaccount] b
ON a.id = b.owner_id
GROUP BY a.id , a.first_name, a.last_name, Datediff( month, b.maturity_start_date , b.maturity_end_date), b.confirmed_amount
ORDER BY (b.confirmed_amount/Datediff( month, b.maturity_start_date , b.maturity_end_date)) * 12 * AVG(10/100 * b.confirmed_amount) DESC
