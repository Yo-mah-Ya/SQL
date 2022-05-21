WITH action_log_with_dt AS (
    SELECT
        *,
        SUBSTRING(stamp, 1, 10) AS dt
    FROM
        action_log
),
action_day_count_per_user AS (
    SELECT
        user_id,
        COUNT(DISTINCT dt) AS action_day_count
    FROM
        action_log_with_dt
    WHERE
        dt BETWEEN '2016-11-01'
        AND '2016-11-07'
    GROUP BY
        user_id
)
SELECT
    action_day_count,
    COUNT(DISTINCT user_id) AS user_count
FROM
    action_day_count_per_user
GROUP BY
    action_day_count
ORDER BY
    action_day_count;

WITH action_log_with_dt AS (
    SELECT
        *,
        SUBSTRING(stamp, 1, 10) AS dt
    FROM
        action_log
),
action_day_count_per_user AS (
    SELECT
        user_id,
        COUNT(DISTINCT dt) AS action_day_count
    FROM
        action_log_with_dt
    WHERE
        dt BETWEEN '2016-11-01'
        AND '2016-11-07'
    GROUP BY
        user_id
)
SELECT
    action_day_count,
    COUNT(DISTINCT user_id) AS user_count,
    100.* COUNT(DISTINCT user_id) / SUM(COUNT(DISTINCT user_id)) OVER() AS composition_ratio,
    100 * SUM(COUNT(DISTINCT user_id)) OVER(
        ORDER BY
            action_day_count ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
    ) / SUM(COUNT(DISTINCT user_id)) OVER() AS cumulative_ratio
FROM
    action_day_count_per_user
GROUP BY
    action_day_count
ORDER BY
    action_day_count;
