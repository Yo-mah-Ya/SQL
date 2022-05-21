DROP TABLE IF EXISTS rental;
CREATE TABLE rental (
    id SERIAL PRIMARY KEY,
    rental_date TIMESTAMP WITH TIME ZONE NOT NULL,
    inventory_id integer NOT NULL,
    customer_id SMALLINT NOT NULL,
    return_date TIMESTAMP WITH TIME ZONE,
    staff_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,

    CONSTRAINT rental_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT rental_inventory_id_fkey FOREIGN KEY (inventory_id) REFERENCES inventory(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT rental_staff_id_key FOREIGN KEY (staff_id) REFERENCES staff(id)
);
