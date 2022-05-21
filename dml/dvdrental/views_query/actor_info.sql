SELECT
    a.id AS actor_id,
    a.first_name,
    a.last_name,
    c.name AS category_name,
    f.title AS film_title
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.id = fa.actor_id
LEFT JOIN film AS f ON fa.film_id = f.id
LEFT JOIN film_category AS fc ON fa.film_id = fc.film_id
LEFT JOIN category AS c ON fc.category_id = c.id
ORDER BY actor_id ASC;
