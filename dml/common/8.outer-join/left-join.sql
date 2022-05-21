WITH employments (code, name) AS (
    VALUES
        ('A001', 'Sato'),
        ('A002', 'James'),
        ('A003', 'Watt'),
        ('A004', 'Cheng'),
        ('A005', 'McGregor')
),
employments_in_uk (code, pos_f) AS (
    VALUES
        ('A001', 0),
        ('A005', 1),
        ('A010', 0)
),
employments_in_us (code, pos_f) AS (
    VALUES
        ('A001', 1),
        ('A002', 0),
        ('A009', 0)
)
SELECT
    e.code,
    e.name,
    uk.code uk_code,
    us.code us_code
FROM
    employments e
    LEFT JOIN employments_in_uk uk ON e.code = uk.code
    LEFT JOIN employments_in_us us ON e.code = us.code
ORDER BY
    e.code ASC;

/*
 code |   name   | uk_code | us_code
------+----------+---------+---------
 A001 | Sato     | A001    | A001
 A002 | James    |         | A002
 A003 | Watt     |         |
 A004 | Cheng    |         |
 A005 | McGregor | A005    |
(5 rows)
 */
WITH employments (code, name) AS (
    VALUES
        ('A001', 'Sato'),
        ('A002', 'James'),
        ('A003', 'Watt'),
        ('A004', 'Cheng'),
        ('A005', 'McGregor')
),
employments_in_uk (code, pos_f) AS (
    VALUES
        ('A001', 0),
        ('A005', 1),
        ('A010', 0)
),
employments_in_us (code, pos_f) AS (
    VALUES
        ('A001', 1),
        ('A002', 0),
        ('A009', 0)
)
SELECT
    e.code,
    e.name,
    uk.code uk_code,
    us.code us_code
FROM
    employments e
    LEFT JOIN employments_in_uk uk ON e.code = uk.code
    LEFT JOIN employments_in_us us ON uk.code = us.code
ORDER BY
    e.code ASC;

/*
 code |   name   | uk_code | us_code
------+----------+---------+---------
 A001 | Sato     | A001    | A001
 A002 | James    |         |
 A003 | Watt     |         |
 A004 | Cheng    |         |
 A005 | McGregor | A005    |
(5 rows)
 */
