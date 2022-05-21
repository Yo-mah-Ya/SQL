DROP TABLE IF EXISTS customer;
CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    store_id SMALLINT NOT NULL,
    first_name CHARACTER VARYING(45) NOT NULL,
    last_name CHARACTER VARYING(45) NOT NULL,
    email CHARACTER VARYING(50),
    address_id SMALLINT NOT NULL,
    activebool BOOLEAN DEFAULT true NOT NULL,
    create_date DATE DEFAULT ('now'::text)::date NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    active integer,

    CONSTRAINT customer_address_id_fkey FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT
);
