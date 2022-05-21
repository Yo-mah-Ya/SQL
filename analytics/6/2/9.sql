SELECT
    COUNT(*) AS confirm_count,
    SUM(
        CASE
            WHEN STATUS = 'error' THEN 1
            ELSE 0
        END
    ) AS error_count,
    AVG(
        CASE
            WHEN STATUS = 'error' THEN 1.
            ELSE 0.
        END
    ) AS error_rate,
    SUM(
        CASE
            WHEN STATUS = 'error' THEN 1.
            ELSE 0.
        END
    ) / COUNT(DISTINCT session) AS error_per_user
FROM
    form_log
WHERE
    path = '/regist/confirm';
