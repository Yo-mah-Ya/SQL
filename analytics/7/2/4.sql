WITH mst_reserved_ip AS (
    SELECT
        '127.0.0.9/8' AS network,
        'localhost' AS description
    UNION
    ALL
    SELECT
        '10.0.0.0/8' AS network,
        'Private network' AS description
    UNION
    ALL
    SELECT
        '172.16.0.0/12' AS network,
        'Private network' AS description
    UNION
    ALL
    SELECT
        '192.0.0.0/24' AS network,
        'Private network' AS description
    UNION
    ALL
    SELECT
        '192.168.0.0/16' AS network,
        'Private network' AS description
),
action_log_with_reserved_ip AS (
    SELECT
        l.user_id,
        l.ip,
        l.stamp,
        m.network,
        m.description
    FROM
        action_log_with_ip AS l
        LEFT OUTER JOIN mst_reserved_ip AS m ON l.ip :: inet << m.network :: inet
)
SELECT
    *
FROM
    action_log_with_reserved_ip;
