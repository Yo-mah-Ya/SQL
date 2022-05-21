DROP TABLE IF EXISTS film_category;
CREATE TABLE film_category (
    id SERIAL PRIMARY KEY,
    film_id SMALLINT NOT NULL,
    category_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,

    CONSTRAINT film_id_category_id UNIQUE(film_id, category_id),
    CONSTRAINT film_category_category_id_fkey FOREIGN KEY (category_id) REFERENCES category(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT film_category_film_id_fkey FOREIGN KEY (film_id) REFERENCES film(id) ON UPDATE CASCADE ON DELETE RESTRICT
);
