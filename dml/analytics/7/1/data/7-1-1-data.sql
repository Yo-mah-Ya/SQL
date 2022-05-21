DROP TABLE IF EXISTS action_log_with_ip;
CREATE TABLE action_log_with_ip(
    session  VARCHAR(255)
  , user_id  VARCHAR(255)
  , action   VARCHAR(255)
  , ip       VARCHAR(255)
  , stamp    VARCHAR(255)
);

INSERT INTO action_log_with_ip
VALUES
    ('0CVKaz', 'U001', 'view', '216.58.220.238', '2016-11-03 18:00:00')
  , ('1QceiB', 'U002', 'view', '98.139.183.24' , '2016-11-03 19:00:00')
  , ('1hI43A', 'U003', 'view', '210.154.149.63', '2016-11-03 20:00:00')
;
