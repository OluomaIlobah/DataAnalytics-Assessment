USE adashi_staging;

SHOW TABLES;

SELECT * FROM users_customuser;
SELECT * FROM savings_savingsaccount;
SELECT * FROM plans_plan;
SELECT * FROM withdrawals_withdrawal;


-- Question 3 --

-- Account Inactivity Alert
-- Scenario: The ops team wants to flag accounts with no inflow transactions for over one year.
-- Task: Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days) .


-- Inactive savings accounts based on confirmed_amount inflow in savings_savingsaccount
SELECT
    s.id AS plan_id,
    s.owner_id,
    'Savings' AS type,
    MAX(s.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(s.created_on)) AS inactivity_days
FROM savings_savingsaccount s
WHERE s.confirmed_amount > 0
GROUP BY s.id, s.owner_id
HAVING MAX(s.created_on) < CURDATE() - INTERVAL 365 DAY

UNION

-- Inactive investment plans based on plans_plan created_on (no confirmed_amount available)
SELECT
    p.id AS plan_id,
    p.owner_id,
    'Investment' AS type,
    MAX(p.created_on) AS last_transaction_date,
    DATEDIFF(CURDATE(), MAX(p.created_on)) AS inactivity_days
FROM plans_plan p
GROUP BY p.id, p.owner_id
HAVING MAX(p.created_on) < CURDATE() - INTERVAL 365 DAY;
