WITH activity_log_with_session_click_conversion_flag AS (
    SELECT
        session,
        stamp,
        path,
        search_type,
        SIGN(
            SUM(
                CASE
                    WHEN path = '/detail' THEN 1
                    ELSE 0
                END
            ) OVER(
                PARTITION BY session
                ORDER BY
                    stamp DESC ROWS BETWEEN UNBOUNDED PRECEDING
                    AND CURRENT ROW
            )
        ) AS has_session_click,
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
        ) AS has_session_conversion
    FROM
        activity_log
)
SELECT
    session,
    stamp,
    path,
    search_type,
    has_session_click AS click,
    has_session_conversion AS cnv
FROM
    activity_log_with_session_click_conversion_flag
ORDER BY
    session,
    stamp;

WITH activity_log_with_session_click_conversion_flag AS (
    SELECT
        session,
        stamp,
        path,
        search_type,
        SIGN(
            SUM(
                CASE
                    WHEN path = '/detail' THEN 1
                    ELSE 0
                END
            ) OVER(
                PARTITION BY session
                ORDER BY
                    stamp DESC ROWS BETWEEN UNBOUNDED PRECEDING
                    AND CURRENT ROW
            )
        ) AS has_session_click,
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
        ) AS has_session_conversion
    FROM
        activity_log
)
SELECT
    search_type,
    COUNT(1) AS count,
    SUM(has_session_click) AS detail,
    AVG(has_session_click) AS ctr,
    SUM(
        CASE
            WHEN has_session_click = 1 THEN has_session_conversion
        END
    ) AS conversion,
    AVG(
        CASE
            WHEN has_session_click = 1 THEN has_session_conversion
        END
    ) AS cvr
FROM
    activity_log_with_session_click_conversion_flag
WHERE
    path = '/search_list'
GROUP BY
    search_type
ORDER BY
    count DESC;

WITH activity_log_with_session_click_conversion_flag AS (
    SELECT
        session,
        stamp,
        path,
        search_type,
        CASE
            WHEN LAG(path) OVER(
                PARTITION BY session
                ORDER BY
                    stamp DESC
            ) = '/detail' THEN 1
            ELSE 0
        END AS has_session_click,
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
        ) AS has_session_conversion
    FROM
        activity_log
)
SELECT
    session,
    stamp,
    path,
    search_type,
    has_session_click AS click,
    has_session_conversion AS cnv
FROM
    activity_log_with_session_click_conversion_flag
ORDER BY
    session,
    stamp;
