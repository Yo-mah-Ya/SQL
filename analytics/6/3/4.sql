-- where the errors happens
SELECT
    form,
    field,
    error_type,
    COUNT(1) AS count,
    100.* COUNT(1) / SUM(COUNT(1)) OVER(PARTITION BY form) AS SHARE
FROM
    form_error_log
GROUP BY
    form,
    field,
    error_type
ORDER BY
    form,
    count DESC;
