USE adashi_staging;

SHOW TABLES;

SELECT * FROM users_customuser;
SELECT * FROM savings_savingsaccount;
SELECT * FROM plans_plan;
SELECT * FROM withdrawals_withdrawal;


-- Question 1:--
-- High-Value Customers with Multiple Products --
-- Scenario: The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity) --
-- Task: Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits --


SELECT
    u.id AS owner_id,
    CONCAT(u.first_name, ' ', u.last_name) AS name,
    SUM(CASE 
            WHEN p.is_regular_savings = 1 
                 AND (sa.confirmed_amount - IFNULL(w.total_withdrawn, 0)) > 0 
            THEN 1 ELSE 0 END) AS savings_count,
    SUM(CASE 
            WHEN p.is_a_fund = 1 
                 AND (sa.confirmed_amount - IFNULL(w.total_withdrawn, 0)) > 0 
            THEN 1 ELSE 0 END) AS investment_count,
    ROUND(SUM(sa.confirmed_amount - IFNULL(w.total_withdrawn, 0)) / 100.0, 2) AS total_deposits
FROM
    users_customuser u
JOIN
    savings_savingsaccount sa ON sa.owner_id = u.id
JOIN
    plans_plan p ON sa.plan_id = p.id
LEFT JOIN
    (
      SELECT owner_id, plan_id, SUM(amount_withdrawn) AS total_withdrawn
      FROM withdrawals_withdrawal
      GROUP BY owner_id, plan_id
    ) w ON w.owner_id = sa.owner_id AND w.plan_id = sa.plan_id
GROUP BY
    u.id, u.first_name, u.last_name
HAVING
    savings_count > 0
    AND investment_count > 0
ORDER BY
    total_deposits DESC;
