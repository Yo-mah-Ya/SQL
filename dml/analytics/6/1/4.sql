WITH access_log_with_dow AS(
    SELECT
        stamp,
        DATE_PART('dow', stamp :: TIMESTAMP) AS dow,
        CAST(SUBSTRING(stamp, 12, 2) AS INT) * 60 * 60 + CAST(SUBSTRING(stamp, 15, 2) AS INT) * 60 + CAST(SUBSTRING(stamp, 18, 2) AS INT) AS whole_seconds,
        30 * 60 AS interval_seconds
    FROM
        access_log
),
access_log_with_floor_seconds AS (
    SELECT
        stamp,
        dow,
        CAST(
            (
                FLOOR(whole_seconds / interval_seconds) * interval_seconds
            ) AS INT
        ) AS floor_seconds
    FROM
        access_log_with_dow
),
access_log_with_index AS (
    SELECT
        stamp,
        dow,
        LPAD(FLOOR(floor_seconds / (60 * 60)) :: TEXT, 2, '0') || ':' || LPAD(
            FLOOR(floor_seconds % (60 * 60) / 60) :: TEXT,
            2,
            '0'
        ) || ':' || LPAD(FLOOR(floor_seconds % 60) :: TEXT, 2, '0') AS index_time
    FROM
        access_log_with_floor_seconds
)
SELECT
    index_time,
    COUNT(
        CASE
            dow
            WHEN 0 THEN 1
        END
    ) AS sun,
    COUNT(
        CASE
            dow
            WHEN 1 THEN 1
        END
    ) AS mon,
    COUNT(
        CASE
            dow
            WHEN 2 THEN 1
        END
    ) AS tue,
    COUNT(
        CASE
            dow
            WHEN 3 THEN 1
        END
    ) AS wed,
    COUNT(
        CASE
            dow
            WHEN 4 THEN 1
        END
    ) AS thu,
    COUNT(
        CASE
            dow
            WHEN 5 THEN 1
        END
    ) AS fri,
    COUNT(
        CASE
            dow
            WHEN 6 THEN 1
        END
    ) AS sat
FROM
    access_log_with_index
GROUP BY
    index_time
ORDER BY
    index_time;
