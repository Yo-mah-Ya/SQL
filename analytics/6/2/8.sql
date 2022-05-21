SELECT
    url,
    action,
    COUNT(1) AS count,
    100.* COUNT(1) / SUM(
        CASE
            WHEN action = 'view' THEN COUNT(1)
            ELSE 0
        END
    ) OVER(PARTITION BY url) AS action_per_view
FROM
    read_log
GROUP BY
    url,
    action
ORDER BY
    url,
    count DESC;
