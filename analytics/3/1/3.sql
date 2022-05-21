SELECT
    stamp,
    url,
    SUBSTRING(
        url
        FROM
            '//[^/]+([^?#]+)'
    ) AS path,
    SUBSTRING(
        url
        FROM
            'id=([^&]*)'
    ) AS id
FROM
    access_log;

SELECT
    stamp,
    url,
    SPLIT_PART(
        SUBSTRING(
            url
            FROM
                '//[^/]+([^?#]+)'
        ),
        '/',
        2
    ) AS path1,
    SPLIT_PART(
        SUBSTRING(
            url
            FROM
                '//[^/]+([^?#]+)'
        ),
        '/',
        3
    ) AS path1
FROM
    access_log;
