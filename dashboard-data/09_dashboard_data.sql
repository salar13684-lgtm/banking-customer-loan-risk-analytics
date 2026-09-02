--Phase 9
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
