-- fall out report
WITH mst_fallout_step AS(
    SELECT
        1 AS step,
        '/' AS path
    UNION
    ALL
    SELECT
        2 AS step,
        '/search_list' AS path
    UNION
    ALL
    SELECT
        3 AS step,
        '/ddetail' AS path
    UNION
    ALL
    SELECT
        4 AS step,
        '/input' AS path
    UNION
    ALL
    SELECT
        5 AS step,
        '/complete' AS path
),
activity_log_with_fallout_step AS (
    SELECT
        l.session,
        m.step,
        m.path,
        MAX(l.stamp) AS max_stamp,
        MIN(l.stamp) AS min_stamp
    FROM
        mst_fallout_step AS m
        JOIN activity_log AS l ON m.path = l.path
    GROUP BY
        l.session,
        m.step,
        m.path
),
activity_log_with_mod_fallout_step AS (
    SELECT
        session,
        step,
        path,
        max_stamp,
        LAG(min_stamp) OVER(
            PARTITION BY session
            ORDER BY
                step
        ) AS lag_min_stamp,
        MIN(step) OVER(PARTITION BY session) AS min_step,
        COUNT(1) OVER(
            PARTITION BY session
            ORDER BY
                step ROWS BETWEEN UNBOUNDED PRECEDING
                AND CURRENT ROW
        ) AS cum_count
    FROM
        activity_log_with_fallout_step
),
fallout_log AS (
    SELECT
        session,
        step,
        path
    FROM
        activity_log_with_mod_fallout_step
    WHERE
        min_step = 1
        AND step = cum_count
        AND (
            lag_min_stamp IS NULL
            OR max_stamp >= lag_min_stamp
        )
)
SELECT
    step,
    path,
    COUNT(1) AS count,
    100.* COUNT(1) / FIRST_VALUE(COUNT(1)) OVER(
        ORDER BY
            step ASC ROWS BETWEEN UNBOUNDED PRECEDING
            AND UNBOUNDED FOLLOWING
    ) AS first_trans_rate,
    100.* COUNT(1) / LAG(COUNT(1)) OVER(
        ORDER BY
            step ASC
    ) AS step_trans_rate
FROM
    fallout_log
GROUP BY
    step,
    path
ORDER BY
    step;
