WITH rsv_with_category AS (
    SELECT
        r.rsv_id,
        r.member_id,
        r.member_pref_name,
        r.spot_pref_name,
        CASE
            r.spot_pref_id
            WHEN r.member_pref_id THEN 'same'
            WHEN n.neighbor_pref_id THEN 'neighbor'
            ELSE 'far'
        END AS category
    FROM
        reservations AS r
        LEFT OUTER JOIN neighbor_pref AS n ON r.member_pref_id = n.pref_id
        AND r.spot_pref_id = n.neighbor_pref_id
)
SELECT
    *
FROM
    rsv_with_category;
