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