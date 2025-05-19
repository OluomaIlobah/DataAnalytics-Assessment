USE adashi_staging;

SHOW TABLES;

SELECT * FROM users_customuser;
SELECT * FROM savings_savingsaccount;
SELECT * FROM plans_plan;
SELECT * FROM withdrawals_withdrawal;

-- Question 4 --

-- Customer Lifetime Value (CLV) Estimation
-- Scenario: Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).
-- Task: For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
     -- Account tenure (months since signup)
     -- Total transactions
     -- Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
     -- Order by estimated CLV from highest to lowest


SELECT
    u.id AS customer_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    
    -- Account tenure in months, minimum 1 to avoid division by zero
    GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 1) AS tenure_months,
    
    -- Total number of transactions (confirmed_amount > 0) across savings accounts
    COUNT(s.id) AS total_transactions,
    
    -- Estimated CLV = (transactions/tenure)*12*avg_profit_per_transaction
    ROUND(
      (COUNT(s.id) / GREATEST(TIMESTAMPDIFF(MONTH, u.date_joined, CURDATE()), 1))* 12 * AVG(s.confirmed_amount / 100 * 0.001),2) AS estimated_clv

FROM users_customuser u
LEFT JOIN savings_savingsaccount s ON s.owner_id = u.id AND s.confirmed_amount > 0
GROUP BY u.id, u.first_name, u.last_name, u.date_joined
ORDER BY estimated_clv DESC;
