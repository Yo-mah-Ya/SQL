DROP TABLE IF EXISTS invalid_action_log;
CREATE TABLE invalid_action_log(
    stamp     VARCHAR(255)
  , session   VARCHAR(255)
  , user_id   VARCHAR(255)
  , action    VARCHAR(255)
  , category  VARCHAR(255)
  , products  VARCHAR(255)
  , amount    INTEGER
);

INSERT INTO invalid_action_log
VALUES
    ('2016-11-03 18:10:00', '0CVKaz', 'U001', 'purchase', 'drama' , 'D001,D002', 2000)
  , ('2016-11-03 18:00:00', '0CVKaz', 'U001', 'favorite', 'drama' , 'D001'     , NULL)
  , ('2016-11-03 18:00:00', '0CVKaz', 'U001', 'view'    , NULL    , NULL       , NULL)
  , ('2016-11-03 18:01:00', '0CVKaz', 'U001', 'add_cart', 'drama' , 'D002'     , NULL)
  , ('2016-11-03 18:02:00', '0CVKaz', 'U001', 'add_cart', 'drama' , NULL       , NULL)
  , ('2016-11-04 13:00:00', '1QceiB', 'U002', 'purchase', 'drama' , 'D002'     , 1000)
  , (NULL                 , '1QceiB', 'U002', 'purchase', 'action', 'A005,A006', 1000)
;
