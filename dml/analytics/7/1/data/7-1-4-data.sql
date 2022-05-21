DROP TABLE IF EXISTS action_log;
CREATE TABLE action_log(
    session  VARCHAR(255)
  , user_id  VARCHAR(255)
  , action   VARCHAR(255)
  , stamp    VARCHAR(255)
);

INSERT INTO action_log
VALUES
    ('98900e', 'U001', 'view', '2016-11-03 18:00:00')
  , ('98900e', 'U001', 'view', '2016-11-03 20:00:00')
  , ('98900e', 'U001', 'view', '2016-11-03 22:00:00')
  , ('1cf768', 'U002', 'view', '2016-11-03 23:00:00')
  , ('1cf768', 'U002', 'view', '2016-11-04 00:30:00')
  , ('1cf768', 'U002', 'view', '2016-11-04 02:30:00')
  , ('87b575', 'U001', 'view', '2016-11-04 03:30:00')
  , ('87b575', 'U001', 'view', '2016-11-04 04:00:00')
  , ('87b575', 'U001', 'view', '2016-11-04 12:00:00')
  , ('eee2b2', 'U002', 'view', '2016-11-04 13:00:00')
  , ('eee2b2', 'U001', 'view', '2016-11-04 15:00:00')
;