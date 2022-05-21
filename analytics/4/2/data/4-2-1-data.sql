DROP TABLE IF EXISTS purchase_detail_log;
CREATE TABLE purchase_detail_log(
    dt           VARCHAR(255)
  , order_id     INTEGER
  , user_id      VARCHAR(255)
  , item_id      VARCHAR(255)
  , price        INTEGER
  , category     VARCHAR(255)
  , sub_category VARCHAR(255)
);

INSERT INTO purchase_detail_log
VALUES
    ('2015-12-01',   1, 'U001', 'D001', 200, 'ladys_fashion', 'bag'        )
  , ('2015-12-08',  95, 'U002', 'D002', 300, 'dvd'          , 'documentary')
  , ('2015-12-09', 168, 'U003', 'D003', 500, 'game'         , 'accessories')
  , ('2015-12-11', 250, 'U004', 'D004', 800, 'ladys_fashion', 'jacket'     )
  , ('2015-12-11', 325, 'U005', 'D005', 200, 'mens_fashion' , 'jacket'     )
  , ('2015-12-12', 400, 'U006', 'D006', 400, 'cd'           , 'classic'    )
  , ('2015-12-11', 475, 'U007', 'D007', 400, 'book'         , 'business'   )
  , ('2015-12-10', 550, 'U008', 'D008', 600, 'food'         , 'meats'      )
  , ('2015-12-10', 625, 'U009', 'D009', 600, 'food'         , 'fish'       )
  , ('2015-12-11', 700, 'U010', 'D010', 200, 'supplement'   , 'protain'    )
;
