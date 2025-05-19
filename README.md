# DataAnalytics-Assessment

**Objective**

This evaluation is designed to measure my ability to work with relational databases by writing SQL queries to solve business problems. The assessment will tests my knowledge of data retrieval, aggregation, joins, subqueries, and data manipulation across multiple tables.

**Assessment Overview**

I was provided with a database containing the following tables:

- users_customuser: customer demographic and contact information
- savings_savingsaccount: records of deposit transactions
- plans_plan: records of plans created by customers
- withdrawals_withdrawal:  records of withdrawal transactions


Below are the assessment questions and thought-process in solving each:

1. **High-Value Customers with Multiple Products**
 
**Scenario:** The business wants to identify customers who have both a savings and an investment plan (cross-selling opportunity).

**Task:** Write a query to find customers with at least one funded savings plan AND one funded investment plan, sorted by total deposits.

**Tables:**
  - users_customuser
  - savings_savingsaccount
  - plans_plan

**My thought-process:**

  - The withdrawals summary w groups by owner_id and plan_id.
  - I joined back on matching owner_id and plan_id of the savings accounts.
  - Net funded amount per account = confirmed_amount - total_withdrawn (or 0 if no withdrawals).
  - I Counted savings and investment accounts per user where net funded amount is positive.
  - Filtered users who have both savings and investment accounts funded.
  - Ordered by total net deposits (converted from kobo to naira).

    
**2. Transaction Frequency Analysis**

**Scenario:** The finance team wants to analyze how often customers transact to segment them (e.g., frequent vs. occasional users).

**Task:** Calculate the average number of transactions per customer per month and categorize them:

   - "High Frequency" (≥10 transactions/month)
   - "Medium Frequency" (3-9 transactions/month)
   - "Low Frequency" (≤2 transactions/month)
     
**Tables Used:**
  - users_customuser
  - savings_savingsaccount

**My thought-process:**

 - I used the CTE (customer_frequency) to calculate each customer’s avg transactions/month and categorizes them.
 - Grouped the outer query by the categories and aggregates:
 - Numbered the customers per category
 - Average of customers’ avg transactions/month per category
 - Ordering ensured High, Medium, Low appears in that sequence.


**3. Account Inactivity Alert**
   
**Scenario:** The ops team wants to flag accounts with no inflow transactions for over one year.

**Task:** Find all active accounts (savings or investments) with no transactions in the last 1 year (365 days).

**Tables used:**

  - plans_plan
  - savings_savingsaccount

**My thought-process:**

 - Focused on savings accounts with actual inflows (confirmed_amount > 0).
 - To find the last inflow date per account.
 - Flaged accounts inactive for more than 365 days.
 - Focused on investment plans.
 - Used the latest created_on date as a proxy for activity since inflow amounts are unavailable.
 - Flaged plans inactive for over 365 days.
 - Used UNION to combine savings and investment results into one list.
 - Used DATEDIFF to calculate how many days since the last inflow or activity to measure inactivity.


**4. Customer Lifetime Value (CLV) Estimation**
   
**Scenario:** Marketing wants to estimate CLV based on account tenure and transaction volume (simplified model).

**Task: ** For each customer, assuming the profit_per_transaction is 0.1% of the transaction value, calculate:
           - Account tenure (months since signup)
           - Total transactions
           - Estimated CLV (Assume: CLV = (total_transactions / tenure) * 12 * avg_profit_per_transaction)
           - Order by estimated CLV from highest to lowest

**Tables:**

  - users_customuser
  - savings_savingsaccount


**My thought-process:**

  - users_customuser.date_joined is the signup date.
  - Each row in savings_savingsaccount with confirmed_amount > 0 counts as a transaction.
  - All amounts are in kobo; convert to naira by dividing by 100.
  - Profit per transaction = 0.1% (0.001) × transaction value.
  - Tenure in months calculated with TIMESTAMPDIFF(MONTH, signup, CURDATE()).
  - Customers with zero tenure (e.g., joined this month) will be handled to avoid division by zero.



**Please view MYSQL queries and outputs in the attached files.**









