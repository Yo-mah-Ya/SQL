WITH action_log_with_mst_users AS (
    SELECT
        u.user_id,
        u.register_date,
        CAST(a.stamp AS DATE) AS action_date,
        MAX(CAST(a.stamp AS DATE)) OVER() AS latest_date,
        CAST(
            u.register_date :: DATE + '1 day' :: INTERVAL AS DATE
        ) AS next_day_1
    FROM
        mst_users AS u
        LEFT OUTER JOIN action_log AS a ON u.user_id = a.user_id
),
user_action_flag AS (
    SELECT
        user_id,
        register_date,
        SIGN(
            SUM(
                CASE
                    WHEN next_day_1 <= latest_date THEN CASE
                        WHEN next_day_1 = action_date THEN 1
                        ELSE 0
                    END
                END
            )
        ) AS next_1_day_action
    FROM
        action_log_with_mst_users
    GROUP BY
        user_id,
        register_date
)
SELECT
    register_date,
    AVG(100.* next_1_day_action) AS repeat_rate_1_day
FROM
    user_action_flag
GROUP BY
    register_date
ORDER BY
    register_date;

WITH repeat_interval(index_name, interval_date) AS (
    VALUES
        ('01 day repeat', 1),
        ('02 day repeat', 2),
        ('03 day repeat', 3),
        ('04 day repeat', 4),
        ('05 day repeat', 5),
        ('06 day repeat', 6),
        ('07 day repeat', 7)
),
action_log_with_index_date AS (
    SELECT
        u.user_id,
        u.register_date,
        CAST(a.stamp AS DATE) AS action_date,
        MAX(CAST(a.stamp AS DATE)) OVER() AS latest_date,
        r.index_name,
        CAST(
            CAST(u.register_date AS DATE) + '1 day' :: INTERVAL * r.interval_date AS DATE
        ) AS index_date
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
                    WHEN index_date <= latest_date THEN CASE
                        WHEN index_date = action_date THEN 1
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
        index_date
)
SELECT
    register_date,
    index_name,
    AVG(100.* index_date_action) AS repeat_rate
FROM
    user_action_flag
GROUP BY
    register_date,
    index_name
ORDER BY
    register_date,
    index_name;
