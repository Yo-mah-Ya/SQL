DROP TABLE IF EXISTS mst_users_with_birthday;
CREATE TABLE mst_users_with_birthday (
    user_id        VARCHAR(255)
  , register_stamp VARCHAR(255)
  , birth_date     VARCHAR(255)
);

INSERT INTO mst_users_with_birthday
VALUES
    ('U001', '2016-02-28 10:00:00', '2000-02-29')
  , ('U002', '2016-02-29 10:00:00', '2000-02-29')
  , ('U003', '2016-03-01 10:00:00', '2000-02-29')
;
