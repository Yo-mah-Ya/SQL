WITH activity_log_with_landing_exit AS(
    SELECT
        session,
        path,
        stamp,
        FIRST_VALUE(path) OVER(
            PARTITION BY session
            ORDER BY
                stamp ASC ROWS BETWEEN UNBOUNDED PRECEDING
                AND UNBOUNDED FOLLOWING
        ) AS landing,
        LAST_VALUE(path) OVER(
            PARTITION BY session
            ORDER BY
                stamp ASC ROWS BETWEEN UNBOUNDED PRECEDING
                AND UNBOUNDED FOLLOWING
        ) AS exit
    FROM
        activity_log
),
landing_count AS (
    SELECT
        landing AS path,
        COUNT(DISTINCT session) AS count
    FROM
        activity_log_with_landing_exit
    GROUP BY
        landing
),
exit_count AS (
    SELECT
        exit AS path,
        COUNT(DISTINCT session) AS count
    FROM
        activity_log_with_landing_exit
    GROUP BY
        exit
)
SELECT
    'landing' AS TYPE,
    *
FROM
    landing_count
UNION
ALL
SELECT
    'exit' AS TYPE,
    *
FROM
    exit_count;

WITH activity_log_with_landing_exit AS(
    SELECT
        session,
        path,
        stamp,
        FIRST_VALUE(path) OVER(
            PARTITION BY session
            ORDER BY
                stamp ASC ROWS BETWEEN UNBOUNDED PRECEDING
                AND UNBOUNDED FOLLOWING
        ) AS landing,
        LAST_VALUE(path) OVER(
            PARTITION BY session
            ORDER BY
                stamp ASC ROWS BETWEEN UNBOUNDED PRECEDING
                AND UNBOUNDED FOLLOWING
        ) AS exit
    FROM
        activity_log
)
SELECT
    landing,
    exit,
    COUNT(DISTINCT session) AS count
FROM
    activity_log_with_landing_exit
GROUP BY
    landing,
    exit;
