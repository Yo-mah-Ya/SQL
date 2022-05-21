WITH mst_bot_user_agent AS (
    SELECT
        '%bot%' AS rule
    UNION
    ALL
    SELECT
        '%crawler%' AS rule
    UNION
    ALL
    SELECT
        '%spider%' AS rule
    UNION
    ALL
    SELECT
        '%archiver%' AS rule
),
filtered_action_log AS (
    SELECT
        l.stamp,
        l.session,
        l.action,
        l.products,
        l.url,
        l.ip,
        l.user_agent
    FROM
        action_log_with_noise AS l
    WHERE
        NOT EXISTS (
            SELECT
                1
            FROM
                mst_bot_user_agent AS m
            WHERE
                l.user_agent LIKE m.rule
        )
)
SELECT
    *
FROM
    filtered_action_log;

-- When not using correlated-subqueries, use `CROSS JOIN` and `HAVING`
WITH mst_bot_user_agent AS (
    SELECT
        '%bot%' AS rule
    UNION
    ALL
    SELECT
        '%crawler%' AS rule
    UNION
    ALL
    SELECT
        '%spider%' AS rule
    UNION
    ALL
    SELECT
        '%archiver%' AS rule
),
filtered_action_log AS (
    SELECT
        l.stamp,
        l.session,
        l.action,
        l.products,
        l.url,
        l.ip,
        l.user_agent
    FROM
        action_log_with_noise AS l
        CROSS JOIN mst_bot_user_agent AS m
    GROUP BY
        l.stamp,
        l.session,
        l.action,
        l.products,
        l.url,
        l.ip,
        l.user_agent
    HAVING
        SUM(
            CASE
                WHEN l.user_agent LIKE m.rule THEN 1
                ELSE 0
            END
        ) = 0
)
SELECT
    *
FROM
    filtered_action_log;

-- exlucdes crawler accessing
WITH mst_bot_user_agent AS (
    SELECT
        '%bot%' AS rule
    UNION
    ALL
    SELECT
        '%crawler%' AS rule
    UNION
    ALL
    SELECT
        '%spider%' AS rule
    UNION
    ALL
    SELECT
        '%archiver%' AS rule
),
filtered_action_log AS (
    SELECT
        l.stamp,
        l.session,
        l.action,
        l.products,
        l.url,
        l.ip,
        l.user_agent
    FROM
        action_log_with_noise AS l
        CROSS JOIN mst_bot_user_agent AS m
    GROUP BY
        l.stamp,
        l.session,
        l.action,
        l.products,
        l.url,
        l.ip,
        l.user_agent
    HAVING
        SUM(
            CASE
                WHEN l.user_agent LIKE m.rule THEN 1
                ELSE 0
            END
        ) = 0
)
SELECT
    user_agent,
    COUNT(1) AS count,
    100.* SUM(COUNT(1)) OVER(
        ORDER BY
            COUNT(1) DESC ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
    ) / SUM(COUNT(1)) OVER() AS cumulative_ratio
FROM
    filtered_action_log
GROUP BY
    user_agent
ORDER BY
    count DESC;
