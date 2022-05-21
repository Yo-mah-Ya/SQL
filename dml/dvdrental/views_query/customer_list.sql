SELECT
    cu.id,
    a.address,
    a.postal_code AS zip_code,
    a.phone,
    city.name,
    country.name,
    cu.store_id AS sid,
    (((cu.first_name)::text || ' '::text) || (cu.last_name)::text
    ) AS name,
    CASE
        WHEN cu.activebool THEN 'active'::text
        ELSE ''::text
    END AS notes
FROM customer AS cu
INNER JOIN address AS a ON cu.address_id = a.id
INNER JOIN city ON a.city_id = city.id
INNER JOIN country ON city.country_id = country.id
ORDER BY id ASC;
