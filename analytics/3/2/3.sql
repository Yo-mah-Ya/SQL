-- simple division
SELECT
    year,
    (q1 + q2 + q3 + q4) / 4 AS average
FROM
    quarterly_sales
ORDER BY
    year;

-- correct the denominator
SELECT
    year,
    (
        COALESCE(q1, 0) + COALESCE(q2, 0) + COALESCE(q3, 0) + COALESCE(q4, 0)
    ) / (
        SIGN(COALESCE(q1, 0)) + SIGN(COALESCE(q2, 0)) + SIGN(COALESCE(q3, 0)) + SIGN(COALESCE(q4, 0))
    ) AS average
FROM
    quarterly_sales
ORDER BY
    year;

SELECT
    dt,
    ad_id,
    clicks / impressions AS force_int,
    100.0 * clicks / impressions AS ctr_as_percent
FROM
    advertising_stats
WHERE
    dt = '2017-04-01'
ORDER BY
    dt,
    ad_id;

-- avoid zero division
SELECT
    dt,
    ad_id,
    CASE
        WHEN impressions > 0 THEN 100.0 * clicks / impressions
        ELSE NULL
    END AS ctr_as_percent_by_case,
    100.0 * clicks / NULLIF(impressions, 0) AS ctr_as_percent_by_null
FROM
    advertising_stats
ORDER BY
    dt,
    ad_id;
