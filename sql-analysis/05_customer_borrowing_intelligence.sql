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