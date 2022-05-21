WITH access_log_with_parse_info AS (
    SELECT
        *,
        SUBSTRING(
            url
            FROM
                'https?://([^/]*)'
        ) AS url_domain,
        SUBSTRING(
            url
            FROM
                'utm_source=([^&]*)'
        ) AS url_utm_source,
        SUBSTRING(
            url
            FROM
                'utm_medium=([^&]*)'
        ) AS url_utm_medium,
        SUBSTRING(
            referrer
            FROM
                'https?://([^/]*)'
        ) AS referrer_domain
    FROM
        access_log
),
access_log_with_via_info AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            ORDER BY
                stamp
        ) AS log_id,
        CASE
            WHEN url_utm_source <> ''
            AND url_utm_medium <> '' THEN CONCAT(url_utm_source, '-', url_utm_medium)
            WHEN referrer_domain IN ('search.yahoo.co.jp', 'www.google.co.jp') THEN 'search'
            WHEN referrer_domain IN ('twitter.com', 'www.facebook.com') THEN 'social'
            ELSE 'other'
        END AS via
    FROM
        access_log_with_parse_info
    WHERE
        COALESCE(referrer_domain, '') NOT IN ('', url_domain)
)
SELECT
    via,
    COUNT(1) AS access_count
FROM
    access_log_with_via_info
GROUP BY
    via
ORDER BY
    access_count DESC;

WITH access_log_with_parse_info AS (
    SELECT
        *,
        SUBSTRING(
            url
            FROM
                'https?://([^/]*)'
        ) AS url_domain,
        SUBSTRING(
            url
            FROM
                'utm_source=([^&]*)'
        ) AS url_utm_source,
        SUBSTRING(
            url
            FROM
                'utm_medium=([^&]*)'
        ) AS url_utm_medium,
        SUBSTRING(
            referrer
            FROM
                'https?://([^/]*)'
        ) AS referrer_domain
    FROM
        access_log
),
access_log_with_via_info AS (
    SELECT
        *,
        ROW_NUMBER() OVER(
            ORDER BY
                stamp
        ) AS log_id,
        CASE
            WHEN url_utm_source <> ''
            AND url_utm_medium <> '' THEN CONCAT(url_utm_source, '-', url_utm_medium)
            WHEN referrer_domain IN ('search.yahoo.co.jp', 'www.google.co.jp') THEN 'search'
            WHEN referrer_domain IN ('twitter.com', 'www.facebook.com') THEN 'social'
            ELSE 'other'
        END AS via
    FROM
        access_log_with_parse_info
    WHERE
        COALESCE(referrer_domain, '') NOT IN ('', url_domain)
),
accesss_log_with_purchase_amount AS (
    SELECT
        a.log_id,
        a.via,
        SUM(
            CASE
                WHEN p.stamp :: DATE BETWEEN a.stamp :: DATE
                AND a.stamp :: DATE + '1 day' :: INTERVAL THEN amount
            END
        ) AS amount
    FROM
        access_log_with_via_info AS a
        LEFT OUTER JOIN purchase_log AS p ON a.long_session = p.long_session
    GROUP BY
        a.log_id,
        a.via
)
SELECT
    via,
    COUNT(1) AS via_count,
    COUNT(amount) AS conversions,
    AVG(100.* SIGN(COALESCE(amount, 0))) AS cvr,
    SUM(COALESCE(amount, 0)) AS amount,
    AVG(1.* COALESCE(amount, 0)) AS avg_amount
FROM
    accesss_log_with_purchase_amount
GROUP BY
    via
ORDER BY
    cvr DESC;
