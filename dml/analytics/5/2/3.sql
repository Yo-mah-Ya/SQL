-- Retention Rate
WITH repeat_interval(
    index_name,
    interval_begin_date,
    interval_end_date
) AS (
    VALUES
        ('01 day repeat', 1, 1)
),
action_log_with_index_date AS (
    SELECT
        u.user_id,
        u.register_date,
        CAST(a.stamp AS DATE) AS action_date,
        MAX(CAST(a.stamp AS DATE)) OVER() AS latest_date,
        r.index_name,
        CAST(
            u.register_date :: DATE + '1 day' :: INTERVAL * r.interval_begin_date AS DATE
        ) AS index_begin_date,
        CAST(
            u.register_date :: DATE + '1 day' :: INTERVAL * r.interval_end_date AS DATE
        ) AS index_end_date
    FROM
        mst_users AS u
        LEFT OUTER JOIN action_log AS a ON u.user_id = a.user_id
        CROSS JOIN repeat_interval AS r
),
user_action_flag AS (
    SELECT
        user_id,
        register_date,
        index_name,
        SIGN(
            SUM(
                CASE
                    WHEN index_end_date <= latest_date THEN CASE
                        WHEN action_date BETWEEN index_begin_date
                        AND index_end_date THEN 1
                        ELSE 0
                    END
                END
            )
        ) AS index_date_action
    FROM
        action_log_with_index_date
    GROUP BY
        user_id,
        register_date,
        index_name,
        index_begin_date,
        index_end_date
),
mst_actions AS(
    SELECT
        'view' AS ACTION
    UNION
    ALL
    SELECT
        'comment' AS ACTION
    UNION
    ALL
    SELECT
        'follow' AS ACTION
),
mst_user_actions AS (
    SELECT
        u.user_id,
        u.register_date,
        a.action
    FROM
        mst_users AS u
        CROSS JOIN mst_actions AS a
),
register_action_flag AS (
    SELECT
        DISTINCT m.user_id,
        m.register_date,
        m.action,
        CASE
            WHEN a.action IS NOT NULL THEN 1
            ELSE 0
        END AS do_action,
        index_name,
        index_date_action
    FROM
        mst_user_actions AS m
        LEFT OUTER JOIN action_log AS a ON m.user_id = a.user_id
        AND CAST(m.register_date AS DATE) = CAST(a.stamp AS DATE)
        AND m.action = a.action
        LEFT OUTER JOIN user_action_flag AS f ON m.user_id = f.user_id
    WHERE
        f.index_date_action IS NOT NULL
)
SELECT
    ACTION,
    COUNT(1) AS users,
    AVG(100.* do_action) AS usage_rate,
    index_name,
    AVG(
        CASE
            do_action
            WHEN 1 THEN 100.* index_date_action
        END
    ) AS idx_rate,
    AVG(
        CASE
            do_action
            WHEN 0 THEN 100.* index_date_action
        END
    ) AS no_action_idx_rate
FROM
    register_action_flag
GROUP BY
    index_name,
    ACTION
ORDER BY
    index_name,
    ACTION;
