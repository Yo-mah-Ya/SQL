SELECT
    SUBSTRING(stamp :: TEXT, 1, 10) AS dt,
    COUNT(1) AS search_count,
    SUM(
        CASE
            WHEN result_num = 0 THEN 1
            ELSE 0
        END
    ) AS no_match_count,
    AVG(
        CASE
            WHEN result_num = 0 THEN 1
            ELSE 0
        END
    ) AS no_match_rate
FROM
    access_log
WHERE
    ACTION = 'search'
GROUP BY
    dt;

-- NoMatch word
WITH search_keyword_stat AS (
    SELECT
        keyword,
        result_num,
        COUNT(1) AS search_count,
        100.* COUNT(1) / COUNT(1) OVER() AS search_share
    FROM
        access_log
    WHERE
        ACTION = 'search'
    GROUP BY
        keyword,
        result_num
)
SELECT
    keyword,
    search_count,
    search_share,
    100.* search_count / SUM(search_count) OVER() AS no_match_share
FROM
    search_keyword_stat
WHERE
    result_num = 0;

WITH access_log_with_next_action AS (
    SELECT
        stamp,
        SESSION,
        ACTION,
        LEAD(ACTION) OVER(
            PARTITION BY SESSION
            ORDER BY
                stamp ASC
        ) AS next_action
    FROM
        access_log
)
SELECT
    SUBSTRING(stamp :: TEXT, 1, 10) AS dt,
    COUNT(1) AS search_count,
    SUM(
        CASE
            WHEN next_action = 'search' THEN 1
            ELSE 0
        END
    ) AS retry_count,
    AVG(
        CASE
            WHEN next_action = 'search' THEN 1.
            ELSE 0.
        END
    ) AS retry_rate
FROM
    access_log_with_next_action
WHERE
    ACTION = 'search'
GROUP BY
    dt
ORDER BY
    dt;
