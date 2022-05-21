WITH activity_log_with_conversion_flag AS (
    SELECT
        session,
        stamp,
        path,
        SIGN(
            SUM(
                CASE
                    WHEN path = '/complete' THEN 1
                    ELSE 0
                END
            ) OVER(
                PARTITION BY session
                ORDER BY
                    stamp DESC ROWS BETWEEN UNBOUNDED PRECEDING
                    AND CURRENT ROW
            )
        ) AS has_conversion
    FROM
        activity_log
),
activity_log_with_conversion_assign AS (
    SELECT
        session,
        stamp,
        path,
        ROW_NUMBER() OVER(
            PARTITION BY session
            ORDER BY
                stamp ASC
        ) AS asc_order,
        ROW_NUMBER() OVER(
            PARTITION BY session
            ORDER BY
                stamp DESC
        ) AS desc_order,
        COUNT(1) OVER(PARTITION BY session) AS page_count,
        1000./ COUNT(1) OVER(PARTITION BY session) AS fair_assign,
        CASE
            WHEN ROW_NUMBER() OVER(
                PARTITION BY session
                ORDER BY
                    stamp ASC
            ) = 1 THEN 1000.
            ELSE 0.
        END AS first_assign,
        CASE
            WHEN ROW_NUMBER() OVER(
                PARTITION BY session
                ORDER BY
                    stamp DESC
            ) = 1 THEN 1000.
            ELSE 0.
        END AS last_assign,
        1000.* ROW_NUMBER() OVER(
            PARTITION BY session
            ORDER BY
                stamp ASC
        ) / (
            COUNT(1) OVER(PARTITION BY session) * (COUNT(1) OVER(PARTITION BY session) + 1) / 2
        ) AS decrease_assign,
        1000.* ROW_NUMBER() OVER(
            PARTITION BY session
            ORDER BY
                stamp DESC
        ) / (
            COUNT(1) OVER(PARTITION BY session) * (COUNT(1) OVER(PARTITION BY session) + 1) / 2
        ) AS increase_assign
    FROM
        activity_log_with_conversion_flag
    WHERE
        has_conversion = 1
        AND path NOT IN ('/input', '/confirm', '/complete')
)
SELECT
    session,
    asc_order,
    path,
    fair_assign AS fair_a,
    first_assign AS first_a,
    last_assign AS last_a,
    decrease_assign AS des_a,
    increase_assign AS inc_a
FROM
    activity_log_with_conversion_assign
ORDER BY
    session,
    asc_order;

WITH activity_log_with_conversion_flag AS (
    SELECT
        session,
        stamp,
        path,
        SIGN(
            SUM(
                CASE
                    WHEN path = '/complete' THEN 1
                    ELSE 0
                END
            ) OVER(
                PARTITION BY session
                ORDER BY
                    stamp DESC ROWS BETWEEN UNBOUNDED PRECEDING
                    AND CURRENT ROW
            )
        ) AS has_conversion
    FROM
        activity_log
),
activity_log_with_conversion_assign AS (
    SELECT
        session,
        stamp,
        path,
        ROW_NUMBER() OVER(
            PARTITION BY session
            ORDER BY
                stamp ASC
        ) AS asc_order,
        ROW_NUMBER() OVER(
            PARTITION BY session
            ORDER BY
                stamp DESC
        ) AS desc_order,
        COUNT(1) OVER(PARTITION BY session) AS page_count,
        1000./ COUNT(1) OVER(PARTITION BY session) AS fair_assign,
        CASE
            WHEN ROW_NUMBER() OVER(
                PARTITION BY session
                ORDER BY
                    stamp ASC
            ) = 1 THEN 1000.
            ELSE 0.
        END AS first_assign,
        CASE
            WHEN ROW_NUMBER() OVER(
                PARTITION BY session
                ORDER BY
                    stamp DESC
            ) = 1 THEN 1000.
            ELSE 0.
        END AS last_assign,
        1000.* ROW_NUMBER() OVER(
            PARTITION BY session
            ORDER BY
                stamp ASC
        ) / (
            COUNT(1) OVER(PARTITION BY session) * (COUNT(1) OVER(PARTITION BY session) + 1) / 2
        ) AS decrease_assign,
        1000.* ROW_NUMBER() OVER(
            PARTITION BY session
            ORDER BY
                stamp DESC
        ) / (
            COUNT(1) OVER(PARTITION BY session) * (COUNT(1) OVER(PARTITION BY session) + 1) / 2
        ) AS increase_assign
    FROM
        activity_log_with_conversion_flag
    WHERE
        has_conversion = 1
        AND path NOT IN ('/input', '/confirm', '/complete')
),
page_total_values AS (
    SELECT
        path,
        SUM(fair_assign) AS sum_fair,
        SUM(first_assign) AS sum_first,
        SUM(last_assign) AS sum_last,
        SUM(increase_assign) AS sum_inc,
        SUM(decrease_assign) AS sum_dec
    FROM
        activity_log_with_conversion_assign
    GROUP BY
        path
),
page_total_cnt AS (
    SELECT
        path,
        COUNT(1) AS access_cnt
    FROM
        activity_log
    GROUP BY
        path
)
SELECT
    s.path,
    s.access_cnt / s.access_cnt AS avg_fair,
    v.sum_fair / s.access_cnt AS avg_first,
    v.sum_first / s.access_cnt AS avg_last,
    v.sum_last / s.access_cnt AS avg_dec,
    v.sum_dec / s.access_cnt AS avg_dec,
    v.sum_inc / s.access_cnt AS avg_inc
FROM
    page_total_cnt AS s
    JOIN page_total_values AS v ON s.path = v.path
ORDER BY
    s.access_cnt DESC;
