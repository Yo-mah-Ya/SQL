-- moving average
SELECT
    dt,
    SUM(purchase_amount) AS total_amount,
    AVG(SUM(purchase_amount)) OVER(
        ORDER BY
            dt ROWS BETWEEN 6 PRECEDING
            AND CURRENT ROW
    ) AS seven_day_avg,
    CASE
        WHEN 7 = COUNT(*) OVER(
            ORDER BY
                dt ROWS BETWEEN 6 PRECEDING
                AND CURRENT ROW
        ) THEN AVG(SUM(purchase_amount)) OVER(
            ORDER BY
                dt ROWS BETWEEN 6 PRECEDING
                AND CURRENT ROW
        )
    END AS seven_day_avg_strict
FROM
    purchase_log
GROUP BY
    dt
ORDER BY
    dt;
