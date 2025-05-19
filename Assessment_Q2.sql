USE adashi_staging;

SHOW TABLES;

SELECT * FROM users_customuser;
SELECT * FROM savings_savingsaccount;
SELECT * FROM plans_plan;
SELECT * FROM withdrawals_withdrawal;
    
    
-- Question 2 --
-- Transaction Frequency Analysis--
-- Scenario: The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).
-- Task: Calculate the average number of transactions per customer per month and categorize them:
    -- "High Frequency" (≥10 transactions/month)--
    -- "Medium Frequency" (3-9 transactions/month)--
    -- "Low Frequency" (≤2 transactions/month)--

    
    -- CTE to calculate per-customer transaction frequency and categorize them
WITH customer_frequency AS (
    SELECT
        u.id AS owner_id,
        CONCAT(u.first_name, ' ', u.last_name) AS name,
        COUNT(w.id) AS total_transactions,

        -- Calculate the active time span in months from the first to last transaction (add 1 to avoid zero)
        TIMESTAMPDIFF(MONTH, MIN(w.created_on), MAX(w.created_on)) + 1 AS active_months,

        -- Calculate the average number of transactions per month (rounded to 2 decimal places)
        ROUND(COUNT(w.id) / (TIMESTAMPDIFF(MONTH, MIN(w.created_on), MAX(w.created_on)) + 1), 2) AS avg_transactions_per_month,

        -- Categorize customer based on their average monthly transaction volume
        CASE
            WHEN ROUND(COUNT(w.id) / (TIMESTAMPDIFF(MONTH, MIN(w.created_on), MAX(w.created_on)) + 1), 2) >= 10 THEN 'High Frequency'
            WHEN ROUND(COUNT(w.id) / (TIMESTAMPDIFF(MONTH, MIN(w.created_on), MAX(w.created_on)) + 1), 2) BETWEEN 3 AND 9 THEN 'Medium Frequency'
            ELSE 'Low Frequency'
        END AS frequency_category
    FROM users_customuser u
    LEFT JOIN withdrawals_withdrawal w ON w.owner_id = u.id
    GROUP BY u.id, u.first_name, u.last_name
)

-- Final output: Group customers by frequency category and aggregate metrics
SELECT
    frequency_category,                   -- Frequency group (High, Medium, Low)
    COUNT(*) AS customer_count,        
    ROUND(AVG(avg_transactions_per_month), 2) AS avg_transactions_per_month  -- Avg. of avg. monthly transactions in that group
FROM customer_frequency
GROUP BY frequency_category
ORDER BY FIELD(frequency_category, 'High Frequency', 'Medium Frequency', 'Low Frequency');

