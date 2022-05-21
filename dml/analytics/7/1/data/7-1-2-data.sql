DROP TABLE IF EXISTS neighbor_pref;

CREATE TABLE neighbor_pref(
  pref_id INTEGER,
  pref_name VARCHAR(255),
  neighbor_pref_id INTEGER,
  neighbor_pref_name VARCHAR(255)
);

INSERT INTO
  neighbor_pref
VALUES
  (1, '北海道', 2, '青森県'),
  (2, '青森県', 1, '北海道'),
  (2, '青森県', 3, '岩手県'),
  (2, '青森県', 5, '秋田県'),
  (3, '岩手県', 2, '青森県'),
  (3, '岩手県', 4, '宮城県'),
  (3, '岩手県', 5, '秋田県');

DROP TABLE IF EXISTS reservations;

CREATE TABLE reservations(
  rsv_id INTEGER,
  stamp VARCHAR(255),
  member_id INTEGER,
  member_pref_id INTEGER,
  member_pref_name VARCHAR(255),
  spot_id INTEGER,
  spot_pref_id INTEGER,
  spot_pref_name VARCHAR(255)
);

INSERT INTO
  reservations
VALUES
  (
    27414,
    '2016-12-31 07:36:48',
    50063,
    21,
    '岐阜県',
    4454,
    47,
    '沖縄県'
  ),
  (
    27415,
    '2016-12-31 15:34:21',
    43065,
    19,
    '山梨県',
    4899,
    27,
    '大阪府'
  ),
  (
    27416,
    '2016-12-31 16:05:10',
    31038,
    6,
    '山形県',
    7839,
    15,
    '新潟県'
  ),
  (
    27417,
    '2016-12-31 17:48:57',
    53901,
    34,
    '広島県',
    1972,
    4,
    '宮城県'
  ),
  (
    27418,
    '2016-12-31 23:24:33',
    54998,
    12,
    'Beijin県',
    2227,
    3,
    '岩手県'
  ),
  (
    27419,
    '2017-01-01 02:43:20',
    34078,
    47,
    '沖縄県',
    5522,
    12,
    'Beijin県'
  ),
  (
    27420,
    '2017-01-01 05:06:10',
    53307,
    26,
    '京都府',
    6559,
    12,
    'Beijin県'
  ),
  (
    27421,
    '2017-01-01 08:37:36',
    35423,
    24,
    '三重県',
    5500,
    20,
    '長野県'
  );
