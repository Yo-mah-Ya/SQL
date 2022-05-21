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
)
SELECT
    *
FROM
    activity_log_with_conversion_flag
ORDER BY
    session,
    stamp;

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
)
SELECT
    path,
    COUNT(DISTINCT session) AS sessions,
    SUM(has_conversion) AS conversions,
    1.* SUM(has_conversion) / COUNT(DISTINCT session) AS cvr
FROM
    activity_log_with_conversion_flag
GROUP BY
    path;
