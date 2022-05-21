SELECT
    film.id AS film_id,
    film.title,
    film.description,
    category.name AS category,
    film.rental_rate AS price,
    film.length,
    film.rating,
    actor.first_name::text || ' '::text || actor.last_name::text AS actors
FROM category
LEFT JOIN film_category ON category.id = film_category.category_id
LEFT JOIN film ON film_category.film_id = film.id
INNER JOIN film_actor ON film.id = film_actor.film_id
INNER JOIN actor ON film_actor.actor_id = actor.id
ORDER BY film_id ASC;
