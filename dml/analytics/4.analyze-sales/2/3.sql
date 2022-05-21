-- Fan chart
WITH daily_category_amount AS (
    SELECT
        dt,
        category,
        SUBSTRING(dt, 1, 4) AS year,
        SUBSTRING(dt, 6, 2) AS month,
        SUBSTRING(dt, 9, 2) AS DATE,
        SUM(price) AS amount
    FROM
        purchase_detail_log
    GROUP BY
        dt,
        category
),
monthly_category_amount AS (
    SELECT
        CONCAT(year, '-', month) AS year_month,
        category,
        SUM(amount) AS amount
    FROM
        daily_category_amount
    GROUP BY
        year,
        month,
        category
)
SELECT
    year_month,
    category,
    amount,
    FIRST_VALUE(amount) OVER(
        PARTITION BY category
        ORDER BY
            year_month,
            category
    ) AS base_amount,
    100.* amount / FIRST_VALUE(amount) OVER(
        PARTITION BY category
        ORDER BY
            year_month,
            category
    ) AS rate
FROM
    monthly_category_amount
ORDER BY
    year_month,
    category;
