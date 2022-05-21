WITH access_log_with_next_search AS (
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
    result_num,
    COUNT(1) AS retry_count,
    next_keyword,
    next_result_num
FROM
    access_log_with_next_search
WHERE
    ACTION = 'search'
    AND next_action = 'search'
    AND next_keyword LIKE CONCAT('%', keyword, '%')
GROUP BY
    keyword,
    result_num,
    next_keyword,
    next_result_num;

WITH access_log_with_next_search AS (
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
    result_num,
    COUNT(1) AS retry_count,
    next_keyword,
    next_result_num
FROM
    access_log_with_next_search
WHERE
    ACTION = 'search'
    AND next_action = 'search'
    AND next_keyword NOT LIKE CONCAT('%', keyword, '%')
GROUP BY
    keyword,
    result_num,
    next_keyword,
    next_result_num;
