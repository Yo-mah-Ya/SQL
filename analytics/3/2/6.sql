-- PostgreSQL let you to use type inet for handling IP address
SELECT
    CAST('172.16.4.46' AS inet) < CAST('172.17.49.127' AS inet) AS lt,
    CAST('172.16.4.46' AS inet) > CAST('172.17.49.127' AS inet) AS gt;

SELECT
    CAST('172.16.4.46' AS inet) << CAST('172.16.4.46/8' AS inet) AS is_contained;

SELECT
    ip,
    CAST(SPLIT_PART(ip, '.', 1) AS INTEGER) AS ip_part_1,
    CAST(SPLIT_PART(ip, '.', 2) AS INTEGER) AS ip_part_2,
    CAST(SPLIT_PART(ip, '.', 3) AS INTEGER) AS ip_part_3,
    CAST(SPLIT_PART(ip, '.', 4) AS INTEGER) AS ip_part_4
FROM
    (
        SELECT
            CAST('172.16.4.46' AS TEXT) AS ip
    ) AS tmp;

SELECT
    ip,
    LPAD(SPLIT_PART(ip, '.', 1), 3, '0') || LPAD(SPLIT_PART(ip, '.', 2), 3, '0') || LPAD(SPLIT_PART(ip, '.', 3), 3, '0') || LPAD(SPLIT_PART(ip, '.', 4), 3, '0') AS ip_lpad3
FROM
    (
        SELECT
            CAST('172.16.4.46' AS TEXT) AS ip
    ) AS tmp;

SELECT
    COUNT(*) AS total_count,
    COUNT(DISTINCT user_id) AS user_count,
    COUNT(DISTINCT product_id) AS product_count,
    SUM(score) AS sum,
    AVG(score) AS avg,
    MAX(score) AS max,
    MIN(score) AS min
FROM
    review;

SELECT
    user_id,
    COUNT(*) AS total_count,
    COUNT(DISTINCT user_id) AS user_count,
    COUNT(DISTINCT product_id) AS product_count,
    SUM(score) AS sum,
    AVG(score) AS avg,
    MAX(score) AS max,
    MIN(score) AS min
FROM
    review
GROUP BY
    user_id;

SELECT
    user_id,
    product_id,
    score,
    AVG(score) OVER() AS avg_score,
    AVG(score) OVER(PARTITION BY user_id) AS user_avg_score,
    score - AVG(score) OVER(PARTITION BY user_id) AS user_avg_score_diff
FROM
    review;
