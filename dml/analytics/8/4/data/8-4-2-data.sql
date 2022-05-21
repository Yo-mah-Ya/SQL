DROP TABLE IF EXISTS action_counts;
CREATE TABLE action_counts(
    user_id        VARCHAR(255)
  , product        VARCHAR(255)
  , view_count     INTEGER
  , purchase_count INTEGER
);

INSERT INTO action_counts
VALUES
    ('U001', 'D001',  2, 1)
  , ('U001', 'D002', 16, 0)
  , ('U001', 'D003', 14, 0)
  , ('U001', 'D004', 15, 0)
  , ('U001', 'D005', 21, 1)
  , ('U002', 'D001', 10, 1)
  , ('U002', 'D003', 28, 0)
  , ('U002', 'D005', 28, 1)
  , ('U003', 'D001', 49, 0)
  , ('U003', 'D004', 29, 1)
  , ('U003', 'D005', 24, 1)
;
