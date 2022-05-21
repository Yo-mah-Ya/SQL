-- year-on-year
WITH daily_purchase AS (
    SELECT
        dt,
        SUBSTRING(dt, 1, 4) AS year,
        SUBSTRING(dt, 6, 2) AS month,
        SUBSTRING(dt, 9, 2) AS date,
        SUM(purchase_amount) AS purchase_amount
    FROM
        purchase_log
    GROUP BY
        dt
)
SELECT
    *,
    100.* amount_2015 / amount_2014 AS rate
FROM
    (
        SELECT
            month,
            SUM(
                CASE
                    year
                    WHEN '2014' THEN purchase_amount
                END
            ) AS amount_2014,
            SUM(
                CASE
                    year
                    WHEN '2015' THEN purchase_amount
                END
            ) AS amount_2015
        FROM
            daily_purchase
        GROUP BY
            month
        ORDER BY
            month
    ) AS t;
