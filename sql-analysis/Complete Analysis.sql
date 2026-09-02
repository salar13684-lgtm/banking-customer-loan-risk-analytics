--Schema And Setup
CREATE TABLE customers (
    customer_id VARCHAR(20),
    age INT,
    gender VARCHAR(20),
    employment_status VARCHAR(50),
    annual_income NUMERIC(15,2),
    customer_segment VARCHAR(50),
    city VARCHAR(100),
    region VARCHAR(100),
    customer_since DATE
);

CREATE TABLE accounts (
    account_id VARCHAR(20),
    customer_id VARCHAR(20),
    account_type VARCHAR(50),
    account_status VARCHAR(30),
    account_balance NUMERIC(15,2),
    opened_date DATE
);

CREATE TABLE loans (
    loan_id VARCHAR(20),
    customer_id VARCHAR(20),
    loan_type VARCHAR(50),
    loan_amount NUMERIC(15,2),
    outstanding_amount NUMERIC(15,2),
    interest_rate NUMERIC(5,2),
    loan_term_months INT,
    loan_status VARCHAR(30),
    application_date DATE,
    disbursement_date DATE,
    maturity_date DATE
);

CREATE TABLE loan_applications (
    application_id VARCHAR(20),
    customer_id VARCHAR(20),
    loan_id VARCHAR(20),
    loan_type VARCHAR(50),
    requested_amount NUMERIC(15,2),
    application_date DATE,
    decision_date DATE,
    application_status VARCHAR(30)
);

CREATE TABLE loan_payments (
    payment_id VARCHAR(20),
    loan_id VARCHAR(20),
    payment_date DATE,
    payment_amount NUMERIC(15,2),
    payment_status VARCHAR(30),
    days_late INT
);

--02 Data Exploration And Quality
--Row Count Audit
SELECT COUNT(*) AS total_customers
FROM customers;

SELECT COUNT(*) AS total_accounts
FROM accounts;

SELECT COUNT(*) AS total_loans
FROM loans;

SELECT COUNT(*) AS total_applications
FROM loan_applications;

SELECT COUNT(*) AS total_payments
FROM loan_payments;

--Inspecting the Actual Data
--Customers
SELECT *
FROM customers
LIMIT 10;

--Accounts
SELECT *
FROM accounts
LIMIT 10;

--Loans
SELECT *
FROM loans
LIMIT 10;

--Applications
SELECT *
FROM loan_applications
LIMIT 10;

--Payments
SELECT *
FROM loan_payments
LIMIT 10;

--Exploring Columns
SELECT DISTINCT region
FROM customers
ORDER BY region;

--Customer Segments 
SELECT DISTINCT customer_segment
FROM customers
ORDER BY customer_segment ;

--Employement Status
SELECT DISTINCT employment_status
FROM customers
ORDER BY employment_status;

--Account types
SELECT DISTINCT account_type
FROM accounts
ORDER BY account_type;

--Loan Types
SELECT DISTINCT loan_type
FROM loans
ORDER BY loan_type;

--Loan Status
SELECT DISTINCT loan_status
FROM loans
ORDER BY loan_status;

--Application Statuses
SELECT DISTINCT application_status
FROM loan_applications
ORDER BY application_status;

--Payment Statuses
SELECT DISTINCT payment_status
FROM loan_payments
ORDER BY payment_status;

--NULL / Missing-Value Audit
SELECT
    COUNT(*) AS total_rows,
    COUNT(customer_id) AS customer_id_present,
    COUNT(age) AS age_present,
    COUNT(gender) AS gender_present,
    COUNT(employment_status) AS employment_present,
    COUNT(annual_income) AS income_present,
    COUNT(customer_segment) AS segment_present,
    COUNT(city) AS city_present,
    COUNT(region) AS region_present,
    COUNT(customer_since) AS customer_since_present
FROM customers;

-- Applications NULL Audit
SELECT
    COUNT(*) AS total_rows,
    COUNT(application_id) AS application_id_present,
    COUNT(customer_id) AS customer_id_present,
    COUNT(loan_id) AS loan_id_present,
    COUNT(loan_type) AS loan_type_present,
    COUNT(requested_amount) AS requested_amount_present,
    COUNT(application_date) AS application_date_present,
    COUNT(decision_date) AS decision_date_present,
    COUNT(application_status) AS application_status_present
FROM loan_applications;

--Accounts Null Audit
SELECT
    COUNT(*) AS total_rows,
    COUNT(account_id) AS account_id_present,
    COUNT(customer_id) AS customer_id_present,
    COUNT(account_type) AS account_type_present,
    COUNT(account_status) AS account_status_present,
    COUNT(account_balance) AS balance_present,
    COUNT(opened_date) AS opened_date_present
FROM accounts;

--Loans Null Audit
SELECT
    COUNT(*) AS total_rows,
    COUNT(loan_id) AS loan_id_present,
    COUNT(customer_id) AS customer_id_present,
    COUNT(loan_type) AS loan_type_present,
    COUNT(loan_amount) AS loan_amount_present,
    COUNT(outstanding_amount) AS outstanding_present,
    COUNT(interest_rate) AS interest_rate_present,
    COUNT(loan_term_months) AS term_present,
    COUNT(loan_status) AS status_present,
    COUNT(application_date) AS application_date_present,
    COUNT(disbursement_date) AS disbursement_date_present,
    COUNT(maturity_date) AS maturity_date_present
FROM loans;

-- Payments NULL Audit
SELECT
    COUNT(*) AS total_rows,
    COUNT(payment_id) AS payment_id_present,
    COUNT(loan_id) AS loan_id_present,
    COUNT(payment_date) AS payment_date_present,
    COUNT(payment_amount) AS payment_amount_present,
    COUNT(payment_status) AS payment_status_present,
    COUNT(days_late) AS days_late_present
FROM loan_payments;

-- Payment amount sanity check
SELECT
    MIN(payment_amount) AS minimum_payment,
    MAX(payment_amount) AS maximum_payment,
    ROUND(AVG(payment_amount), 2) AS average_payment
FROM loan_payments;

SELECT *
FROM loan_payments
WHERE payment_amount < 0;

--Duplicate ID Audit
--Customers
SELECT
    customer_id,
    COUNT(*) AS occurrence_count
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

--Account
SELECT
    account_id,
    COUNT(*) AS occurrence_count
FROM accounts
GROUP BY account_id
HAVING COUNT(*) > 1;

--Loans
SELECT
    loan_id,
    COUNT(*) AS occurrence_count
FROM loans
GROUP BY loan_id
HAVING COUNT(*) > 1;

--Applications
SELECT
    application_id,
    COUNT(*) AS occurrence_count
FROM loan_applications
GROUP BY application_id
HAVING COUNT(*) > 1;

--Payments
SELECT
    payment_id,
    COUNT(*) AS occurrence_count
FROM loan_payments
GROUP BY payment_id
HAVING COUNT(*) > 1;

--Check days late
SELECT
    MIN(days_late) AS minimum_days_late,
    MAX(days_late) AS maximum_days_late,
    ROUND(AVG(days_late), 2) AS average_days_late
FROM loan_payments;

SELECT *
FROM loan_payments
WHERE days_late < 0;

--Relationship / Orphan Checks
-- Accounts without a customer
SELECT
    a.account_id,
    a.customer_id
FROM accounts AS a
LEFT JOIN customers AS c
    ON a.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Approved applications without a corresponding loan
SELECT
    la.application_id,
    la.customer_id,
    la.loan_id
FROM loan_applications AS la
LEFT JOIN loans AS l
    ON la.loan_id = l.loan_id
WHERE la.application_status = 'Approved'
  AND l.loan_id IS NULL;

--loans without a customer
SELECT
    l.loan_id,
    l.customer_id
FROM loans AS l
LEFT JOIN customers AS c
    ON l.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

--applications without a customer
SELECT
    la.application_id,
    la.customer_id
FROM loan_applications AS la
LEFT JOIN customers AS c
    ON la.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

--Patments without a loan
SELECT
    lp.payment_id,
    lp.loan_id
FROM loan_payments AS lp
LEFT JOIN loans AS l
    ON lp.loan_id = l.loan_id
WHERE l.loan_id IS NULL;

--Numeric Sanity Checks
--customer income
SELECT
    MIN(annual_income) AS minimum_income,
    MAX(annual_income) AS maximum_income,
    ROUND(AVG(annual_income), 2) AS average_income
FROM customers;

--loan amount
SELECT
    MIN(loan_amount) AS minimum_loan,
    MAX(loan_amount) AS maximum_loan,
    ROUND(AVG(loan_amount), 2) AS average_loan
FROM loans;

--outstanding amount
SELECT
    MIN(outstanding_amount) AS minimum_outstanding,
    MAX(outstanding_amount) AS maximum_outstanding,
    ROUND(AVG(outstanding_amount), 2) AS average_outstanding
FROM loans;

--intrest rate
SELECT
    MIN(interest_rate) AS minimum_rate,
    MAX(interest_rate) AS maximum_rate,
    ROUND(AVG(interest_rate), 2) AS average_rate
FROM loans;

--Outstanding Amount > Original Loan
SELECT
    loan_id,
    loan_amount,
    outstanding_amount
FROM loans
WHERE outstanding_amount > loan_amount;

--Date Quality
--Disbursement before maturity?
SELECT *
FROM loans
WHERE disbursement_date > maturity_date;

--Payment Date Validation
SELECT
    lp.payment_id,
    lp.loan_id,
    lp.payment_date,
    l.disbursement_date
FROM loan_payments AS lp
INNER JOIN loans AS l
    ON lp.loan_id = l.loan_id
WHERE lp.payment_date < l.disbursement_date;

--customers by segment 
SELECT
    customer_segment,
    COUNT(*) AS customer_count
FROM customers
GROUP BY customer_segment
ORDER BY customer_count DESC;

--loans by type
SELECT
    loan_type,
    COUNT(*) AS loan_count
FROM loans
GROUP BY loan_type
ORDER BY loan_count DESC;

--loans by status
SELECT
    loan_status,
    COUNT(*) AS loan_count
FROM loans
GROUP BY loan_status
ORDER BY loan_count DESC;

--applicaton by status
SELECT
    application_status,
    COUNT(*) AS application_count
FROM loan_applications
GROUP BY application_status
ORDER BY application_count DESC;

--payment by status
SELECT
    payment_status,
    COUNT(*) AS payment_count
FROM loan_payments
GROUP BY payment_status
ORDER BY payment_count DESC;

--Final checking sumamry
--row counts
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM accounts;
SELECT COUNT(*) FROM loans;
SELECT COUNT(*) FROM loan_applications;
SELECT COUNT(*) FROM loan_payments;

--DISTINCT categories
SELECT DISTINCT region FROM customers ORDER BY region;

SELECT DISTINCT customer_segment
FROM customers
ORDER BY customer_segment;

SELECT DISTINCT loan_type
FROM loans
ORDER BY loan_type;

SELECT DISTINCT loan_status
FROM loans
ORDER BY loan_status;

--duplicate check
SELECT customer_id, COUNT(*)
FROM customers
GROUP BY customer_id
HAVING COUNT(*) > 1;

--relationship check
SELECT l.loan_id, l.customer_id
FROM loans AS l
LEFT JOIN customers AS c
    ON l.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

