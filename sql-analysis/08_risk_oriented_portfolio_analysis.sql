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