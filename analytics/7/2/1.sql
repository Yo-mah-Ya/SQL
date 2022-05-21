-- detect invalid data
WITH session_count AS (
    SELECT
        SESSION,
        COUNT(1) AS count
    FROM
        action_log_with_noise
    GROUP BY
        SESSION
)
SELECT
    SESSION,
    count,
    RANK() OVER(
        ORDER BY
            count DESC
    ) AS rank,
    PERCENT_RANK() OVER(
        ORDER BY
            count DESC
    ) AS percent_rank
FROM
    session_count;

WITH url_count AS (
    SELECT
        url,
        COUNT(*) AS count
    FROM
        action_log_with_noise
    GROUP BY
        url
)
SELECT
    url,
    count,
    RANK() OVER(
        ORDER BY
            count ASC
    ) AS rank,
    PERCENT_RANK() OVER(
        ORDER BY
            count ASC
    )
FROM
    url_count;