--financial sanity
SELECT *
FROM loans
WHERE outstanding_amount > loan_amount;

--loan sanity check
SELECT
    loan_id,
    loan_amount,
    outstanding_amount
FROM loans
WHERE outstanding_amount < 0;

--loan amount it self
SELECT
    loan_id,
    loan_amount
FROM loans
WHERE loan_amount <= 0;

--Application → Disbursement
SELECT *
FROM loans
WHERE application_date > disbursement_date;

--Application → Decision
SELECT *
FROM loan_applications
WHERE application_date > decision_date;

--Payment → Disbursement
SELECT
    lp.payment_id,
    lp.loan_id,
    lp.payment_date,
    l.disbursement_date
FROM loan_payments AS lp
INNER JOIN loans AS l
    ON lp.loan_id = l.loan_id
WHERE lp.payment_date < l.disbursement_date;

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

--phase 4 Loan Portfolio Analytics
--1 Total number of loans
SELECT
    COUNT(*) AS total_loans
FROM loans;

--2 Total loan amount
SELECT
    ROUND(SUM(loan_amount), 2) AS total_loan_amount
FROM loans;

--3 Total outstanding exposure
SELECT
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding_exposure
FROM loans;

--4 Average loan amount
SELECT
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans;

--5 minimun and maximum loan
SELECT
    MIN(loan_amount) AS minimum_loan_amount,
    MAX(loan_amount) AS maximum_loan_amount,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans;

--6 Portfolio Summary  One Dashboard Query
SELECT
    COUNT(*) AS total_loans,
    ROUND(SUM(loan_amount), 2) AS total_loan_amount,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding_exposure,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount,
    ROUND(AVG(interest_rate), 2) AS average_interest_rate
FROM loans;

--Loan amount by type
SELECT
    loan_type,
    COUNT(*) AS loan_count
FROM loans
GROUP BY loan_type
ORDER BY loan_count DESC;

--9 Outstanding exposure by loan type
SELECT
    loan_type,
    COUNT(*) AS loan_count,
    ROUND(SUM(outstanding_amount), 2) AS outstanding_exposure,
    ROUND(AVG(outstanding_amount), 2) AS average_outstanding
FROM loans
GROUP BY loan_type
ORDER BY outstanding_exposure DESC;

--10 loan status distribution
SELECT
    loan_status,
    COUNT(*) AS loan_count
FROM loans
GROUP BY loan_status
ORDER BY loan_count DESC;

--11 Loan Amount by Status
SELECT
    loan_status,
    COUNT(*) AS loan_count,
    ROUND(SUM(loan_amount), 2) AS total_loan_amount,
    ROUND(SUM(outstanding_amount), 2) AS outstanding_exposure,
    ROUND(AVG(outstanding_amount), 2) AS average_outstanding
FROM loans
GROUP BY loan_status
ORDER BY outstanding_exposure DESC;

--12 Outstanding Exposure Percentage
SELECT
    loan_status,
    ROUND(SUM(outstanding_amount), 2) AS outstanding_exposure,
    ROUND(
        SUM(outstanding_amount) * 100.0 /
        (SELECT SUM(outstanding_amount) FROM loans),
        2
    ) AS exposure_percentage
FROM loans
GROUP BY loan_status
ORDER BY exposure_percentage DESC;

--Loan status by loan type
SELECT
    loan_type,
    loan_status,
    COUNT(*) AS loan_count
FROM loans
GROUP BY
    loan_type,
    loan_status
ORDER BY
    loan_type,
    loan_count DESC;

--14 Average Interest Rate by Loan Typ
SELECT
    loan_type,
    COUNT(*) AS loan_count,
    ROUND(AVG(interest_rate), 2) AS average_interest_rate
FROM loans
GROUP BY loan_type
ORDER BY average_interest_rate DESC;

--15 Loan term analysis
SELECT
    loan_term_months,
    COUNT(*) AS loan_count,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount,
    ROUND(SUM(outstanding_amount), 2) AS outstanding_exposure
FROM loans
GROUP BY loan_term_months
ORDER BY loan_term_months;

--16 regional loan portfolio
SELECT
    c.region,
    COUNT(l.loan_id) AS loan_count,
    ROUND(SUM(l.loan_amount), 2) AS total_loan_amount,
    ROUND(SUM(l.outstanding_amount), 2) AS outstanding_exposure
FROM customers AS c
INNER JOIN loans AS l
    ON c.customer_id = l.customer_id
GROUP BY c.region
ORDER BY outstanding_exposure DESC;

--17. Average Loan by Region
SELECT
    c.region,
    COUNT(l.loan_id) AS loan_count,
    ROUND(AVG(l.loan_amount), 2) AS average_loan_amount,
    ROUND(AVG(l.outstanding_amount), 2) AS average_outstanding
FROM customers AS c
INNER JOIN loans AS l
    ON c.customer_id = l.customer_id
GROUP BY c.region
ORDER BY average_loan_amount DESC;

--19 loan portfolio by customer segment
SELECT
    c.customer_segment,
    COUNT(l.loan_id) AS loan_count,
    ROUND(SUM(l.loan_amount), 2) AS total_loan_amount,
    ROUND(SUM(l.outstanding_amount), 2) AS outstanding_exposure,
    ROUND(AVG(l.loan_amount), 2) AS average_loan_amount
FROM customers AS c
INNER JOIN loans AS l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_segment
ORDER BY outstanding_exposure DESC;

--20 Customer loan concentration
SELECT
    customer_id,
    COUNT(loan_id) AS loan_count,
    ROUND(SUM(loan_amount), 2) AS total_borrowed,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding
FROM loans
GROUP BY customer_id
HAVING COUNT(loan_id) > 1
ORDER BY total_outstanding DESC;

--20 Top 10 borrowers
SELECT
    customer_id,
    COUNT(loan_id) AS loan_count,
    ROUND(SUM(loan_amount), 2) AS total_borrowed,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding
FROM loans
GROUP BY customer_id
ORDER BY total_outstanding DESC
LIMIT 10;

--21 Top Borrowers With Customer Information
SELECT
    c.customer_id,
    c.customer_segment,
    c.region,
    COUNT(l.loan_id) AS loan_count,
    ROUND(SUM(l.loan_amount), 2) AS total_borrowed,
    ROUND(SUM(l.outstanding_amount), 2) AS total_outstanding
FROM customers AS c
INNER JOIN loans AS l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.customer_segment,
    c.region
ORDER BY total_outstanding DESC
LIMIT 10;

--22 Customers with no loans
SELECT
    c.customer_segment,
    COUNT(*) AS customers_without_loans
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM loans AS l
    WHERE l.customer_id = c.customer_id
)
GROUP BY c.customer_segment
ORDER BY customers_without_loans DESC;

