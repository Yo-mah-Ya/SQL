-- Decyl analysis
WITH user_purchase_amount AS (
    SELECT
        user_id,
        SUM(amount) AS purchase_amount
    FROM
        action_log
    WHERE
        ACTION = 'purchase'
    GROUP BY
        user_id
),
users_with_decile AS (
    SELECT
        user_id,
        purchase_amount,
        NTILE(10) OVER (
            ORDER BY
                purchase_amount DESC
        ) AS decile
    FROM
        user_purchase_amount
)
SELECT
    *
FROM
    users_with_decile;

WITH user_purchase_amount AS (
    SELECT
        user_id,
        SUM(amount) AS purchase_amount
    FROM
        action_log
    WHERE
        ACTION = 'purchase'
    GROUP BY
        user_id
),
users_with_decile AS (
    SELECT
        user_id,
        purchase_amount,
        NTILE(10) OVER (
            ORDER BY
                purchase_amount DESC
        ) AS decile
    FROM
        user_purchase_amount
),
decile_with_purchase_amount AS (
    SELECT
        decile,
        SUM(purchase_amount) AS amount,
        AVG(purchase_amount) AS avg_amount,
        SUM(SUM(purchase_amount)) OVER(
            ORDER BY
                decile
        ) AS cumulative_amount,
        SUM(SUM(purchase_amount)) OVER() AS total_amount
    FROM
        users_with_decile
    GROUP BY
        decile
)
SELECT
    *
FROM
    decile_with_purchase_amount;
