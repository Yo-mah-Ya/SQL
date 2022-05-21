DROP TABLE IF EXISTS film_actor;
CREATE TABLE film_actor (
    id SERIAL PRIMARY KEY,
    actor_id SMALLINT NOT NULL,
    film_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,

    CONSTRAINT actor_id_film_id UNIQUE(actor_id, film_id),
    CONSTRAINT film_actor_actor_id_fkey FOREIGN KEY (actor_id) REFERENCES actor(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT film_actor_film_id_fkey FOREIGN KEY (film_id) REFERENCES film(id) ON UPDATE CASCADE ON DELETE RESTRICT
);
