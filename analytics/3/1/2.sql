SELECT
    stamp,
    SUBSTRING(
        referrer
        FROM
            'https?://([^/]*)'
    ) AS referrer_host
FROM
    access_log;
