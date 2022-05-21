SELECT
    'app1' AS app_name,
    user_id,
    name,
    email
FROM
    app1_mst_users
UNION
ALL
SELECT
    'app2' AS app_name,
    user_id,
    name,
    NULL AS email
FROM
    app2_mst_users;
