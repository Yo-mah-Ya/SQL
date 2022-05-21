WITH stats AS (
    SELECT
        COUNT(DISTINCT SESSION) AS total_uu
    FROM
        action_log
)
SELECT
    l.action,
    COUNT(DISTINCT l.session) AS action_uu,
    COUNT(1) AS action_count,
    s.total_uu,
    100.* COUNT(DISTINCT l.session) / s.total_uu AS usage_rate,
    1.* COUNT(1) / COUNT(DISTINCT l.session) AS count_per_user
FROM
    action_log AS l
    CROSS JOIN stats AS s
GROUP BY
    l.action,
    s.total_uu;

WITH action_log_with_status AS (
    SELECT
        SESSION,
        user_id,
        ACTION,
        CASE
            WHEN COALESCE(user_id, '') <> '' THEN 'login'
            ELSE 'guest'
        END AS login_status
    FROM
        action_log
)
SELECT
    *
FROM
    action_log_with_status;

WITH action_log_with_status AS (
    SELECT
        SESSION,
        user_id,
        ACTION,
        CASE
            WHEN COALESCE(user_id, '') <> '' THEN 'login'
            ELSE 'guest'
        END AS login_status
    FROM
        action_log
)
SELECT
    COALESCE(ACTION, 'all') AS ACTION,
    COALESCE(login_status, 'all') AS login_status,
    COUNT(DISTINCT SESSION) AS action_uu,
    COUNT(1) AS action_count
FROM
    action_log_with_status
GROUP BY
    ROLLUP(ACTION, login_status)
ORDER BY
    action_uu;

WITH action_log_with_status AS (
    SELECT
        SESSION,
        user_id,
        ACTION,
        CASE
            WHEN COALESCE(
                MAX(user_id) OVER(
                    PARTITION BY SESSION
                    ORDER BY
                        stamp ROWS BETWEEN UNBOUNDED PRECEDING
                        AND CURRENT ROW
                ),
                ''
            ) <> '' THEN 'member'
            ELSE 'none'
        END AS member_status,
        stamp
    FROM
        action_log
)
SELECT
    *
FROM
    action_log_with_status;
