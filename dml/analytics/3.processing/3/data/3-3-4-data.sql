DROP TABLE IF EXISTS daily_kpi;
CREATE TABLE daily_kpi (
    dt        VARCHAR(255)
  , indicator VARCHAR(255)
  , val       INTEGER
);

INSERT INTO daily_kpi
VALUES
    ('2017-01-01', 'impressions', 1800)
  , ('2017-01-01', 'sessions'   ,  500)
  , ('2017-01-01', 'users'      ,  200)
  , ('2017-01-02', 'impressions', 2000)
  , ('2017-01-02', 'sessions'   ,  700)
  , ('2017-01-02', 'users'      ,  250)
;

DROP TABLE IF EXISTS purchase_detail_log;
CREATE TABLE purchase_detail_log (
    purchase_id INTEGER
  , product_id  VARCHAR(255)
  , price       INTEGER
);

INSERT INTO purchase_detail_log
VALUES
    (100001, 'A001', 300)
  , (100001, 'A002', 400)
  , (100001, 'A003', 200)
  , (100002, 'D001', 500)
  , (100002, 'D002', 300)
  , (100003, 'A001', 300)
;
