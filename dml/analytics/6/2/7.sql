WITH activity_log_with_lead_path AS (
    SELECT
        session,
        stamp,
        path AS path0,
        LEAD(path, 1) OVER(
            PARTITION BY session
            ORDER BY
                stamp ASC
        ) AS path1,
        LEAD(path, 2) OVER(
            PARTITION BY session
            ORDER BY
                stamp ASC
        ) AS path2
    FROM
        activity_log
),
raw_user_flow AS (
    SELECT
        path0,
        SUM(COUNT(1)) OVER() AS count0,
        COALESCE(path1, 'NULL') AS path1,
        SUM(COUNT(1)) OVER(PARTITION BY path0, path1) AS count1,
        COALESCE(path2, 'NULL') AS path2,
        COUNT(1) AS count2
    FROM
        activity_log_with_lead_path
    WHERE
        path0 = '/detail'
    GROUP BY
        path0,
        path1,
        path2
)
SELECT
    path0,
    count0,
    path1,
    count1,
    100.* count1 / count0 AS rate1,
    path2,
    count2,
    100.* count2 / count1 AS rate2
FROM
    raw_user_flow
ORDER BY
    count1 DESC,
    count2 DESC;
