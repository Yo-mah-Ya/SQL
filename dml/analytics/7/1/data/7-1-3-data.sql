DROP TABLE IF EXISTS access_log;
CREATE TABLE access_log(
    session  VARCHAR(255)
  , user_id  VARCHAR(255)
  , action   VARCHAR(255)
  , stamp    VARCHAR(255)
);

INSERT INTO access_log
VALUES
    ('98900e', 'U001', 'view', '2015-01-01 18:00:00')
  , ('98900e', 'U001', 'view', '2015-01-02 20:00:00')
  , ('98900e', 'U001', 'view', '2015-01-03 22:00:00')
  , ('1cf768', 'U002', 'view', '2015-01-04 23:00:00')
  , ('1cf768', 'U002', 'view', '2015-01-05 00:30:00')
  , ('1cf768', 'U002', 'view', '2015-01-06 02:30:00')
  , ('87b575', 'U001', 'view', '2015-01-07 03:30:00')
  , ('87b575', 'U001', 'view', '2015-01-08 04:00:00')
  , ('87b575', 'U001', 'view', '2015-01-09 12:00:00')
  , ('eee2b2', 'U002', 'view', '2015-01-10 13:00:00')
  , ('eee2b2', 'U001', 'view', '2015-01-11 15:00:00')
;
