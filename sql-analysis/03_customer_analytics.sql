--PHASE 3  Customer Analytics
--Section A  Customer Demographics
--1. Total Customers
SELECT COUNT(*) AS total_customers
FROM customers;

--Customer gender dustribution
SELECT
    gender,
    COUNT(*) AS customer_count
FROM customers
GROUP BY gender
ORDER BY customer_count DESC;

--Customer age profile
SELECT
    MIN(age) AS minimum_age,
    MAX(age) AS maximum_age,
    ROUND(AVG(age), 1) AS average_age
FROM customers;
--age groups
SELECT
    CASE
        WHEN age < 25 THEN 'Under 25'
        WHEN age BETWEEN 25 AND 34 THEN '25-34'
        WHEN age BETWEEN 35 AND 44 THEN '35-44'
        WHEN age BETWEEN 45 AND 54 THEN '45-54'
        ELSE '55+'
    END AS age_group,
    COUNT(*) AS customer_count
FROM customers
GROUP BY age_group
ORDER BY customer_count DESC;

--Section B Customer Segmentation
--4. Customers by Segment
SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM customers
GROUP BY customer_segment
ORDER BY customer_count DESC;

--5 Avg income by customer segment
SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(AVG(annual_income), 2) AS average_income
FROM customers
GROUP BY customer_segment
ORDER BY average_income DESC;

--6 Income range by segment
SELECT
    customer_segment,
    MIN(annual_income) AS minimum_income,
    MAX(annual_income) AS maximum_income,
    ROUND(AVG(annual_income), 2) AS average_income
FROM customers
GROUP BY customer_segment
ORDER BY average_income DESC;

--Sectoin C Geographic Analytics
--7. Customers by Region
SELECT
    region,
    COUNT(*) AS customer_count
FROM customers
GROUP BY region
ORDER BY customer_count DESC;

--8 Average Income by Region

SELECT
    region,

    COUNT(*) AS customer_count,

    ROUND(
        AVG(annual_income),
        2
    ) AS average_income

FROM customers

GROUP BY region

ORDER BY average_income DESC;

--9 Cities with the most customer
SELECT
    city,
    region,
    COUNT(*) AS customer_count
FROM customers
GROUP BY city, region
ORDER BY customer_count DESC
LIMIT 10;

--Section D  Employment Analytics
-- 10 Customers by Employment Status
SELECT
    employment_status,
    COUNT(*) AS customer_count
FROM customers
GROUP BY employment_status
ORDER BY customer_count DESC;

--Income by employement status
SELECT
    employment_status,
    COUNT(*) AS customer_count,
    ROUND(AVG(annual_income), 2) AS average_income
FROM customers
GROUP BY employment_status
ORDER BY average_income DESC;

--Section E Customer Banking Relationship
--12 Customer with account
SELECT
    COUNT(DISTINCT c.customer_id) AS customers_with_accounts
FROM customers AS c
INNER JOIN accounts AS a
    ON c.customer_id = a.customer_id;

--13 Customers with Multiple Accounts
SELECT
    customer_id,
    COUNT(account_id) AS account_count
FROM accounts
GROUP BY customer_id
HAVING COUNT(account_id) > 1
ORDER BY account_count DESC;

--14. How Many Customers Have Multiple Accounts?
SELECT COUNT(*) AS customers_with_multiple_accounts
FROM (
    SELECT
        customer_id
    FROM accounts
    GROUP BY customer_id
    HAVING COUNT(account_id) > 1
) AS multiple_accounts;

--15 customers without any account
SELECT
    c.customer_id,
    c.customer_segment,
    c.region
FROM customers AS c
LEFT JOIN accounts AS a
    ON c.customer_id = a.customer_id
WHERE a.customer_id IS NULL;

--Section F Account Status
--16 Account Status Distribution
SELECT
    account_status,
    COUNT(*) AS account_count
FROM accounts
GROUP BY account_status
ORDER BY account_count DESC;

--Account type distribution
SELECT
    account_type,
    COUNT(*) AS account_count
FROM accounts
GROUP BY account_type
ORDER BY account_count DESC;

--18 account balance by account type
SELECT
    account_type,
    COUNT(*) AS account_count,
    ROUND(SUM(account_balance), 2) AS total_balance,
    ROUND(AVG(account_balance), 2) AS average_balance
FROM accounts
GROUP BY account_type
ORDER BY total_balance DESC;

--Section G Customer Value
--19 customer banking value
SELECT
    c.customer_id,
    c.customer_segment,
    c.region,
    c.annual_income,
    COUNT(a.account_id) AS account_count,
    ROUND(SUM(a.account_balance), 2) AS total_account_balance
FROM customers AS c
LEFT JOIN accounts AS a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.customer_segment,
    c.region,
    c.annual_income
ORDER BY total_account_balance DESC;

--20 high value customers
SELECT
    c.customer_id,
    c.customer_segment,
    c.region,
    ROUND(SUM(a.account_balance), 2) AS total_account_balance
FROM customers AS c
INNER JOIN accounts AS a
    ON c.customer_id = a.customer_id
GROUP BY
    c.customer_id,
    c.customer_segment,
    c.region
HAVING SUM(a.account_balance) > 1000000
ORDER BY total_account_balance DESC;

--Section H Customer Since / Tenure
--21 customers by join year
SELECT
    EXTRACT(YEAR FROM customer_since) AS join_year,
    COUNT(*) AS customer_count
FROM customers
GROUP BY join_year
ORDER BY join_year;

--22 Customer Acquisition Trend
SELECT
    DATE_TRUNC('year', customer_since) AS join_year,
    COUNT(*) AS new_customers
FROM customers
GROUP BY join_year
ORDER BY join_year;

--Section 1 Customer Segment + Region
--23 Segment Distribution by Region
SELECT
    region,
    customer_segment,
    COUNT(*) AS customer_count
FROM customers
GROUP BY
    region,
    customer_segment
ORDER BY
    region,
    customer_count DESC;

--24 High-Income Customers by Segment
SELECT
    customer_segment,
    COUNT(*) AS high_income_customers
FROM customers
WHERE annual_income > 1000000
GROUP BY customer_segment
ORDER BY high_income_customers DESC;

--Section J  EXISTS
--Customers who have at least one loan
SELECT
    c.customer_id,
    c.customer_segment,
    c.region
FROM customers AS c
WHERE EXISTS (
    SELECT 1
    FROM loans AS l
    WHERE l.customer_id = c.customer_id
);

--25 customers without any loan
SELECT
    c.customer_id,
    c.customer_segment,
    c.region
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM loans AS l
    WHERE l.customer_id = c.customer_id
);

--counting customers without loan
SELECT COUNT(*) AS customers_without_loans
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM loans AS l
    WHERE l.customer_id = c.customer_id
);