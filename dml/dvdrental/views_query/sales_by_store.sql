SELECT
    c.name::text || ','::text || cy.name::text AS store,
    m.first_name::text || ' '::text || m.last_name::text AS manager,
    sum(p.amount) AS total_sales
FROM payment AS p
INNER JOIN rental AS r ON p.rental_id = r.id
INNER JOIN inventory AS i ON r.inventory_id = i.id
INNER JOIN store AS s ON i.store_id = s.id
INNER JOIN address AS a ON s.address_id = a.id
INNER JOIN city AS c ON a.city_id = c.id
INNER JOIN country AS cy ON c.country_id = cy.id
INNER JOIN staff AS m ON s.manager_staff_id = m.id
GROUP BY cy.name, c.name, s.id, m.first_name, m.last_name
ORDER BY cy.name, c.name;
