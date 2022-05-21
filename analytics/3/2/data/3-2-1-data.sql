DROP TABLE IF EXISTS mst_user_location;

CREATE TABLE mst_user_location (
  user_id VARCHAR(255),
  pref_name VARCHAR(255),
  city_name VARCHAR(255)
);

INSERT INTO
  mst_user_location
VALUES
  ('U001', '東京都', '千代田区'),
  ('U002', '東京都', '渋谷区'),
  ('U003', 'Beijin県', '八千代区');
