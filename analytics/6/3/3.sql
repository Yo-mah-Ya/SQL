-- Bounce Rate
WITH form_with_progress_flag AS (
    SELECT
        SUBSTRING(stamp, 1, 10) AS dt,
        SESSION,
        SIGN(
            SUM(
                CASE
                    WHEN path IN ('/regist/input') THEN 1
                    ELSE 0
                END
            )
        ) AS has_input,
        SIGN(
            SUM(
                CASE
                    WHEN path IN ('/regist/confirm', '/regist/complete') THEN 1
                    ELSE 0
                END
            )
        ) AS has_progress
    FROM
        form_log
    GROUP BY
        dt,
        SESSION
)
SELECT
    dt,
    COUNT(1) AS input_count,
    SUM(
        CASE
            WHEN has_progress = 0 THEN 1
            ELSE 0
        END
    ) AS bounce_count,
    100.* AVG(
        CASE
            WHEN has_progress = 0 THEN 1
            ELSE 0
        END
    ) AS bounce_rate
FROM
    form_with_progress_flag
WHERE
    has_input = 1
GROUP BY
    dt;
