SELECT
    url,
    COUNT(DISTINCT short_session) AS access_count,
    COUNT(DISTINCT long_session) AS access_users,
    COUNT(*) AS page_view
FROM
    access_log
GROUP BY
    url;

WITH access_log_with_path AS (
    SELECT
        *,
        SUBSTRING(
            url
            FROM
                '//[^/]+([^?#]+)'
        ) AS url_path
    FROM
        access_log
)
SELECT
    url_path,
    COUNT(DISTINCT short_session) AS access_count,
    COUNT(DISTINCT long_session) AS access_users,
    COUNT(*) AS page_view
FROM
    access_log_with_path
GROUP BY
    url_path;

WITH access_log_with_path AS (
    SELECT
        *,
        SUBSTRING(
            url
            FROM
                '//[^/]+([^?#]+)'
        ) AS url_path
    FROM
        access_log
),
access_log_with_split_path AS (
    SELECT
        *,
        SPLIT_PART(url_path, '/', 2) AS path1,
        SPLIT_PART(url_path, '/', 3) AS path2
    FROM
        access_log_with_path
),
access_log_with_page_name AS (
    SELECT
        *,
        CASE
            WHEN path1 = 'list' THEN CASE
                WHEN path2 = 'newly' THEN 'newly_list'
                ELSE 'category_list'
            END
            ELSE url_path
        END AS page_name
    FROM
        access_log_with_split_path
)
SELECT
    page_name,
    COUNT(DISTINCT short_session) AS access_count,
    COUNT(DISTINCT long_session) AS access_users,
    COUNT(*) AS page_view
FROM
    access_log_with_page_name
GROUP BY
    page_name
ORDER BY
    page_name;
