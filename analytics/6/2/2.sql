-- Abandonment Rate
WITH activity_log_with_exit_flag AS (
    SELECT
        *,
        CASE
            WHEN ROW_NUMBER() OVER(
                PARTITION BY session
                ORDER BY
                    stamp DESC
            ) = 1 THEN 1
            ELSE 0
        END AS is_exit
    FROM
        activity_log
)
SELECT
    path,
    SUM(is_exit) AS exit_count,
    COUNT(1) AS page_view,
    AVG(100.* is_exit) AS exit_ratio
FROM
    activity_log_with_exit_flag
GROUP BY
    path;

-- Bounce Rate
WITH activity_log_with_landing_bounce_flag AS (
    SELECT
        *,
        CASE
            WHEN ROW_NUMBER() OVER(
                PARTITION BY session
                ORDER BY
                    stamp ASC
            ) = 1 THEN 1
            ELSE 0
        END AS is_landing,
        CASE
            WHEN COUNT(1) OVER(PARTITION BY session) = 1 THEN 1
            ELSE 0
        END AS is_bounce
    FROM
        activity_log
)
SELECT
    path,
    SUM(is_bounce) AS bounce_count,
    SUM(is_landing) AS landing_count,
    AVG(
        100.* CASE
            WHEN is_landing = 1 THEN is_bounce
        END
    ) AS bounce_ratio
FROM
    activity_log_with_landing_bounce_flag
GROUP BY
    path;
