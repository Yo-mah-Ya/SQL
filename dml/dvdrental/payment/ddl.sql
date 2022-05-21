DROP TABLE IF EXISTS payment;
CREATE TABLE payment (
    id SERIAL PRIMARY KEY,
    customer_id SMALLINT NOT NULL,
    staff_id SMALLINT NOT NULL,
    rental_id INTEGER NOT NULL,
    amount NUMERIC(5,2) NOT NULL,
    payment_date TIMESTAMP WITH TIME ZONE NOT NULL,

    CONSTRAINT payment_customer_id_fkey FOREIGN KEY (customer_id) REFERENCES customer(id) ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT payment_rental_id_fkey FOREIGN KEY (rental_id) REFERENCES rental(id) ON UPDATE CASCADE ON DELETE SET NULL,
    CONSTRAINT payment_staff_id_fkey FOREIGN KEY (staff_id) REFERENCES staff(id) ON UPDATE CASCADE ON DELETE RESTRICT
);
