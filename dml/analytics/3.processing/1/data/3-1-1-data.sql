DROP TABLE IF EXISTS mst_users;
CREATE TABLE mst_users(
    user_id         VARCHAR(255)
  , register_date   VARCHAR(255)
  , register_device INTEGER
);

INSERT INTO mst_users
VALUES
    ('U001', '2016-08-26', 1)
  , ('U002', '2016-08-26', 2)
  , ('U003', '2016-08-27', 3)
;
