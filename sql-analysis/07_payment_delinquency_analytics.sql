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