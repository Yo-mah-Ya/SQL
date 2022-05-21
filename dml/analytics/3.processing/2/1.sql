SELECT
    user_id,
    CONCAT(pref_name, city_name) AS pref_city
FROM
    mst_user_location;
