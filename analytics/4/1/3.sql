-- cumulative sum
SELECT
    dt,
    SUBSTRING(dt, 1, 7) AS year_month,
    SUM(purchase_amount) AS total_amont,
    SUM(SUM(purchase_amount)) OVER(
        PARTITION BY SUBSTRING(dt, 1, 7)
        ORDER BY
            dt ROWS UNBOUNDED PRECEDING
    ) AS agg_amount
FROM
    purchase_log
GROUP BY
    dt
ORDER BY
    dt;