--23 loan penetration by customer segment
SELECT
    c.customer_segment,
    COUNT(*) AS total_customers,
    COUNT(
        CASE
            WHEN EXISTS (
                SELECT 1
                FROM loans AS l
                WHERE l.customer_id = c.customer_id
            )
            THEN 1
        END
    ) AS customers_with_loans,
    ROUND(
        COUNT(
            CASE
                WHEN EXISTS (
                    SELECT 1
                    FROM loans AS l
                    WHERE l.customer_id = c.customer_id
                )
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS loan_penetration_percentage
FROM customers AS c
GROUP BY c.customer_segment
ORDER BY loan_penetration_percentage DESC;

--24 Monthly loan Disbursement Trend
SELECT
    DATE_TRUNC('month', disbursement_date) AS disbursement_month,
    COUNT(*) AS loan_count,
    ROUND(SUM(loan_amount), 2) AS total_disbursed
FROM loans
GROUP BY disbursement_month
ORDER BY disbursement_month;

--25 Monthly outstanding exposure
SELECT
    DATE_TRUNC('month', disbursement_date) AS disbursement_month,
    ROUND(SUM(outstanding_amount), 2) AS outstanding_exposure
FROM loans
GROUP BY disbursement_month
ORDER BY disbursement_month;

--26 Loan Growth using LAG
WITH monthly_loans AS (
    SELECT
        DATE_TRUNC('month', disbursement_date) AS month,
        SUM(loan_amount) AS total_disbursed
    FROM loans
    GROUP BY DATE_TRUNC('month', disbursement_date)
)
SELECT
    month,
    ROUND(total_disbursed, 2) AS total_disbursed,
    ROUND(
        LAG(total_disbursed) OVER (
            ORDER BY month
        ),
        2
    ) AS previous_month_disbursed
FROM monthly_loans
ORDER BY month;

--27 Monthly growth percentage
WITH monthly_loans AS (
    SELECT
        DATE_TRUNC('month', disbursement_date) AS month,
        SUM(loan_amount) AS total_disbursed
    FROM loans
    GROUP BY DATE_TRUNC('month', disbursement_date)
),
monthly_comparison AS (
    SELECT
        month,
        total_disbursed,
        LAG(total_disbursed) OVER (
            ORDER BY month
        ) AS previous_month_disbursed
    FROM monthly_loans
)
SELECT
    month,
    ROUND(total_disbursed, 2) AS total_disbursed,
    ROUND(previous_month_disbursed, 2) AS previous_month_disbursed,
    ROUND(
        (total_disbursed - previous_month_disbursed)
        * 100.0
        / NULLIF(previous_month_disbursed, 0),
        2
    ) AS monthly_growth_percentage
FROM monthly_comparison
ORDER BY month;

--28 rank loan types by outstanding exposure
SELECT
    loan_type,
    ROUND(SUM(outstanding_amount), 2) AS outstanding_exposure,
    RANK() OVER (
        ORDER BY SUM(outstanding_amount) DESC
    ) AS exposure_rank
FROM loans
GROUP BY loan_type
ORDER BY exposure_rank;

--29 rank regions by loan exposure
SELECT
    c.region,
    ROUND(SUM(l.outstanding_amount), 2) AS outstanding_exposure,
    RANK() OVER (
        ORDER BY SUM(l.outstanding_amount) DESC
    ) AS exposure_rank
FROM customers AS c
INNER JOIN loans AS l
    ON c.customer_id = l.customer_id
GROUP BY c.region
ORDER BY exposure_rank;

--30. Final Portfolio Query  Dashboard KPI Dataset
SELECT
    COUNT(*) AS total_loans,
    COUNT(DISTINCT customer_id) AS borrowers,
    ROUND(SUM(loan_amount), 2) AS total_loan_amount,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding_exposure,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount,
    ROUND(AVG(interest_rate), 2) AS average_interest_rate,
    ROUND(
        SUM(outstanding_amount) * 100.0
        / NULLIF(SUM(loan_amount), 0),
        2
    ) AS outstanding_ratio
FROM loans;

--PHASE 5  Customer Borrowing Behavior & Loan Intelligence
--1 Basic borrowing profile
SELECT
    customer_id,
    COUNT(loan_id) AS loan_count,
    ROUND(SUM(loan_amount), 2) AS total_borrowed,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding,
    ROUND(AVG(loan_amount), 2) AS average_loan_amount
FROM loans
GROUP BY customer_id
ORDER BY total_borrowed DESC;

--2 customer with multiple loans
SELECT
    customer_id,
    COUNT(loan_id) AS loan_count,
    ROUND(SUM(loan_amount), 2) AS total_borrowed,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding
FROM loans
GROUP BY customer_id
HAVING COUNT(loan_id) > 1
ORDER BY loan_count DESC;

--3 customer with 3 or more loans
SELECT
    customer_id,
    COUNT(loan_id) AS loan_count,
    ROUND(SUM(loan_amount), 2) AS total_borrowed,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding
FROM loans
GROUP BY customer_id
HAVING COUNT(loan_id) >= 3
ORDER BY loan_count DESC;

--4 customer with exactly one loan
SELECT
    customer_id,
    loan_count,
    total_borrowed,
    total_outstanding
FROM (
    SELECT
        customer_id,
        COUNT(loan_id) AS loan_count,
        ROUND(SUM(loan_amount), 2) AS total_borrowed,
        ROUND(SUM(outstanding_amount), 2) AS total_outstanding
    FROM loans
    GROUP BY customer_id
) AS customer_loans
WHERE loan_count = 1
ORDER BY total_borrowed DESC;

--5 borrowing frequency distribution
SELECT
    loan_count,
    COUNT(*) AS customer_count
FROM (
    SELECT
        customer_id,
        COUNT(loan_id) AS loan_count
    FROM loans
    GROUP BY customer_id
) AS customer_loans
GROUP BY loan_count
ORDER BY loan_count;

--6 customer with mutiple loan types
SELECT
    customer_id,
    COUNT(loan_id) AS loan_count,
    COUNT(DISTINCT loan_type) AS loan_type_count
FROM loans
GROUP BY customer_id
HAVING COUNT(DISTINCT loan_type) > 1
ORDER BY loan_type_count DESC, loan_count DESC;

--7 customer with mutiple loan type and exposure
SELECT
    customer_id,
    COUNT(loan_id) AS loan_count,
    COUNT(DISTINCT loan_type) AS loan_type_count,
    ROUND(SUM(loan_amount), 2) AS total_borrowed,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding
FROM loans
GROUP BY customer_id
HAVING COUNT(DISTINCT loan_type) > 1
ORDER BY total_outstanding DESC;

--8 customer with no loans
SELECT
    c.customer_id,
    c.customer_segment,
    c.region,
    c.annual_income
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM loans AS l
    WHERE l.customer_id = c.customer_id
)
ORDER BY c.annual_income DESC;

--counting customers with no loans by segment
SELECT
    c.customer_segment,
    COUNT(*) AS customers_without_loans
FROM customers AS c
WHERE NOT EXISTS (
    SELECT 1
    FROM loans AS l
    WHERE l.customer_id = c.customer_id
)
GROUP BY c.customer_segment
ORDER BY customers_without_loans DESC;

--10 borrowing behaviour by customer segment
SELECT
    c.customer_segment,
    COUNT(DISTINCT c.customer_id) AS borrowers,
    COUNT(l.loan_id) AS total_loans,
    ROUND(SUM(l.loan_amount), 2) AS total_borrowed,
    ROUND(SUM(l.outstanding_amount), 2) AS total_outstanding,
    ROUND(AVG(l.loan_amount), 2) AS average_loan_amount
FROM customers AS c
INNER JOIN loans AS l
    ON c.customer_id = l.customer_id
GROUP BY c.customer_segment
ORDER BY total_outstanding DESC;

--11 borrowing behaviour by region
SELECT
    c.region,
    COUNT(DISTINCT c.customer_id) AS borrowers,
    COUNT(l.loan_id) AS total_loans,
    ROUND(SUM(l.loan_amount), 2) AS total_borrowed,
    ROUND(SUM(l.outstanding_amount), 2) AS total_outstanding,
    ROUND(AVG(l.loan_amount), 2) AS average_loan_amount
FROM customers AS c
INNER JOIN loans AS l
    ON c.customer_id = l.customer_id
GROUP BY c.region
ORDER BY total_outstanding DESC;

--12 loan count per borrower
SELECT
    COUNT(*) AS total_borrowers,
    ROUND(AVG(loan_count), 2) AS average_loans_per_borrower,
    MIN(loan_count) AS minimum_loans,
    MAX(loan_count) AS maximum_loans
FROM (
    SELECT
        customer_id,
        COUNT(*) AS loan_count
    FROM loans
    GROUP BY customer_id
) AS borrower_summary;

--13 high value borrowers
WITH customer_exposure AS (
    SELECT
        customer_id,
        SUM(outstanding_amount) AS total_outstanding
    FROM loans
    GROUP BY customer_id
)
SELECT
    customer_id,
    ROUND(total_outstanding, 2) AS total_outstanding
FROM customer_exposure
ORDER BY total_outstanding DESC
LIMIT 10;

--14 add customer information
WITH customer_exposure AS (
    SELECT
        customer_id,
        COUNT(*) AS loan_count,
        SUM(loan_amount) AS total_borrowed,
        SUM(outstanding_amount) AS total_outstanding
    FROM loans
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_segment,
    c.region,
    c.annual_income,
    ce.loan_count,
    ROUND(ce.total_borrowed, 2) AS total_borrowed,
    ROUND(ce.total_outstanding, 2) AS total_outstanding
FROM customer_exposure AS ce
INNER JOIN customers AS c
    ON ce.customer_id = c.customer_id
ORDER BY ce.total_outstanding DESC
LIMIT 10;

--15 Borrowing Compared With Income
SELECT
    c.customer_id,
    c.customer_segment,
    c.annual_income,
    ROUND(SUM(l.loan_amount), 2) AS total_borrowed,
    ROUND(
        SUM(l.loan_amount) * 100.0 /
        NULLIF(c.annual_income, 0),
        2
    ) AS borrowed_to_income_percentage
FROM customers AS c
INNER JOIN loans AS l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.customer_segment,
    c.annual_income
ORDER BY borrowed_to_income_percentage DESC;

--16 Identify High Borrowing Relative to Income
WITH customer_borrowing AS (
    SELECT
        c.customer_id,
        c.customer_segment,
        c.annual_income,
        SUM(l.loan_amount) AS total_borrowed
    FROM customers AS c
    INNER JOIN loans AS l
        ON c.customer_id = l.customer_id
    GROUP BY
        c.customer_id,
        c.customer_segment,
        c.annual_income
)
SELECT
    customer_id,
    customer_segment,
    annual_income,
    ROUND(total_borrowed, 2) AS total_borrowed,
    ROUND(
        total_borrowed * 100.0 /
        NULLIF(annual_income, 0),
        2
    ) AS borrowed_to_income_percentage
FROM customer_borrowing
WHERE total_borrowed * 100.0 /
      NULLIF(annual_income, 0) > 200
ORDER BY borrowed_to_income_percentage DESC;

--17 Outstanding-to-Income Indicator
WITH customer_exposure AS (
    SELECT
        c.customer_id,
        c.customer_segment,
        c.annual_income,
        SUM(l.outstanding_amount) AS total_outstanding
    FROM customers AS c
    INNER JOIN loans AS l
        ON c.customer_id = l.customer_id
    GROUP BY
        c.customer_id,
        c.customer_segment,
        c.annual_income
)
SELECT
    customer_id,
    customer_segment,
    annual_income,
    ROUND(total_outstanding, 2) AS total_outstanding,
    ROUND(
        total_outstanding * 100.0 /
        NULLIF(annual_income, 0),
        2
    ) AS outstanding_to_income_percentage
FROM customer_exposure
ORDER BY outstanding_to_income_percentage DESC;

--18 rank Customers by Outstanding Exposure
WITH customer_exposure AS (
    SELECT
        customer_id,
        SUM(outstanding_amount) AS total_outstanding
    FROM loans
    GROUP BY customer_id
)
SELECT
    customer_id,
    ROUND(total_outstanding, 2) AS total_outstanding,
    RANK() OVER (
        ORDER BY total_outstanding DESC
    ) AS exposure_rank
FROM customer_exposure
ORDER BY exposure_rank;

--20 Top 3 Borrowers in Each Segment
WITH customer_exposure AS (
    SELECT
        c.customer_id,
        c.customer_segment,
        SUM(l.outstanding_amount) AS total_outstanding
    FROM customers AS c
    INNER JOIN loans AS l
        ON c.customer_id = l.customer_id
    GROUP BY
        c.customer_id,
        c.customer_segment
),
ranked_customers AS (
    SELECT
        customer_id,
        customer_segment,
        total_outstanding,
        RANK() OVER (
            PARTITION BY customer_segment
            ORDER BY total_outstanding DESC
        ) AS exposure_rank
    FROM customer_exposure
)
SELECT
    customer_id,
    customer_segment,
    ROUND(total_outstanding, 2) AS total_outstanding,
    exposure_rank
FROM ranked_customers
WHERE exposure_rank <= 3
ORDER BY
    customer_segment,
    exposure_rank;

--21 customer borrowing by loan type
SELECT
    c.customer_id,
    c.customer_segment,
    l.loan_type,
    COUNT(*) AS loan_count,
    ROUND(SUM(l.loan_amount), 2) AS total_borrowed,
    ROUND(SUM(l.outstanding_amount), 2) AS total_outstanding
FROM customers AS c
INNER JOIN loans AS l
    ON c.customer_id = l.customer_id
GROUP BY
    c.customer_id,
    c.customer_segment,
    l.loan_type
ORDER BY
    c.customer_id,
    total_outstanding DESC;

--22 customer with high loan count
WITH customer_loans AS (
    SELECT
        customer_id,
        COUNT(*) AS loan_count,
        SUM(outstanding_amount) AS total_outstanding
    FROM loans
    GROUP BY customer_id
)
SELECT
    customer_id,
    loan_count,
    ROUND(total_outstanding, 2) AS total_outstanding,
    CASE
        WHEN loan_count >= 4 THEN 'High Borrowing Frequency'
        WHEN loan_count >= 2 THEN 'Moderate Borrowing Frequency'
        ELSE 'Single Loan'
    END AS borrowing_frequency_segment
FROM customer_loans
ORDER BY loan_count DESC;

--23 Customer borrowing intelligence dataset
WITH customer_loans AS (
    SELECT
        customer_id,
        COUNT(*) AS loan_count,
        COUNT(DISTINCT loan_type) AS loan_type_count,
        SUM(loan_amount) AS total_borrowed,
        SUM(outstanding_amount) AS total_outstanding,
        AVG(loan_amount) AS average_loan_amount
    FROM loans
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_segment,
    c.region,
    c.annual_income,

    COALESCE(cl.loan_count, 0) AS loan_count,

    COALESCE(cl.loan_type_count, 0) AS loan_type_count,

    ROUND(COALESCE(cl.total_borrowed, 0), 2) AS total_borrowed,

    ROUND(COALESCE(cl.total_outstanding, 0), 2)
        AS total_outstanding,

    ROUND(COALESCE(cl.average_loan_amount, 0), 2)
        AS average_loan_amount,

    CASE
        WHEN cl.loan_count IS NULL THEN 'No Loans'
        WHEN cl.loan_count >= 4 THEN 'High Borrowing Frequency'
        WHEN cl.loan_count >= 2 THEN 'Multiple Loans'
        ELSE 'Single Loan'
    END AS borrowing_behavior

FROM customers AS c
LEFT JOIN customer_loans AS cl
    ON c.customer_id = cl.customer_id
ORDER BY total_outstanding DESC;

--24 customer borrowing behvaiour summary
WITH customer_loans AS (
    SELECT
        customer_id,
        COUNT(*) AS loan_count,
        SUM(outstanding_amount) AS total_outstanding
    FROM loans
    GROUP BY customer_id
),
customer_behavior AS (
    SELECT
        c.customer_id,
        CASE
            WHEN cl.loan_count IS NULL THEN 'No Loans'
            WHEN cl.loan_count >= 4 THEN 'High Borrowing Frequency'
            WHEN cl.loan_count >= 2 THEN 'Multiple Loans'
            ELSE 'Single Loan'
        END AS borrowing_behavior,
        COALESCE(cl.total_outstanding, 0) AS total_outstanding
    FROM customers AS c
    LEFT JOIN customer_loans AS cl
        ON c.customer_id = cl.customer_id
)
SELECT
    borrowing_behavior,
    COUNT(*) AS customer_count,
    ROUND(SUM(total_outstanding), 2) AS total_outstanding
FROM customer_behavior
GROUP BY borrowing_behavior
ORDER BY total_outstanding DESC;

--PHASE 6 Loan Application & Approval Analytics
--SECTION A — Application Overview
--1 Total Applications
SELECT
    COUNT(*) AS total_applications
FROM loan_applications;

--2 Total requested amount
SELECT
    ROUND(SUM(requested_amount), 2) AS total_requested_amount
FROM loan_applications;

--3 Average requested amount
SELECT
    ROUND(AVG(requested_amount), 2) AS average_requested_amount
FROM loan_applications;

--4 Application status distribution
SELECT
    application_status,
    COUNT(*) AS application_count
FROM loan_applications
GROUP BY application_status
ORDER BY application_count DESC;

--5 Requested amount by application status
SELECT
    application_status,

    COUNT(*) AS application_count,

    ROUND(
        SUM(requested_amount),
        2
    ) AS total_requested_amount,

    ROUND(
        AVG(requested_amount),
        2
    ) AS average_requested_amount

FROM loan_applications

GROUP BY application_status

ORDER BY total_requested_amount DESC;

--SECTION B  Approval Analytics
--6 Approval rate
SELECT
    COUNT(*) AS total_applications,
    COUNT(
        CASE
            WHEN application_status = 'Approved'
            THEN 1
        END
    ) AS approved_applications,
    ROUND(
        COUNT(
            CASE
                WHEN application_status = 'Approved'
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS approval_rate_percentage
FROM loan_applications;

--7 Rejection rate
SELECT
    COUNT(*) AS total_applications,

    COUNT(
        CASE
            WHEN application_status = 'Rejected'
            THEN 1
        END
    ) AS rejected_applications,

    ROUND(
        COUNT(
            CASE
                WHEN application_status = 'Rejected'
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS rejection_rate_percentage

FROM loan_applications;

--8 Approval vs Rejection Summary
SELECT
    application_status,
    COUNT(*) AS application_count,
    ROUND(
        COUNT(*) * 100.0 /
        (SELECT COUNT(*) FROM loan_applications),
        2
    ) AS percentage_of_applications
FROM loan_applications
GROUP BY application_status
ORDER BY application_count DESC;

--SECTION C Loan Type Application Performance
--9 Applications by loan type 
SELECT
    loan_type,
    COUNT(*) AS application_count
FROM loan_applications
GROUP BY loan_type
ORDER BY application_count DESC;

--10 Applications outcome by loan type
SELECT
    loan_type,
    application_status,
    COUNT(*) AS application_count
FROM loan_applications
GROUP BY
    loan_type,
    application_status
ORDER BY
    loan_type,
    application_count DESC;

--11 Approval rate by loan type 
SELECT
    loan_type,

    COUNT(*) AS total_applications,

    COUNT(
        CASE
            WHEN application_status = 'Approved'
            THEN 1
        END
    ) AS approved_applications,

    ROUND(
        COUNT(
            CASE
                WHEN application_status = 'Approved'
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS approval_rate_percentage

FROM loan_applications

GROUP BY loan_type

ORDER BY approval_rate_percentage DESC;

--12 Requested amount by loan type
SELECT
    loan_type,
    COUNT(*) AS application_count,
    ROUND(SUM(requested_amount), 2) AS total_requested,
    ROUND(AVG(requested_amount), 2) AS average_requested
FROM loan_applications
GROUP BY loan_type
ORDER BY total_requested DESC;

--SECTION D — Customer Segment Application Behavior
--13 Application by customer segment
SELECT
    c.customer_segment,
    COUNT(la.application_id) AS application_count,
    ROUND(SUM(la.requested_amount), 2) AS total_requested
FROM customers AS c
INNER JOIN loan_applications AS la
    ON c.customer_id = la.customer_id
GROUP BY c.customer_segment
ORDER BY application_count DESC;

--14 Approval rate by customer segment
SELECT
    c.customer_segment,
    COUNT(la.application_id) AS total_applications,
    COUNT(
        CASE
            WHEN la.application_status = 'Approved'
            THEN 1
        END
    ) AS approved_applications,
    ROUND(
        COUNT(
            CASE
                WHEN la.application_status = 'Approved'
                THEN 1
            END
        ) * 100.0 / COUNT(la.application_id),
        2
    ) AS approval_rate_percentage
FROM customers AS c
INNER JOIN loan_applications AS la
    ON c.customer_id = la.customer_id
GROUP BY c.customer_segment
ORDER BY approval_rate_percentage DESC;

--15 Requested amount by customer segment
SELECT
    c.customer_segment,
    COUNT(la.application_id) AS application_count,
    ROUND(AVG(la.requested_amount), 2) AS average_requested_amount,
    ROUND(SUM(la.requested_amount), 2) AS total_requested_amount
FROM customers AS c
INNER JOIN loan_applications AS la
    ON c.customer_id = la.customer_id
GROUP BY c.customer_segment
ORDER BY total_requested_amount DESC;

--SECTION E  Regional Application Analytics
--16 Applications by region
SELECT
    c.region,
    COUNT(la.application_id) AS application_count,
    ROUND(SUM(la.requested_amount), 2) AS total_requested_amount
FROM customers AS c
INNER JOIN loan_applications AS la
    ON c.customer_id = la.customer_id
GROUP BY c.region
ORDER BY application_count DESC;

--17 Regional approval rate
SELECT
    c.region,
    COUNT(la.application_id) AS total_applications,
    COUNT(
        CASE
            WHEN la.application_status = 'Approved'
            THEN 1
        END
    ) AS approved_applications,
    ROUND(
        COUNT(
            CASE
                WHEN la.application_status = 'Approved'
                THEN 1
            END
        ) * 100.0 / COUNT(la.application_id),
        2
    ) AS approval_rate_percentage
FROM customers AS c
INNER JOIN loan_applications AS la
    ON c.customer_id = la.customer_id
GROUP BY c.region
ORDER BY approval_rate_percentage DESC;

--18 Approved applications with loan recods
SELECT
    la.application_id,
    la.customer_id,
    la.loan_type,
    la.requested_amount,
    l.loan_amount,
    la.application_status
FROM loan_applications AS la
INNER JOIN loans AS l
    ON la.loan_id = l.loan_id
WHERE la.application_status = 'Approved';

--19 Requested vs actual amount
SELECT
    la.loan_type,
    COUNT(*) AS approved_applications,
    ROUND(AVG(la.requested_amount), 2) AS average_requested,
    ROUND(AVG(l.loan_amount), 2) AS average_approved,
    ROUND(
        AVG(l.loan_amount - la.requested_amount),
        2
    ) AS average_amount_difference
FROM loan_applications AS la
INNER JOIN loans AS l
    ON la.loan_id = l.loan_id
WHERE la.application_status = 'Approved'
GROUP BY la.loan_type
ORDER BY average_approved DESC;

--20 Applications Where Approved Amount Exceeded Requested Amount
SELECT
    la.application_id,
    la.customer_id,
    la.requested_amount,
    l.loan_amount
FROM loan_applications AS la
INNER JOIN loans AS l
    ON la.loan_id = l.loan_id
WHERE la.application_status = 'Approved'
  AND l.loan_amount > la.requested_amount;

--21 Applicatios where approved amount was lower
SELECT
    la.application_id,
    la.customer_id,
    la.requested_amount,
    l.loan_amount,
    ROUND(
        la.requested_amount - l.loan_amount,
        2
    ) AS amount_reduction
FROM loan_applications AS la
INNER JOIN loans AS l
    ON la.loan_id = l.loan_id
WHERE la.application_status = 'Approved'
  AND l.loan_amount < la.requested_amount
ORDER BY amount_reduction DESC;

--SECTION G  Application-to-Loan Conversion
--22 Approved Applications Without Loans
SELECT
    la.application_id,
    la.customer_id,
    la.loan_type,
    la.requested_amount
FROM loan_applications AS la
LEFT JOIN loans AS l
    ON la.loan_id = l.loan_id
WHERE la.application_status = 'Approved'
  AND l.loan_id IS NULL;

--23 Application conversion summary
SELECT
    COUNT(*) AS approved_applications,
    COUNT(
        CASE
            WHEN l.loan_id IS NOT NULL
            THEN 1
        END
    ) AS converted_to_loans,
    ROUND(
        COUNT(
            CASE
                WHEN l.loan_id IS NOT NULL
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS conversion_rate_percentage
FROM loan_applications AS la
LEFT JOIN loans AS l
    ON la.loan_id = l.loan_id
WHERE la.application_status = 'Approved';

--SECTION H  Application Processing Time
--24 Application processing days
SELECT
    application_id,
    application_date,
    decision_date,
    decision_date - application_date AS processing_days
FROM loan_applications
WHERE decision_date IS NOT NULL
ORDER BY processing_days DESC;

--25 Avg processing time
SELECT
    ROUND(
        AVG(decision_date - application_date),
        2
    ) AS average_processing_days
FROM loan_applications
WHERE decision_date IS NOT NULL;

--26 processing type by loan type
SELECT
    loan_type,
    COUNT(*) AS applications_with_decision,
    ROUND(
        AVG(decision_date - application_date),
        2
    ) AS average_processing_days
FROM loan_applications
WHERE decision_date IS NOT NULL
GROUP BY loan_type
ORDER BY average_processing_days;

--SECTION I  Monthly Application Trend
--27 Monthly applications
SELECT
    DATE_TRUNC('month', application_date) AS application_month,
    COUNT(*) AS application_count,
    ROUND(SUM(requested_amount), 2) AS total_requested
FROM loan_applications
GROUP BY application_month
ORDER BY application_month;

--28 Monthly approval rate
SELECT
    DATE_TRUNC('month', application_date) AS application_month,
    COUNT(*) AS total_applications,
    COUNT(
        CASE
            WHEN application_status = 'Approved'
            THEN 1
        END
    ) AS approved_applications,
    ROUND(
        COUNT(
            CASE
                WHEN application_status = 'Approved'
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS approval_rate_percentage
FROM loan_applications
GROUP BY application_month
ORDER BY application_month;

--SECTION J Ranking
-- 29 Rank Loan Types by Requested Amount
SELECT
    loan_type,
    ROUND(SUM(requested_amount), 2) AS total_requested,
    RANK() OVER (
        ORDER BY SUM(requested_amount) DESC
    ) AS requested_amount_rank
FROM loan_applications
GROUP BY loan_type
ORDER BY requested_amount_rank;

--30 Rank regions by application volume
SELECT
    c.region,
    COUNT(la.application_id) AS application_count,
    RANK() OVER (
        ORDER BY COUNT(la.application_id) DESC
    ) AS application_volume_rank
FROM customers AS c
INNER JOIN loan_applications AS la
    ON c.customer_id = la.customer_id
GROUP BY c.region
ORDER BY application_volume_rank;

--SECTION K Application Intelligence Dataset
WITH application_summary AS (
    SELECT
        customer_id,
        COUNT(*) AS application_count,
        COUNT(
            CASE
                WHEN application_status = 'Approved'
                THEN 1
            END
        ) AS approved_count,
        COUNT(
            CASE
                WHEN application_status = 'Rejected'
                THEN 1
            END
        ) AS rejected_count,
        SUM(requested_amount) AS total_requested
    FROM loan_applications
    GROUP BY customer_id
)
SELECT
    c.customer_id,
    c.customer_segment,
    c.region,
    c.annual_income,

    a.application_count,
    a.approved_count,
    a.rejected_count,

    ROUND(a.total_requested, 2) AS total_requested,

    ROUND(
        a.approved_count * 100.0 /
        NULLIF(a.application_count, 0),
        2
    ) AS customer_approval_rate

FROM customers AS c
INNER JOIN application_summary AS a
    ON c.customer_id = a.customer_id
ORDER BY total_requested DESC;

--SECTION L  Final Executive Application Summary
SELECT
    COUNT(*) AS total_applications,

    COUNT(
        CASE
            WHEN application_status = 'Approved'
            THEN 1
        END
    ) AS approved_applications,

    COUNT(
        CASE
            WHEN application_status = 'Rejected'
            THEN 1
        END
    ) AS rejected_applications,

    ROUND(SUM(requested_amount), 2)
        AS total_requested_amount,

    ROUND(
        AVG(requested_amount),
        2
    ) AS average_requested_amount,

    ROUND(
        COUNT(
            CASE
                WHEN application_status = 'Approved'
                THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS approval_rate_percentage

FROM loan_applications;

--PHASE 7 Loan Payments & Delinquency Analytics
--1 Total payment
SELECT
    COUNT(*) AS total_payments
FROM loan_payments;

--2 Total payment amount
SELECT
    ROUND(SUM(payment_amount), 2) AS total_payment_amount
FROM loan_payments;

--3 Average payment
SELECT
    ROUND(AVG(payment_amount), 2) AS average_payment_amount
FROM loan_payments;

--4 Minimum and maximum payment
SELECT
    MIN(payment_amount) AS minimum_payment,
    MAX(payment_amount) AS maximum_payment,
    ROUND(AVG(payment_amount), 2) AS average_payment
FROM loan_payments;

--SECTION B  Payment Status
--5 Payment Status Distribution
SELECT
    payment_status,
    COUNT(*) AS payment_count
FROM loan_payments
GROUP BY payment_status
ORDER BY payment_count DESC;

--6 Payment amount by status
SELECT
    payment_status,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_amount), 2) AS total_payment_amount,
    ROUND(AVG(payment_amount), 2) AS average_payment_amount
FROM loan_payments
GROUP BY payment_status
ORDER BY total_payment_amount DESC;

--SECTION C  Late Payment Analysis
--7 Total late payments
SELECT
    COUNT(*) AS late_payment_count
FROM loan_payments
WHERE days_late > 0;

--8 Late payment rate
SELECT
    COUNT(*) AS total_payments,

    COUNT(
        CASE
            WHEN days_late > 0 THEN 1
        END
    ) AS late_payments,

    ROUND(
        COUNT(
            CASE
                WHEN days_late > 0 THEN 1
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS late_payment_rate
FROM loan_payments;

--9 average days late
SELECT
    ROUND(
        AVG(days_late),
        2
    ) AS average_days_late
FROM loan_payments
WHERE days_late > 0;

--10 maximum days late
SELECT
    MAX(days_late) AS maximum_days_late
FROM loan_payments;

--11 late payment Severity
SELECT
    payment_id,
    loan_id,
    days_late,

    CASE
    WHEN days_late IS NULL
        THEN 'Unknown'

    WHEN days_late = 0
        THEN 'On Time'

    WHEN days_late BETWEEN 1 AND 7
        THEN '1-7 Days Late'

    WHEN days_late BETWEEN 8 AND 30
        THEN '8-30 Days Late'

    WHEN days_late BETWEEN 31 AND 60
        THEN '31-60 Days Late'

    ELSE '61+ Days Late'
END

--12. Delinquency Bucket Distribution
WITH delinquency AS (
    SELECT
     CASE
    WHEN days_late IS NULL
        THEN 'Unknown'

    WHEN days_late = 0
        THEN 'On Time'

    WHEN days_late BETWEEN 1 AND 7
        THEN '1-7 Days Late'

    WHEN days_late BETWEEN 8 AND 30
        THEN '8-30 Days Late'

    WHEN days_late BETWEEN 31 AND 60
        THEN '31-60 Days Late'

    ELSE '61+ Days Late'
        END AS delinquency_bucket
    FROM loan_payments
)

SELECT
    delinquency_bucket,
    COUNT(*) AS payment_count

FROM delinquency

GROUP BY delinquency_bucket

ORDER BY
    CASE
        WHEN delinquency_bucket = 'On Time' THEN 1
        WHEN delinquency_bucket = '1-7 Days Late' THEN 2
        WHEN delinquency_bucket = '8-30 Days Late' THEN 3
        WHEN delinquency_bucket = '31-60 Days Late' THEN 4
        ELSE 5
    END;

--SECTION D Loan-Level Payment Behavior
-- 13. Payments per Loan
SELECT
    loan_id,
    COUNT(*) AS payment_count,
    ROUND(SUM(payment_amount), 2) AS total_paid,
    ROUND(AVG(payment_amount), 2) AS average_payment
FROM loan_payments
GROUP BY loan_id
ORDER BY total_paid DESC;

--14 late payments per loan
SELECT
    loan_id,

    COUNT(*) AS total_payments,

    COUNT(
        CASE
            WHEN days_late > 0 THEN 1
        END
    ) AS late_payment_count,

    ROUND(
        AVG(days_late),
        2
    ) AS average_days_late

FROM loan_payments
GROUP BY loan_id
ORDER BY late_payment_count DESC;

--15 Loans with repeated late payments
SELECT
    loan_id,

    COUNT(*) AS total_payments,

    COUNT(
        CASE
            WHEN days_late > 0 THEN 1
        END
    ) AS late_payment_count

FROM loan_payments
GROUP BY loan_id
HAVING COUNT(
    CASE
        WHEN days_late > 0 THEN 1
    END
) >= 3

ORDER BY late_payment_count DESC;

--16 loans with severe late payments
SELECT
    loan_id,
    COUNT(*) AS total_payments,
    MAX(days_late) AS maximum_days_late
FROM loan_payments
GROUP BY loan_id
HAVING MAX(days_late) >= 30
ORDER BY maximum_days_late DESC;

--SECTION E  Connect Payments to Loans
--17 payment behaviour by loan type
SELECT
    l.loan_type,

    COUNT(lp.payment_id) AS total_payments,

    COUNT(
        CASE
            WHEN lp.days_late > 0 THEN 1
        END
    ) AS late_payments,

    ROUND(
        COUNT(
            CASE
                WHEN lp.days_late > 0 THEN 1
            END
        ) * 100.0 /
        COUNT(lp.payment_id),
        2
    ) AS late_payment_rate,

    ROUND(
        AVG(lp.days_late),
        2
    ) AS average_days_late

FROM loans AS l
INNER JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id

GROUP BY l.loan_type

ORDER BY late_payment_rate DESC;

--18 payment behaviour by loan status
SELECT
    l.loan_status,

    COUNT(lp.payment_id) AS total_payments,

    COUNT(
        CASE
            WHEN lp.days_late > 0 THEN 1
        END
    ) AS late_payments,

    ROUND(
        AVG(lp.days_late),
        2
    ) AS average_days_late

FROM loans AS l
INNER JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id

GROUP BY l.loan_status

ORDER BY average_days_late DESC;

--SECTION F Customer-Level Payment Behavior
--19. Customer Payment Summary
SELECT
    c.customer_id,

    COUNT(lp.payment_id) AS payment_count,

    ROUND(
        SUM(lp.payment_amount),
        2
    ) AS total_paid,

    COUNT(
        CASE
            WHEN lp.days_late > 0 THEN 1
        END
    ) AS late_payment_count,

    ROUND(
        AVG(lp.days_late),
        2
    ) AS average_days_late

FROM customers AS c

INNER JOIN loans AS l
    ON c.customer_id = l.customer_id

INNER JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id

GROUP BY c.customer_id

ORDER BY late_payment_count DESC;

--20 customers with repeated late payments
SELECT
    c.customer_id,

    COUNT(lp.payment_id) AS total_payments,

    COUNT(
        CASE
            WHEN lp.days_late > 0 THEN 1
        END
    ) AS late_payment_count,

    ROUND(
        AVG(lp.days_late),
        2
    ) AS average_days_late

FROM customers AS c

INNER JOIN loans AS l
    ON c.customer_id = l.customer_id

INNER JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id

GROUP BY c.customer_id

HAVING COUNT(
    CASE
        WHEN lp.days_late > 0 THEN 1
    END
) >= 3

ORDER BY late_payment_count DESC;

--21 Customer Payment Behavior by segment
SELECT
    c.customer_segment,

    COUNT(lp.payment_id) AS total_payments,

    COUNT(
        CASE
            WHEN lp.days_late > 0 THEN 1
        END
    ) AS late_payments,

    ROUND(
        COUNT(
            CASE
                WHEN lp.days_late > 0 THEN 1
            END
        ) * 100.0 /
        COUNT(lp.payment_id),
        2
    ) AS late_payment_rate,

    ROUND(
        AVG(lp.days_late),
        2
    ) AS average_days_late

FROM customers AS c

INNER JOIN loans AS l
    ON c.customer_id = l.customer_id

INNER JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id

GROUP BY c.customer_segment

ORDER BY late_payment_rate DESC;

--22 payment behaviour by region
SELECT
    c.region,

    COUNT(lp.payment_id) AS total_payments,

    COUNT(
        CASE
            WHEN lp.days_late > 0 THEN 1
        END
    ) AS late_payments,

    ROUND(
        COUNT(
            CASE
                WHEN lp.days_late > 0 THEN 1
            END
        ) * 100.0 /
        COUNT(lp.payment_id),
        2
    ) AS late_payment_rate,

    ROUND(
        AVG(lp.days_late),
        2
    ) AS average_days_late

FROM customers AS c

INNER JOIN loans AS l
    ON c.customer_id = l.customer_id

INNER JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id

GROUP BY c.region

ORDER BY late_payment_rate DESC;

--SECTION G Loans Without Payments
-- 23 Loans With No Payment Records
SELECT
    l.loan_id,
    l.customer_id,
    l.loan_type,
    l.loan_amount,
    l.outstanding_amount,
    l.loan_status

FROM loans AS l

LEFT JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id

WHERE lp.loan_id IS NULL;

--24. Count Loans Without Payments
SELECT
    COUNT(*) AS loans_without_payments
FROM loans AS l

WHERE NOT EXISTS (
    SELECT 1
    FROM loan_payments AS lp
    WHERE lp.loan_id = l.loan_id
);

--SECTION H  Outstanding Exposure + Payment Behavio
--25. Loan Exposure With Payment Behavior
SELECT
    l.loan_id,
    l.customer_id,
    l.loan_type,
    l.loan_amount,
    l.outstanding_amount,

    COUNT(lp.payment_id) AS payment_count,

    COUNT(
        CASE
            WHEN lp.days_late > 0 THEN 1
        END
    ) AS late_payment_count,

    ROUND(
        AVG(lp.days_late),
        2
    ) AS average_days_late

FROM loans AS l

LEFT JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id

GROUP BY
    l.loan_id,
    l.customer_id,
    l.loan_type,
    l.loan_amount,
    l.outstanding_amount

ORDER BY l.outstanding_amount DESC;

--26. Loans With Repeated Late Payments
SELECT
    l.loan_id,
    l.customer_id,
    l.loan_type,
    l.outstanding_amount,

    COUNT(
        CASE
            WHEN lp.days_late > 0 THEN 1
        END
    ) AS late_payment_count,

    MAX(lp.days_late) AS maximum_days_late

FROM loans AS l

INNER JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id

GROUP BY
    l.loan_id,
    l.customer_id,
    l.loan_type,
    l.outstanding_amount

HAVING COUNT(
    CASE
        WHEN lp.days_late > 0 THEN 1
    END
) >= 2

ORDER BY
    l.outstanding_amount DESC;

--SECTION I  Customer Exposure + Delinquency
--27. Customer Risk-Oriented Summary

WITH customer_exposure AS (

    SELECT
        customer_id,
        COUNT(*) AS loan_count,
        SUM(outstanding_amount) AS total_outstanding
    FROM loans
    GROUP BY customer_id

),

customer_payments AS (

    SELECT
        l.customer_id,

        COUNT(lp.payment_id) AS payment_count,

        COUNT(
            CASE
                WHEN lp.days_late > 0
                THEN 1
            END
        ) AS late_payment_count,

        AVG(lp.days_late) AS average_days_late

    FROM loans AS l

    LEFT JOIN loan_payments AS lp
        ON l.loan_id = lp.loan_id

    GROUP BY l.customer_id

)

SELECT
    c.customer_id,
    c.customer_segment,
    c.region,

    COALESCE(
        ce.loan_count,
        0
    ) AS loan_count,

    ROUND(
        COALESCE(
            ce.total_outstanding,
            0
        ),
        2
    ) AS total_outstanding,

    COALESCE(
        cp.payment_count,
        0
    ) AS payment_count,

    COALESCE(
        cp.late_payment_count,
        0
    ) AS late_payment_count,

    ROUND(
        COALESCE(
            cp.average_days_late,
            0
        ),
        2
    ) AS average_days_late,

    ROUND(
        COALESCE(
            cp.late_payment_count,
            0
        ) * 100.0 /
        NULLIF(
            cp.payment_count,
            0
        ),
        2
    ) AS late_payment_rate

FROM customers AS c

LEFT JOIN customer_exposure AS ce
    ON c.customer_id = ce.customer_id

LEFT JOIN customer_payments AS cp
    ON c.customer_id = cp.customer_id

ORDER BY
    late_payment_rate DESC,
    total_outstanding DESC;

--SECTION J Create a Descriptive Risk Flag
WITH loan_summary AS (

    SELECT
        customer_id,

        COUNT(*) AS loan_count,

        SUM(outstanding_amount)
            AS total_outstanding

    FROM loans

    GROUP BY customer_id

),

payment_summary AS (

    SELECT
        l.customer_id,

        COUNT(lp.payment_id)
            AS payment_count,

        COUNT(
            CASE
                WHEN lp.days_late > 0
                THEN 1
            END
        ) AS late_payment_count,

        MAX(lp.days_late)
            AS maximum_days_late

    FROM loans AS l

    LEFT JOIN loan_payments AS lp
        ON l.loan_id = lp.loan_id

    GROUP BY l.customer_id

)

SELECT
    c.customer_id,
    c.customer_segment,
    c.region,

    COALESCE(
        ls.loan_count,
        0
    ) AS loan_count,

    ROUND(
        COALESCE(
            ls.total_outstanding,
            0
        ),
        2
    ) AS total_outstanding,

    COALESCE(
        ps.payment_count,
        0
    ) AS payment_count,

    COALESCE(
        ps.late_payment_count,
        0
    ) AS late_payment_count,

    COALESCE(
        ps.maximum_days_late,
        0
    ) AS maximum_days_late,

    CASE

        WHEN COALESCE(ps.late_payment_count, 0) >= 5
             AND COALESCE(ps.maximum_days_late, 0) >= 30
            THEN 'High Payment Concern'

        WHEN COALESCE(ps.late_payment_count, 0) >= 3
            THEN 'Repeated Late Payments'

        WHEN COALESCE(ps.late_payment_count, 0) > 0
            THEN 'Occasional Late Payments'

        ELSE 'No Late Payments'

    END AS payment_behavior_flag

FROM customers AS c

LEFT JOIN loan_summary AS ls
    ON c.customer_id = ls.customer_id

LEFT JOIN payment_summary AS ps
    ON c.customer_id = ps.customer_id

ORDER BY
    late_payment_count DESC,
    total_outstanding DESC;

--SECTION K Rank Customers by Outstanding Exposure
--28. Exposure Ranking
WITH customer_exposure AS (

    SELECT
        c.customer_id,
        c.customer_segment,
        c.region,
        SUM(l.outstanding_amount) AS total_outstanding

    FROM customers AS c

    INNER JOIN loans AS l
        ON c.customer_id = l.customer_id

    GROUP BY
        c.customer_id,
        c.customer_segment,
        c.region
)

SELECT
    customer_id,
    customer_segment,
    region,

    ROUND(
        total_outstanding,
        2
    ) AS total_outstanding,

    RANK() OVER (
        ORDER BY total_outstanding DESC
    ) AS exposure_rank

FROM customer_exposure

ORDER BY exposure_rank;

--Section L Ranking Customers by late payment
WITH customer_payments AS (

    SELECT
        c.customer_id,
        c.customer_segment,

        COUNT(
            CASE
                WHEN lp.days_late > 0 THEN 1
            END
        ) AS late_payment_count

    FROM customers AS c

    INNER JOIN loans AS l
        ON c.customer_id = l.customer_id

    LEFT JOIN loan_payments AS lp
        ON l.loan_id = lp.loan_id

    GROUP BY
        c.customer_id,
        c.customer_segment
)

SELECT
    customer_id,
    customer_segment,
    late_payment_count,

    RANK() OVER (
        ORDER BY late_payment_count DESC
    ) AS late_payment_rank

FROM customer_payments

ORDER BY late_payment_rank;

--SECTION M Final Payment Intelligence Dataset
WITH payment_summary AS (

    SELECT
        l.customer_id,

        COUNT(lp.payment_id) AS payment_count,

        SUM(lp.payment_amount) AS total_paid,

        COUNT(
            CASE
                WHEN lp.days_late > 0 THEN 1
            END
        ) AS late_payment_count,

        AVG(lp.days_late) AS average_days_late,

        MAX(lp.days_late) AS maximum_days_late

    FROM loans AS l

    LEFT JOIN loan_payments AS lp
        ON l.loan_id = lp.loan_id

    GROUP BY l.customer_id
),

loan_summary AS (

    SELECT
        customer_id,

        COUNT(*) AS loan_count,

        SUM(loan_amount) AS total_borrowed,

        SUM(outstanding_amount) AS total_outstanding

    FROM loans

    GROUP BY customer_id
)

SELECT
    c.customer_id,
    c.customer_segment,
    c.region,

    COALESCE(ls.loan_count, 0)
        AS loan_count,

    ROUND(
        COALESCE(ls.total_borrowed, 0),
        2
    ) AS total_borrowed,

    ROUND(
        COALESCE(ls.total_outstanding, 0),
        2
    ) AS total_outstanding,

    COALESCE(ps.payment_count, 0)
        AS payment_count,

    ROUND(
        COALESCE(ps.total_paid, 0),
        2
    ) AS total_paid,

    COALESCE(ps.late_payment_count, 0)
        AS late_payment_count,

    ROUND(
        COALESCE(ps.average_days_late, 0),
        2
    ) AS average_days_late,

    COALESCE(
        ps.maximum_days_late,
        0
    ) AS maximum_days_late,

    ROUND(
        COALESCE(ps.late_payment_count, 0) * 100.0 /
        NULLIF(ps.payment_count, 0),
        2
    ) AS late_payment_rate,

    CASE

        WHEN COALESCE(ps.late_payment_count, 0) >= 5
             AND COALESCE(ps.maximum_days_late, 0) >= 30
            THEN 'High Payment Concern'

        WHEN COALESCE(ps.late_payment_count, 0) >= 3
            THEN 'Repeated Late Payments'

        WHEN COALESCE(ps.late_payment_count, 0) > 0
            THEN 'Occasional Late Payments'

        ELSE 'No Late Payments'

    END AS payment_behavior_flag

FROM customers AS c

LEFT JOIN loan_summary AS ls
    ON c.customer_id = ls.customer_id

LEFT JOIN payment_summary AS ps
    ON c.customer_id = ps.customer_id

ORDER BY total_outstanding DESC;

--PHASE 8 Risk-Oriented Portfolio Analysis
--SECTION A — Overall Loan Exposure
--1 Total Loan Exposure
SELECT
    ROUND(SUM(loan_amount), 2) AS total_loan_amount,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding_amount
FROM loans;

--2 Outstanding percentage of original lending
SELECT
    ROUND(SUM(loan_amount), 2) AS total_loan_amount,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding_amount,
    ROUND(
        SUM(outstanding_amount) * 100.0 /
        NULLIF(SUM(loan_amount), 0),
        2
    ) AS outstanding_percentage
FROM loans;

--SECTION B  Exposure by Loan Type
--3 Loan Type Exposure
SELECT
    loan_type,
    COUNT(*) AS loan_count,
    ROUND(SUM(loan_amount), 2) AS total_loan_amount,
    ROUND(SUM(outstanding_amount), 2) AS total_outstanding_amount,
    ROUND(AVG(outstanding_amount), 2) AS average_outstanding_amount
FROM loans
GROUP BY loan_type
ORDER BY total_outstanding_amount DESC;

--4 Loan Type Outstanding Percentage
SELECT
    loan_type,

    ROUND(
        SUM(outstanding_amount),
        2
    ) AS outstanding_amount,

    ROUND(
        SUM(outstanding_amount) * 100.0 /
        (SELECT SUM(outstanding_amount) FROM loans),
        2
    ) AS portfolio_share_percentage

FROM loans

GROUP BY loan_type

ORDER BY outstanding_amount DESC;

--SECTION C  Exposure by Region
--5 Regional Loan Exposure
SELECT
    c.region,

    COUNT(l.loan_id) AS loan_count,

    ROUND(
        SUM(l.loan_amount),
        2
    ) AS total_loan_amount,

    ROUND(
        SUM(l.outstanding_amount),
        2
    ) AS total_outstanding_amount,

    ROUND(
        AVG(l.outstanding_amount),
        2
    ) AS average_outstanding_amount

FROM customers AS c

INNER JOIN loans AS l
    ON c.customer_id = l.customer_id

GROUP BY c.region

ORDER BY total_outstanding_amount DESC;

--6 Regional Portfolio Share
SELECT
    c.region,

    ROUND(
        SUM(l.outstanding_amount),
        2
    ) AS outstanding_amount,

    ROUND(
        SUM(l.outstanding_amount) * 100.0 /
        (SELECT SUM(outstanding_amount) FROM loans),
        2
    ) AS portfolio_share_percentage

FROM customers AS c

INNER JOIN loans AS l
    ON c.customer_id = l.customer_id

GROUP BY c.region

ORDER BY outstanding_amount DESC;

--SECTION D  Customer Segment Exposure
--7. Exposure by Customer Segment
SELECT
    c.customer_segment,

    COUNT(DISTINCT c.customer_id) AS customer_count,

    COUNT(l.loan_id) AS loan_count,

    ROUND(
        SUM(l.loan_amount),
        2
    ) AS total_loan_amount,

    ROUND(
        SUM(l.outstanding_amount),
        2
    ) AS total_outstanding_amount,

    ROUND(
        AVG(l.outstanding_amount),
        2
    ) AS average_outstanding_amount

FROM customers AS c

INNER JOIN loans AS l
    ON c.customer_id = l.customer_id

GROUP BY c.customer_segment

ORDER BY total_outstanding_amount DESC;

--8 Segment portfolio share
SELECT
    c.customer_segment,

    ROUND(
        SUM(l.outstanding_amount),
        2
    ) AS outstanding_amount,

    ROUND(
        SUM(l.outstanding_amount) * 100.0 /
        (SELECT SUM(outstanding_amount) FROM loans),
        2
    ) AS portfolio_share_percentage

FROM customers AS c

INNER JOIN loans AS l
    ON c.customer_id = l.customer_id

GROUP BY c.customer_segment

ORDER BY outstanding_amount DESC;

--SECTION E Loan Status Exposur
--9 Outstanding amount by loan status
SELECT
    loan_status,

    COUNT(*) AS loan_count,

    ROUND(
        SUM(loan_amount),
        2
    ) AS total_loan_amount,

    ROUND(
        SUM(outstanding_amount),
        2
    ) AS total_outstanding_amount,

    ROUND(
        AVG(outstanding_amount),
        2
    ) AS average_outstanding_amount

FROM loans

GROUP BY loan_status

ORDER BY total_outstanding_amount DESC;

--SECTION F Customers With Multiple Loans
--10. Customers With Multiple Loans
SELECT
    c.customer_id,
    c.customer_segment,
    c.region,

    COUNT(l.loan_id) AS loan_count,

    ROUND(
        SUM(l.outstanding_amount),
        2
    ) AS total_outstanding

FROM customers AS c

INNER JOIN loans AS l
    ON c.customer_id = l.customer_id

GROUP BY
    c.customer_id,
    c.customer_segment,
    c.region

HAVING COUNT(l.loan_id) > 1

ORDER BY total_outstanding DESC;

--11. Highest Borrowing Customers
SELECT
    c.customer_id,
    c.customer_segment,
    c.region,

    COUNT(l.loan_id) AS loan_count,

    ROUND(
        SUM(l.loan_amount),
        2
    ) AS total_borrowed,

    ROUND(
        SUM(l.outstanding_amount),
        2
    ) AS total_outstanding

FROM customers AS c

INNER JOIN loans AS l
    ON c.customer_id = l.customer_id

GROUP BY
    c.customer_id,
    c.customer_segment,
    c.region

ORDER BY total_outstanding DESC
LIMIT 20;

--SECTION G  Customers With No Loans
--12 Customers without loans
SELECT
    c.customer_id,
    c.customer_segment,
    c.region,
    c.annual_income

FROM customers AS c

WHERE NOT EXISTS (
    SELECT 1
    FROM loans AS l
    WHERE l.customer_id = c.customer_id
);

--13 Counting customer wuthout loan
SELECT
    COUNT(*) AS customers_without_loans
FROM customers AS c

WHERE NOT EXISTS (
    SELECT 1
    FROM loans AS l
    WHERE l.customer_id = c.customer_id
);

--SECTION H  Exposure + Payment Behavior
--14 Customer exposure & payment behaviour 
--14 Customer Exposure & Payment Behavior

WITH customer_exposure AS (

    SELECT
        customer_id,
        COUNT(*) AS loan_count,
        SUM(outstanding_amount) AS total_outstanding
    FROM loans
    GROUP BY customer_id

),

customer_payments AS (

    SELECT
        l.customer_id,

        COUNT(lp.payment_id) AS payment_count,

        COUNT(
            CASE
                WHEN lp.days_late > 0
                THEN 1
            END
        ) AS late_payment_count,

        MAX(lp.days_late) AS maximum_days_late

    FROM loans AS l

    LEFT JOIN loan_payments AS lp
        ON l.loan_id = lp.loan_id

    GROUP BY l.customer_id

)

SELECT
    c.customer_id,
    c.customer_segment,
    c.region,

    COALESCE(ce.loan_count, 0) AS loan_count,

    ROUND(
        COALESCE(ce.total_outstanding, 0),
        2
    ) AS total_outstanding,

    COALESCE(cp.payment_count, 0)
        AS payment_count,

    COALESCE(cp.late_payment_count, 0)
        AS late_payment_count,

    COALESCE(cp.maximum_days_late, 0)
        AS maximum_days_late,

    ROUND(
        COALESCE(cp.late_payment_count, 0) * 100.0 /
        NULLIF(cp.payment_count, 0),
        2
    ) AS late_payment_rate

FROM customers AS c

LEFT JOIN customer_exposure AS ce
    ON c.customer_id = ce.customer_id

LEFT JOIN customer_payments AS cp
    ON c.customer_id = cp.customer_id

ORDER BY total_outstanding DESC;

--SECTION I High Exposure + Payment Concerns
--15 Customers With High Exposure and Late Payments

WITH customer_exposure AS (

    SELECT
        customer_id,
        SUM(outstanding_amount) AS total_outstanding
    FROM loans
    GROUP BY customer_id

),

customer_payments AS (

    SELECT
        l.customer_id,

        COUNT(lp.payment_id) AS payment_count,

        COUNT(
            CASE
                WHEN lp.days_late > 0
                THEN 1
            END
        ) AS late_payment_count,

        MAX(lp.days_late) AS maximum_days_late

    FROM loans AS l

    LEFT JOIN loan_payments AS lp
        ON l.loan_id = lp.loan_id

    GROUP BY l.customer_id

)

SELECT
    c.customer_id,
    c.customer_segment,
    c.region,

    ROUND(
        ce.total_outstanding,
        2
    ) AS total_outstanding,

    cp.payment_count,
    cp.late_payment_count,

    COALESCE(
        cp.maximum_days_late,
        0
    ) AS maximum_days_late,

    ROUND(
        cp.late_payment_count * 100.0 /
        NULLIF(cp.payment_count, 0),
        2
    ) AS late_payment_rate

FROM customers AS c

INNER JOIN customer_exposure AS ce
    ON c.customer_id = ce.customer_id

INNER JOIN customer_payments AS cp
    ON c.customer_id = cp.customer_id

WHERE cp.late_payment_count > 0

ORDER BY
    ce.total_outstanding DESC,
    cp.late_payment_count DESC;

--SECTION J Segment-Level Payment Risk
--16 Segment Exposure + Late Payment Rate
WITH segment_exposure AS (

    SELECT
        c.customer_segment,

        COUNT(DISTINCT c.customer_id)
            AS customer_count,

        COUNT(l.loan_id)
            AS loan_count,

        SUM(l.outstanding_amount)
            AS total_outstanding

    FROM customers AS c

    INNER JOIN loans AS l
        ON c.customer_id = l.customer_id

    GROUP BY c.customer_segment

),

segment_payments AS (

    SELECT
        c.customer_segment,

        COUNT(lp.payment_id)
            AS payment_count,

        COUNT(
            CASE
                WHEN lp.days_late > 0
                THEN 1
            END
        ) AS late_payment_count

    FROM customers AS c

    INNER JOIN loans AS l
        ON c.customer_id = l.customer_id

    LEFT JOIN loan_payments AS lp
        ON l.loan_id = lp.loan_id

    GROUP BY c.customer_segment

)

SELECT
    se.customer_segment,
    se.customer_count,
    se.loan_count,

    ROUND(
        se.total_outstanding,
        2
    ) AS total_outstanding,

    sp.payment_count,
    sp.late_payment_count,

    ROUND(
        sp.late_payment_count * 100.0 /
        NULLIF(sp.payment_count, 0),
        2
    ) AS late_payment_rate

FROM segment_exposure AS se

LEFT JOIN segment_payments AS sp
    ON se.customer_segment = sp.customer_segment

ORDER BY total_outstanding DESC;

--SECTION L Rank Regions by Exposure
--17 Regional Risk-Oriented Summary

WITH regional_exposure AS (

    SELECT
        c.region,

        COUNT(DISTINCT c.customer_id)
            AS customer_count,

        COUNT(l.loan_id)
            AS loan_count,

        SUM(l.outstanding_amount)
            AS total_outstanding

    FROM customers AS c

    INNER JOIN loans AS l
        ON c.customer_id = l.customer_id

    GROUP BY c.region

),

regional_payments AS (

    SELECT
        c.region,

        COUNT(lp.payment_id)
            AS payment_count,

        COUNT(
            CASE
                WHEN lp.days_late > 0
                THEN 1
            END
        ) AS late_payment_count

    FROM customers AS c

    INNER JOIN loans AS l
        ON c.customer_id = l.customer_id

    LEFT JOIN loan_payments AS lp
        ON l.loan_id = lp.loan_id

    GROUP BY c.region

)

SELECT
    re.region,
    re.customer_count,
    re.loan_count,

    ROUND(
        re.total_outstanding,
        2
    ) AS total_outstanding,

    rp.payment_count,
    rp.late_payment_count,

    ROUND(
        rp.late_payment_count * 100.0 /
        NULLIF(rp.payment_count, 0),
        2
    ) AS late_payment_rate

FROM regional_exposure AS re

LEFT JOIN regional_payments AS rp
    ON re.region = rp.region

ORDER BY total_outstanding DESC;

--SECTION M  Rank Loan Types by Exposure
SELECT
    loan_type,

    ROUND(
        SUM(outstanding_amount),
        2
    ) AS total_outstanding,

    RANK() OVER (
        ORDER BY SUM(outstanding_amount) DESC
    ) AS exposure_rank

FROM loans

GROUP BY loan_type

ORDER BY exposure_rank;

--SECTION N Final Risk Portfolio Summary
SELECT
    COUNT(*) AS total_loans,

    COUNT(
        DISTINCT customer_id
    ) AS customers_with_loans,

    ROUND(
        SUM(loan_amount),
        2
    ) AS total_loan_amount,

    ROUND(
        SUM(outstanding_amount),
        2
    ) AS total_outstanding_amount,

    ROUND(
        AVG(outstanding_amount),
        2
    ) AS average_outstanding_amount,

    ROUND(
        SUM(outstanding_amount) * 100.0 /
        NULLIF(SUM(loan_amount), 0),
        2
    ) AS outstanding_percentage

FROM loans;

--9.2 Executive KPIs
SELECT
    (SELECT COUNT(*)
     FROM customers) AS total_customers,

    (SELECT COUNT(*)
     FROM accounts) AS total_accounts,

    (SELECT COUNT(*)
     FROM loans) AS total_loans,

    (SELECT ROUND(SUM(loan_amount), 2)
     FROM loans) AS total_loan_amount,

    (SELECT ROUND(SUM(outstanding_amount), 2)
     FROM loans) AS total_outstanding_amount,

    (SELECT COUNT(*)
     FROM loan_applications) AS total_applications,

    (SELECT ROUND(SUM(payment_amount), 2)
     FROM loan_payments) AS total_payments,

    (SELECT
        ROUND(
            COUNT(
                CASE
                    WHEN days_late > 0 THEN 1
                END
            ) * 100.0 / NULLIF(COUNT(*), 0),
            2
        )
     FROM loan_payments) AS late_payment_rate;

--9.3 Customer segment dataset
SELECT
    c.customer_segment,

    COUNT(DISTINCT c.customer_id)
        AS customer_count,

    COUNT(DISTINCT l.loan_id)
        AS loan_count,

    ROUND(
        SUM(l.loan_amount),
        2
    ) AS total_loan_amount,

    ROUND(
        SUM(l.outstanding_amount),
        2
    ) AS total_outstanding_amount,

    ROUND(
        AVG(l.outstanding_amount),
        2
    ) AS average_outstanding_amount

FROM customers AS c

LEFT JOIN loans AS l
    ON c.customer_id = l.customer_id

GROUP BY c.customer_segment

ORDER BY total_outstanding_amount DESC;

--9.4 Regional exposure dataset
SELECT
    c.region,

    COUNT(DISTINCT c.customer_id)
        AS customer_count,

    COUNT(DISTINCT l.loan_id)
        AS loan_count,

    ROUND(
        SUM(l.loan_amount),
        2
    ) AS total_loan_amount,

    ROUND(
        SUM(l.outstanding_amount),
        2
    ) AS total_outstanding_amount,

    ROUND(
        AVG(l.outstanding_amount),
        2
    ) AS average_outstanding_amount

FROM customers AS c

LEFT JOIN loans AS l
    ON c.customer_id = l.customer_id

GROUP BY c.region

ORDER BY total_outstanding_amount DESC;

--9.5 Loan type performance
SELECT
    loan_type,

    COUNT(*) AS loan_count,

    ROUND(
        SUM(loan_amount),
        2
    ) AS total_loan_amount,

    ROUND(
        SUM(outstanding_amount),
        2
    ) AS total_outstanding_amount,

    ROUND(
        AVG(loan_amount),
        2
    ) AS average_loan_amount,

    ROUND(
        AVG(outstanding_amount),
        2
    ) AS average_outstanding_amount,

    ROUND(
        AVG(interest_rate),
        2
    ) AS average_interest_rate

FROM loans

GROUP BY loan_type

ORDER BY total_outstanding_amount DESC;

--9.6 Loan status dataset
SELECT
    loan_status,

    COUNT(*) AS loan_count,

    ROUND(
        SUM(loan_amount),
        2
    ) AS total_loan_amount,

    ROUND(
        SUM(outstanding_amount),
        2
    ) AS total_outstanding_amount,

    ROUND(
        AVG(outstanding_amount),
        2
    ) AS average_outstanding_amount

FROM loans

GROUP BY loan_status

ORDER BY loan_count DESC;

--9.7 Application funnel dataset
SELECT
    application_status,

    COUNT(*) AS application_count,

    ROUND(
        AVG(requested_amount),
        2
    ) AS average_requested_amount,

    ROUND(
        SUM(requested_amount),
        2
    ) AS total_requested_amount

FROM loan_applications

GROUP BY application_status

ORDER BY application_count DESC;

--9.8 Application trend dataset
SELECT
    DATE_TRUNC(
        'month',
        application_date
    )::DATE AS application_month,

    COUNT(*) AS application_count,

    ROUND(
        SUM(requested_amount),
        2
    ) AS total_requested_amount,

    ROUND(
        AVG(requested_amount),
        2
    ) AS average_requested_amount

FROM loan_applications

GROUP BY
    DATE_TRUNC(
        'month',
        application_date
    )

ORDER BY application_month;

--9.9 Payment behaviour dataset
SELECT
    payment_status,

    COUNT(*) AS payment_count,

    ROUND(
        SUM(payment_amount),
        2
    ) AS total_payment_amount,

    ROUND(
        AVG(payment_amount),
        2
    ) AS average_payment_amount,

    ROUND(
        AVG(days_late),
        2
    ) AS average_days_late

FROM loan_payments

GROUP BY payment_status

ORDER BY payment_count DESC;

--9.10 Deliquency dataset
SELECT
   CASE
    WHEN days_late IS NULL
        THEN 'Unknown'

    WHEN days_late = 0
        THEN 'On Time'

    WHEN days_late BETWEEN 1 AND 7
        THEN '1-7 Days Late'

    WHEN days_late BETWEEN 8 AND 30
        THEN '8-30 Days Late'

    WHEN days_late BETWEEN 31 AND 60
        THEN '31-60 Days Late'

    ELSE '61+ Days Late'
END

    COUNT(*) AS payment_count,

    ROUND(
        SUM(payment_amount),
        2
    ) AS payment_amount,

    ROUND(
        AVG(days_late),
        2
    ) AS average_days_late

FROM loan_payments

GROUP BY
    CASE
    WHEN days_late IS NULL
        THEN 'Unknown'

    WHEN days_late = 0
        THEN 'On Time'

    WHEN days_late BETWEEN 1 AND 7
        THEN '1-7 Days Late'

    WHEN days_late BETWEEN 8 AND 30
        THEN '8-30 Days Late'

    WHEN days_late BETWEEN 31 AND 60
        THEN '31-60 Days Late'

    ELSE '61+ Days Late'
END

ORDER BY
    MIN(days_late);

--9.11 Segment Payment Behavior
WITH segment_exposure AS (

    SELECT
        c.customer_segment,

        COUNT(DISTINCT c.customer_id)
            AS customer_count,

        COUNT(DISTINCT l.loan_id)
            AS loan_count,

        SUM(l.outstanding_amount)
            AS total_outstanding

    FROM customers AS c

    INNER JOIN loans AS l
        ON c.customer_id = l.customer_id

    GROUP BY c.customer_segment

),

segment_payments AS (

    SELECT
        c.customer_segment,

        COUNT(lp.payment_id)
            AS payment_count,

        COUNT(
            CASE
                WHEN lp.days_late > 0
                THEN 1
            END
        ) AS late_payment_count

    FROM customers AS c

    INNER JOIN loans AS l
        ON c.customer_id = l.customer_id

    LEFT JOIN loan_payments AS lp
        ON l.loan_id = lp.loan_id

    GROUP BY c.customer_segment

)

SELECT
    se.customer_segment,
    se.customer_count,
    se.loan_count,

    sp.payment_count,
    sp.late_payment_count,

    ROUND(
        sp.late_payment_count * 100.0 /
        NULLIF(sp.payment_count, 0),
        2
    ) AS late_payment_rate,

    ROUND(
        se.total_outstanding,
        2
    ) AS total_outstanding

FROM segment_exposure AS se

LEFT JOIN segment_payments AS sp
    ON se.customer_segment = sp.customer_segment

ORDER BY total_outstanding DESC;

--9.13 Customer risk overview
WITH loan_summary AS (

    SELECT
        customer_id,

        COUNT(*) AS loan_count,

        SUM(loan_amount) AS total_borrowed,

        SUM(outstanding_amount) AS total_outstanding

    FROM loans

    GROUP BY customer_id

),

payment_summary AS (

    SELECT
        l.customer_id,

        COUNT(lp.payment_id)
            AS payment_count,

        COUNT(
            CASE
                WHEN lp.days_late > 0
                THEN 1
            END
        ) AS late_payment_count,

        MAX(lp.days_late)
            AS maximum_days_late

    FROM loans AS l

    LEFT JOIN loan_payments AS lp
        ON l.loan_id = lp.loan_id

    GROUP BY l.customer_id

)

SELECT
    c.customer_id,
    c.customer_segment,
    c.region,

    COALESCE(
        ls.loan_count,
        0
    ) AS loan_count,

    ROUND(
        COALESCE(ls.total_borrowed, 0),
        2
    ) AS total_borrowed,

    ROUND(
        COALESCE(ls.total_outstanding, 0),
        2
    ) AS total_outstanding,

    COALESCE(
        ps.payment_count,
        0
    ) AS payment_count,

    COALESCE(
        ps.late_payment_count,
        0
    ) AS late_payment_count,

    COALESCE(
        ps.maximum_days_late,
        0
    ) AS maximum_days_late,

    ROUND(
        COALESCE(ps.late_payment_count, 0)
        * 100.0 /
        NULLIF(ps.payment_count, 0),
        2
    ) AS late_payment_rate,

    CASE

        WHEN COALESCE(ps.late_payment_count, 0) >= 5
             AND COALESCE(ps.maximum_days_late, 0) >= 30
            THEN 'High Payment Concern'

        WHEN COALESCE(ps.late_payment_count, 0) >= 3
            THEN 'Repeated Late Payments'

        WHEN COALESCE(ps.late_payment_count, 0) > 0
            THEN 'Occasional Late Payments'

        ELSE 'No Late Payments'

    END AS payment_behavior_flag

FROM customers AS c

LEFT JOIN loan_summary AS ls
    ON c.customer_id = ls.customer_id

LEFT JOIN payment_summary AS ps
    ON c.customer_id = ps.customer_id

ORDER BY total_outstanding DESC;

--9.14 Top 20 exposure customer
WITH customer_exposure AS (

    SELECT
        c.customer_id,
        c.customer_segment,
        c.region,

        COUNT(l.loan_id)
            AS loan_count,

        SUM(l.loan_amount)
            AS total_borrowed,

        SUM(l.outstanding_amount)
            AS total_outstanding

    FROM customers AS c

    INNER JOIN loans AS l
        ON c.customer_id = l.customer_id

    GROUP BY
        c.customer_id,
        c.customer_segment,
        c.region
)

SELECT
    customer_id,
    customer_segment,
    region,
    loan_count,

    ROUND(
        total_borrowed,
        2
    ) AS total_borrowed,

    ROUND(
        total_outstanding,
        2
    ) AS total_outstanding

FROM customer_exposure

ORDER BY total_outstanding DESC

LIMIT 20;

--9.15 Top 20 customer by late payment
SELECT
    c.customer_id,
    c.customer_segment,
    c.region,

    COUNT(lp.payment_id)
        AS payment_count,

    COUNT(
        CASE
            WHEN lp.days_late > 0
            THEN 1
        END
    ) AS late_payment_count,

    ROUND(
        AVG(lp.days_late),
        2
    ) AS average_days_late

FROM customers AS c

INNER JOIN loans AS l
    ON c.customer_id = l.customer_id

INNER JOIN loan_payments AS lp
    ON l.loan_id = lp.loan_id

GROUP BY
    c.customer_id,
    c.customer_segment,
    c.region

ORDER BY late_payment_count DESC

LIMIT 20;





