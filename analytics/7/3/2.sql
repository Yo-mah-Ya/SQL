-- detect duplicate records
SELECT
    user_id,
    products,
    STRING_AGG(SESSION, ',') AS session_list,
    STRING_AGG(stamp, ',') AS stamp_list
FROM
    dup_action_log
GROUP BY
    user_id,
    products
HAVING
    COUNT(*) > 1;

-- delete duplicate records
SELECT
    SESSION,
    user_id,
    ACTION,
    products,
    MIN(stamp) AS stamp
FROM
    dup_action_log
GROUP BY
    SESSION,
    user_id,
    ACTION,
    products;

-- another way
WITH dup_action_log_with_order_num AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            PARTITION BY SESSION,
            user_id,
            ACTION,
            products
            ORDER BY
                stamp
        ) AS order_num
    FROM
        dup_action_log
)
SELECT
    SESSION,
    user_id,
    ACTION,
    products,
    stamp
FROM
    dup_action_log_with_order_num
WHERE
    order_num = 1;

WITH dup_action_log_with_lag_seconds AS (
    SELECT
        user_id,
        ACTION,
        products,
        stamp,
        EXTRACT(
            epoch
            FROM
                stamp :: TIMESTAMP - LAG(stamp :: TIMESTAMP) OVER(
                    PARTITION BY user_id,
                    ACTION,
                    products
                    ORDER BY
                        stamp
                )
        ) AS lag_seconds
    FROM
        dup_action_log
)
SELECT
    *
FROM
    dup_action_log_with_lag_seconds
WHERE
    (
        lag_seconds IS NULL
        OR lag_seconds >= 30 * 60
    )
ORDER BY
    stamp;
