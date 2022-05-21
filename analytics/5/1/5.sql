-- Venn diagram
WITH user_action_flag AS (
    SELECT
        user_id,
        SIGN(
            SUM(
                CASE
                    WHEN ACTION = 'purchase' THEN 1
                    ELSE 0
                END
            )
        ) AS has_purchase,
        SIGN(
            SUM(
                CASE
                    WHEN ACTION = 'review' THEN 1
                    ELSE 0
                END
            )
        ) AS has_reviewe,
        SIGN(
            SUM(
                CASE
                    WHEN ACTION = 'favorite' THEN 1
                    ELSE 0
                END
            )
        ) AS has_favorite
    FROM
        action_log
    GROUP BY
        user_id
)
SELECT
    *
FROM
    user_action_flag;

WITH user_action_flag AS (
    SELECT
        user_id,
        SIGN(
            SUM(
                CASE
                    WHEN ACTION = 'purchase' THEN 1
                    ELSE 0
                END
            )
        ) AS has_purchase,
        SIGN(
            SUM(
                CASE
                    WHEN ACTION = 'review' THEN 1
                    ELSE 0
                END
            )
        ) AS has_review,
        SIGN(
            SUM(
                CASE
                    WHEN ACTION = 'favorite' THEN 1
                    ELSE 0
                END
            )
        ) AS has_favorite
    FROM
        action_log
    GROUP BY
        user_id
),
action_venn_diagram AS (
    SELECT
        has_purchase,
        has_review,
        has_favorite,
        COUNT(1) AS users
    FROM
        user_action_flag
    GROUP BY
        CUBE(has_purchase, has_review, has_favorite)
)
SELECT
    *
FROM
    action_venn_diagram
ORDER BY
    has_purchase,
    has_review,
    has_favorite;
