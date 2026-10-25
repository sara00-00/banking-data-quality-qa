
-- ============================================================
-- Banking Data Quality & Reconciliation QA
-- Database: SQLite
-- Purpose: Validate data quality and identify anomalies
-- ============================================================

-- 1. Database Overview
-- Count the number of records in each major table.

SELECT 'customers' AS table_name, COUNT(*) AS row_count
FROM customers
UNION ALL
SELECT 'accounts', COUNT(*) FROM accounts
UNION ALL
SELECT 'transactions', COUNT(*) FROM transactions
UNION ALL
SELECT 'cards', COUNT(*) FROM cards
UNION ALL
SELECT 'transfers', COUNT(*) FROM transfers
UNION ALL
SELECT 'bill_payments', COUNT(*) FROM bill_payments
UNION ALL
SELECT 'loans', COUNT(*) FROM loans
UNION ALL
SELECT 'loan_payments', COUNT(*) FROM loan_payments;


-- 2. Customer Completeness Check
-- Identify customers with missing required information.

SELECT *
FROM customers
WHERE email IS NULL OR TRIM(email) = ''
   OR first_name IS NULL OR TRIM(first_name) = ''
   OR last_name IS NULL OR TRIM(last_name) = '';


-- 3. Duplicate Customer Emails Check
-- Detect duplicate emails after case and whitespace normalization.

SELECT LOWER(TRIM(email)) AS normalized_email,
       COUNT(*) AS duplicate_count
FROM customers
WHERE email IS NOT NULL
  AND TRIM(email) <> ''
GROUP BY LOWER(TRIM(email))
HAVING COUNT(*) > 1;


-- 4. Account Referential Integrity Check
-- Identify accounts referencing nonexistent customers.

SELECT a.id AS account_id,
       a.customer_id
FROM accounts AS a
LEFT JOIN customers AS c
    ON a.customer_id = c.id
WHERE c.id IS NULL;


-- 5. Branch Referential Integrity Check
-- Identify accounts referencing nonexistent branches.

SELECT a.id AS account_id,
       a.branch_id
FROM accounts AS a
LEFT JOIN branches AS b
    ON a.branch_id = b.id
WHERE b.id IS NULL;


-- 6. Account Number Uniqueness Check
-- Identify duplicate account numbers.

SELECT account_number,
       COUNT(*) AS duplicate_count
FROM accounts
WHERE account_number IS NOT NULL
GROUP BY account_number
HAVING COUNT(*) > 1;


-- 7. Transaction Referential Integrity Check
-- Identify transactions referencing nonexistent accounts.

SELECT t.id AS transaction_id,
       t.account_id
FROM transactions AS t
LEFT JOIN accounts AS a
    ON t.account_id = a.id
WHERE a.id IS NULL;


-- 8. Transaction Amount Validation
-- Identify transactions with non-positive amounts.

SELECT id,
       account_id,
       amount,
       type
FROM transactions
WHERE amount IS NULL OR amount <= 0;


-- 9. Transaction Type Profiling
-- Summarize the observed transaction types.

SELECT type,
       COUNT(*) AS transaction_count,
       MIN(amount) AS minimum_amount,
       MAX(amount) AS maximum_amount
FROM transactions
GROUP BY type
ORDER BY type;


-- 10. Duplicate Card Numbers Check
-- Count repeated card-number groups without exposing card numbers.

SELECT COUNT(*) AS duplicate_groups
FROM (
    SELECT card_number
    FROM cards
    WHERE card_number IS NOT NULL
    GROUP BY card_number
    HAVING COUNT(*) > 1
);


-- 11. Standing Orders with Past Next-Run Dates
-- Identify records requiring scheduling review.

SELECT id,
       next_run_date
FROM standing_orders
WHERE next_run_date IS NOT NULL
  AND DATE(next_run_date) < DATE('now')
ORDER BY next_run_date;


-- 12. Account Balance Reconciliation
-- Assumptions:
-- 1. Opening balance is zero.
-- 2. Transaction history is complete.
-- 3. Deposits and interest increase balances.
-- 4. Withdrawals and fees decrease balances.

WITH transaction_totals AS (
    SELECT
        account_id,
        SUM(
            CASE
                WHEN LOWER(TRIM(type)) IN ('deposit', 'interest')
                    THEN amount
                WHEN LOWER(TRIM(type)) IN ('withdrawal', 'fee')
                    THEN -amount
                ELSE 0
            END
        ) AS calculated_balance
    FROM transactions
    GROUP BY account_id
)
SELECT
    a.id AS account_id,
    a.balance AS recorded_balance,
    COALESCE(tt.calculated_balance, 0) AS calculated_balance,
    ROUND(
        a.balance - COALESCE(tt.calculated_balance, 0),
        2
    ) AS difference
FROM accounts AS a
LEFT JOIN transaction_totals AS tt
    ON a.id = tt.account_id
WHERE ABS(
    ROUND(
        a.balance - COALESCE(tt.calculated_balance, 0),
        2
    )
) > 0.01
ORDER BY a.id;


