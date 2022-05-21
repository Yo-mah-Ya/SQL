DROP TABLE IF EXISTS mst_products_20161201;
CREATE TABLE mst_products_20161201(
    product_id  VARCHAR(255)
  , name        VARCHAR(255)
  , price       INTEGER
  , updated_at  VARCHAR(255)
);

INSERT INTO mst_products_20161201
VALUES
    ('A001', 'AAA', 300, '2016-11-03 18:00:00')
  , ('A002', 'AAB', 400, '2016-11-03 19:00:00')
  , ('B001', 'BBB', 500, '2016-11-03 20:00:00')
  , ('B002', 'BBD', 300, '2016-11-03 21:00:00')
  , ('C001', 'CCA', 400, '2016-11-04 18:00:00')
  , ('D001', 'DAA', 500, '2016-11-04 19:00:00')
;

DROP TABLE IF EXISTS mst_products_20170101;
CREATE TABLE mst_products_20170101(
    product_id  VARCHAR(255)
  , name        VARCHAR(255)
  , price       INTEGER
  , updated_at  VARCHAR(255)
);

INSERT INTO mst_products_20170101
  VALUES
    ('A001', 'AAA', 300, '2016-11-03 18:00:00')
  , ('A002', 'AAB', 400, '2016-11-03 19:00:00')
  , ('B002', 'BBD', 300, '2016-11-03 21:00:00')
  , ('C001', 'CCA', 500, '2016-12-04 18:00:00')
  , ('D001', 'DAA', 500, '2016-11-04 19:00:00')
  , ('D002', 'DAD', 500, '2016-12-04 19:00:00')
;
