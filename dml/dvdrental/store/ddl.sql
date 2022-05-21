DROP TABLE IF EXISTS store;
CREATE TABLE store (
    id SERIAL PRIMARY KEY,
    manager_staff_id SMALLINT NOT NULL,
    address_id SMALLINT NOT NULL,
    last_update TIMESTAMP WITH TIME ZONE DEFAULT NOW() NOT NULL,

    CONSTRAINT store_address_id_fkey FOREIGN KEY (address_id) REFERENCES address(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT store_manager_staff_id_fkey FOREIGN KEY (manager_staff_id) REFERENCES staff(id) ON UPDATE CASCADE ON DELETE RESTRICT
);
