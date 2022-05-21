SELECT
    s.id AS id,
    a.address,
    a.postal_code AS zip_code,
    a.phone,
    city.name AS city_name,
    country.name AS country_name,
    s.store_id AS store_id,
    s.first_name::text || ' '::text || s.last_name::text AS staff_full_name
FROM staff AS s
INNER JOIN address AS a ON s.address_id = a.id
INNER JOIN city ON a.city_id = city.id
INNER JOIN country ON city.country_id = country.id
ORDER BY id ASC;
