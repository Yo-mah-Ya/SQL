DROP TYPE IF EXISTS mpaa_rating;
CREATE TYPE mpaa_rating AS ENUM (
    'G',
    'PG',
    'PG-13',
    'R',
    'NC-17'
);
DROP TABLE IF EXISTS film;
CREATE TABLE film (
    id SERIAL PRIMARY KEY,
    title CHARACTER VARYING(255) NOT NULL,
    description TEXT,
    release_year SMALLINT,
    language_id SMALLINT NOT NULL,
    rental_duration SMALLINT DEFAULT 3 NOT NULL,
    rental_rate NUMERIC(4,2) DEFAULT 4.99 NOT NULL,
    length SMALLINT,
    replacement_cost NUMERIC(5,2) DEFAULT 19.99 NOT NULL,
    rating mpaa_rating DEFAULT 'G'::mpaa_rating,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,
    special_features TEXT[],
    fulltext tsvector NOT NULL,

    CONSTRAINT film_language_id_fkey FOREIGN KEY (language_id) REFERENCES language(id) ON UPDATE CASCADE ON DELETE RESTRICT
);
