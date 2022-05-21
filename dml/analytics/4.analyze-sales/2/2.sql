-- ABC analysis
WITH monthly_sales AS (
    SELECT
        category,
        SUM(price) AS amount
    FROM
        purchase_detail_log
    WHERE
        dt BETWEEN '2015-12-01'
        AND '2015-12-31'
    GROUP BY
        category
),
sales_composition_ratio AS (
    SELECT
        category,
        amount,
        100.* amount / SUM(amount) OVER() AS composition_ratio,
        100.* SUM(amount) OVER(
            ORDER BY
                amount DESC ROWS BETWEEN UNBOUNDED PRECEDING
                AND CURRENT ROW
        ) / SUM(amount) OVER() AS cumulative_ratio
    FROM
        monthly_sales
)
SELECT
    *,
    CASE
        WHEN cumulative_ratio > 90 THEN 'C'
        WHEN cumulative_ratio > 70 THEN 'B'
        ELSE 'A'
    END AS abc_rank
FROM
    sales_composition_ratio
ORDER BY
    amount DESC;
