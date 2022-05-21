SELECT
    c.name AS category,
    sum(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.id
INNER JOIN inventory AS i ON r.inventory_id = i.id
INNER JOIN film AS f ON i.film_id = f.id
INNER JOIN film_category AS fc ON f.id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.id
GROUP BY c.name
ORDER BY sum(p.amount) DESC;
