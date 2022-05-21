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
