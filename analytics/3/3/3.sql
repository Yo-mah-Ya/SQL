-- convert columns to rows
SELECT
    dt,
    MAX(
        CASE
            WHEN indicator = 'impressions' THEN val
        END
    ) AS impressions,
    MAX(
        CASE
            WHEN indicator = 'sessions' THEN val
        END
    ) AS sessions,
    MAX(
        CASE
            WHEN indicator = 'users' THEN val
        END
    ) AS users
FROM
    daily_kpi
GROUP BY
    dt
ORDER BY
    dt;

SELECT
    purchase_id,
    STRING_AGG(product_id, '/') AS product_ids,
    SUM(price) AS amount
FROM
    purchase_detail_log
GROUP BY
    purchase_id
ORDER BY
    purchase_id;
