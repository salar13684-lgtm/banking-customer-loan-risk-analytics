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
