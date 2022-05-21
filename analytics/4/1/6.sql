WITH daily_purchase AS (
    SELECT
        dt,
        SUBSTRING(dt, 1, 4) AS year,
        SUBSTRING(dt, 6, 2) AS MONTH,
        SUBSTRING(dt, 9, 2) AS DATE,
        SUM(purchase_amount) AS purchase_amount,
        COUNT(*) AS orders
    FROM
        purchase_log
    GROUP BY
        dt
),
monthly_purchase AS (
    SELECT
        year,
        MONTH,
        SUM(orders) AS orders,
        AVG(purchase_amount) AS avg_amount,
        SUM(purchase_amount) AS monthly
    FROM
        daily_purchase
    GROUP BY
        year,
        MONTH
)
SELECT
    CONCAT(year, '-', MONTH) AS year_month,
    orders,
    avg_amount,
    monthly,
    SUM(monthly) OVER(
        PARTITION BY year
        ORDER BY
            MONTH ROWS UNBOUNDED PRECEDING
    ) AS agg_amount,
    LAG(monthly, 12) OVER(
        ORDER BY
            year,
            MONTH
    ) AS last_year,
    100.* monthly / LAG(monthly, 12) OVER(
        ORDER BY
            year,
            MONTH
    ) AS rate
FROM
    monthly_purchase
ORDER BY
    year_month;
