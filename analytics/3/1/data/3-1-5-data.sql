DROP TABLE IF EXISTS purchase_log_with_coupon;
CREATE TABLE purchase_log_with_coupon (
    purchase_id VARCHAR(255)
  , amount      INTEGER
  , coupon      INTEGER
);

INSERT INTO purchase_log_with_coupon
VALUES
    ('10001', 3280, NULL)
  , ('10002', 4650,  500)
  , ('10003', 3870, NULL)
;
