-- Z chart
WITH daily_purchase AS (
    SELECT
        dt,
        SUBSTRING(dt, 1, 4) AS year,
        SUBSTRING(dt, 6, 2) AS month,
        SUBSTRING(dt, 9, 2) AS DATE,
        SUM(purchase_amount) AS purchase_amount
    FROM
        purchase_log
    GROUP BY
        dt
),
monthly_amount AS (
    SELECT
        year,
        month,
        SUM(purchase_amount) AS amount
    FROM
        daily_purchase
    GROUP BY
        year,
        month
),
calc_index AS (
    SELECT
        year,
        month,
        amount,
        SUM(
            CASE
                WHEN year = '2015' THEN amount
            END
        ) OVER(
            ORDER BY
                year,
                month ROWS UNBOUNDED PRECEDING
        ) AS agg_amount,
        SUM(amount) OVER(
            ORDER BY
                year,
                month ROWS BETWEEN 11 PRECEDING
                AND CURRENT ROW
        ) AS year_avg_amount
    FROM
        monthly_amount
    ORDER BY
        year,
        month
)
SELECT
    CONCAT(year, '-', month) AS year_month,
    amount,
    agg_amount,
    year_avg_amount
FROM
    calc_index
WHERE
    year = '2015'
ORDER BY
    year_month;
