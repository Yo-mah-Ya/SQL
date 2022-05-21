WITH action_log_with_mod_stamp AS (
    SELECT
        *,
        CAST(
            stamp :: TIMESTAMP - '4 hours' :: INTERVAL AS TEXT
        ) AS mod_stamp
    FROM
        action_log
)
SELECT
    SESSION,
    user_id,
    ACTION,
    stamp,
    SUBSTRING(stamp, 1, 10) AS raw_date,
    SUBSTRING(mod_stamp, 1, 10) AS mod_date
FROM
    action_log_with_mod_stamp;
