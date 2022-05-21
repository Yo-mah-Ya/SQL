WITH access_log_with_next_action AS (
    SELECT
        stamp,
        SESSION,
        ACTION,
        keyword,
        result_num,
        LEAD(ACTION) OVER(
            PARTITION BY SESSION
            ORDER BY
                stamp ASC
        ) AS next_action,
        LEAD(keyword) OVER(
            PARTITION BY SESSION
            ORDER BY
                stamp ASC
        ) AS next_keyword,
        LEAD(result_num) OVER(
            PARTITION BY SESSION
            ORDER BY
                stamp ASC
        ) AS next_result_num
    FROM
        access_log
)
SELECT
    SUBSTRING(stamp :: TEXT, 1, 10) AS dt,
    COUNT(1) AS search_count,
    SUM(
        CASE
            WHEN next_action IS NULL THEN 1
            ELSE 0
        END
    ) AS exit_count,
    AVG(
        CASE
            WHEN next_action IS NULL THEN 1.
            ELSE 0.
        END
    ) AS exit_rate
FROM
    access_log_with_next_action
WHERE
    ACTION = 'search'
GROUP BY
    dt
ORDER BY
    dt;

-- Re-search word
WITH access_log_with_next_action AS (
    SELECT
        stamp,
        SESSION,
        ACTION,
        keyword,
        result_num,
        LEAD(ACTION) OVER(
            PARTITION BY SESSION
            ORDER BY
                stamp ASC
        ) AS next_action,
        LEAD(keyword) OVER(
            PARTITION BY SESSION
            ORDER BY
                stamp ASC
        ) AS next_keyword,
        LEAD(result_num) OVER(
            PARTITION BY SESSION
            ORDER BY
                stamp ASC
        ) AS next_result_num
    FROM
        access_log
)
SELECT
    keyword,
    COUNT(1) AS search_count,
    SUM(
        CASE
            WHEN next_action IS NULL THEN 1
            ELSE 0
        END
    ) AS exit_count,
    AVG(
        CASE
            WHEN next_action IS NULL THEN 1.
            ELSE 0.
        END
    ) AS exit_rate
FROM
    access_log_with_next_action
WHERE
    ACTION = 'search'
GROUP BY
    keyword,
    result_num
HAVING
    SUM(
        CASE
            WHEN next_action IS NULL THEN 1
            ELSE 0
        END
    ) > 0;
