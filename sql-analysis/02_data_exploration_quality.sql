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