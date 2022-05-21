SELECT
    SUBSTRING(stamp, 1, 10) AS dt,
    COUNT(DISTINCT long_session) AS access_users,
    COUNT(DISTINCT short_session) AS access_count,
    COUNT(*) AS page_view,
    1.* COUNT(*) / NULLIF(COUNT(DISTINCT long_session), 0) AS pv_per_user
FROM
    access_log
GROUP BY
    dt
ORDER BY
    dt;
