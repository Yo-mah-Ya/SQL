SELECT
    user_id,
    CASE
        WHEN CAST(register_device AS NUMERIC) = 1 THEN 'PC'
        WHEN CAST(register_device AS NUMERIC) = 2 THEN 'SP'
        WHEN CAST(register_device AS NUMERIC) = 3 THEN 'apps'
        ELSE ''
    END AS device_name
FROM
    mst_users;
