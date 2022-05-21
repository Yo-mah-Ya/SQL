DROP TABLE IF EXISTS quarterly_sales;
CREATE TABLE quarterly_sales (
    year INTEGER
  , q1   INTEGER
  , q2   INTEGER
  , q3   INTEGER
  , q4   INTEGER
);

INSERT INTO quarterly_sales
VALUES
    (2015, 82000, 83000, 78000, 83000)
  , (2016, 85000, 85000, 80000, 81000)
  , (2017, 92000, 81000, NULL , NULL )
;
