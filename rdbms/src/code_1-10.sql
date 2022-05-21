CREATE TABLE digits (digit INTEGER PRIMARY KEY);

INSERT INTO
    digits
VALUES
    (0),
    (1),
    (2),
    (3),
    (4),
    (5),
    (6),
    (7),
    (8),
    (9);

-- 0 ~ 99
SELECT
    D1.digit + (D2.digit * 10) AS seq
FROM
    digits D1
    CROSS JOIN digits D2
ORDER BY
    seq;

-- 1 ~ 542
SELECT
    D1.digit + (D2.digit * 10) + (D3.digit * 100) AS seq
FROM
    digits D1
    CROSS JOIN digits D2
    CROSS JOIN digits D3
WHERE
    D1.digit + (D2.digit * 10) + (D3.digit * 100) BETWEEN 1
    AND 542
ORDER BY
    seq;

--欠番を全部求める
CREATE TABLE seq_tbl (seq INTEGER PRIMARY KEY);

INSERT INTO
    seq_tbl
VALUES
    (1),
    (2),
    (4),
    (5),
    (6),
    (7),
    (8),
    (11),
    (12);

-- sequence view from 0 to 999
CREATE VIEW Sequence (seq) AS
SELECT
    D1.digit + (D2.digit * 10) + (D3.digit * 100)
FROM
    digits D1
    CROSS JOIN digits D2
    CROSS JOIN digits D3;

SELECT
    seq
FROM
    Sequence
WHERE
    seq BETWEEN 1
    AND 100
ORDER BY
    seq;

-- EXCEPT
SELECT
    seq
FROM
    Sequence
WHERE
    seq BETWEEN 1
    AND 12
EXCEPT
SELECT
    seq
FROM
    seq_tbl;

-- NOT IN
SELECT
    seq
FROM
    Sequence
WHERE
    seq BETWEEN 1
    AND 12
    AND seq NOT IN (
        SELECT
            seq
        FROM
            seq_tbl
    );

-- 連番の範囲を動的に決定するクエリ
SELECT
    seq
FROM
    Sequence
WHERE
    seq BETWEEN (
        SELECT
            MIN(seq)
        FROM
            seq_tbl
    )
    AND (
        SELECT
            MAX(seq)
        FROM
            seq_tbl
    )
EXCEPT
SELECT
    seq
FROM
    seq_tbl;

-- 3人なんですけど、座れますか？
CREATE TABLE seats_table (
    seat INTEGER NOT NULL PRIMARY KEY,
    STATUS CHAR(2) NOT NULL CHECK (STATUS IN ('available', 'fully booked'))
);

INSERT INTO
    seats_table
VALUES
    (1, 'fully booked'),
    (2, 'fully booked'),
    (3, 'available'),
    (4, 'available'),
    (5, 'available'),
    (6, 'fully booked'),
    (7, 'available'),
    (8, 'available'),
    (9, 'available'),
    (10, 'available'),
    (11, 'available'),
    (12, 'fully booked'),
    (13, 'fully booked'),
    (14, 'available'),
    (15, 'available');

-- 人数分の空席を探す：その1　NOT EXISTS
SELECT
    s1.seat AS start_seat,
    '~',
    s2.seat AS end_seat
FROM
    seats_table s1,
    seats_table s2
WHERE
    s2.seat = s1.seat + (:head_cnt -1) --始点と終点を決める
    AND NOT EXISTS (
        SELECT
            *
        FROM
            seats_table S3
        WHERE
            S3.seat BETWEEN s1.seat
            AND s2.seat
            AND S3.status <> 'available'
    );

-- 折り返しも考慮
CREATE TABLE seats_table2 (
    seat INTEGER NOT NULL PRIMARY KEY,
    line_id CHAR(1) NOT NULL,
    STATUS CHAR(2) NOT NULL CHECK (STATUS IN ('available', 'fully booked'))
);

INSERT INTO
    seats_table2
VALUES
    (1, 'A', 'fully booked'),
    (2, 'A', 'fully booked'),
    (3, 'A', 'available'),
    (4, 'A', 'available'),
    (5, 'A', 'available'),
    (6, 'B', 'fully booked'),
    (7, 'B', 'fully booked'),
    (8, 'B', 'available'),
    (9, 'B', 'available'),
    (10, 'B', 'available'),
    (11, 'C', 'available'),
    (12, 'C', 'available'),
    (13, 'C', 'available'),
    (14, 'C', 'fully booked'),
    (15, 'C', 'available');

-- 人数分の空席を探す：その2　ウィンドウ関数
SELECT
    seat,
    '~',
    seat + (:head_cnt -1)
FROM
    (
        SELECT
            seat,
            MAX(seat) OVER(
                ORDER BY
                    seat ROWS BETWEEN (:head_cnt -1) FOLLOWING
                    AND (:head_cnt -1) FOLLOWING
            ) AS end_seat
        FROM
            seats_table
        WHERE
            STATUS = 'available'
    ) tmp
WHERE
    end_seat - seat = (:head_cnt -1);

-- 人数分の空席を探す：ラインの折り返しも考慮する　NOT EXISTS
SELECT
    s1.seat AS start_seat,
    '~',
    s2.seat AS end_seat
FROM
    seats_table2 s1,
    seats_table2 s2
WHERE
    s2.seat = s1.seat + (:head_cnt -1) --始点と終点を決める
    AND NOT EXISTS (
        SELECT
            *
        FROM
            seats_table2 S3
        WHERE
            S3.seat BETWEEN s1.seat
            AND s2.seat
            AND (
                S3.status <> 'available'
                OR S3.line_id <> s1.line_id
            )
    );

-- 人数分の空席を探す：行の折り返しも考慮する　ウィンドウ関数
SELECT
    seat,
    '~',
    seat + (:head_cnt - 1)
FROM
    (
        SELECT
            seat,
            MAX(seat) OVER(
                PARTITION BY line_id
                ORDER BY
                    seat ROWS BETWEEN (:head_cnt - 1) FOLLOWING
                    AND (:head_cnt - 1) FOLLOWING
            ) AS end_seat
        FROM
            seats_table2
        WHERE
            STATUS = 'available'
    ) tmp
WHERE
    end_seat - seat = (:head_cnt - 1);

-- 単調増加と単調減少
CREATE TABLE my_stock (
    deal_date DATE PRIMARY KEY,
    price INTEGER
);

INSERT INTO
    my_stock
VALUES
    ('2018-01-06', 1000),
    ('2018-01-08', 1050),
    ('2018-01-09', 1050),
    ('2018-01-12', 900),
    ('2018-01-13', 880),
    ('2018-01-14', 870),
    ('2018-01-16', 920),
    ('2018-01-17', 1000),
    ('2018-01-18', 2000);

-- 前回取引から上昇したかどうかを判断する
SELECT
    deal_date,
    price,
    CASE
        SIGN(
            price - MAX(price) OVER(
                ORDER BY
                    deal_date ROWS BETWEEN 1 PRECEDING
                    AND 1 PRECEDING
            )
        )
        WHEN 1 THEN 'up'
        WHEN 0 THEN 'stay'
        WHEN -1 THEN 'down'
        ELSE NULL
    END AS diff
FROM
    my_stock;

CREATE VIEW my_stock_up_seq(deal_date, price, row_num) AS
SELECT
    deal_date,
    price,
    row_num
FROM
    (
        SELECT
            deal_date,
            price,
            CASE
                SIGN(
                    price - MAX(price) OVER(
                        ORDER BY
                            deal_date ROWS BETWEEN 1 PRECEDING
                            AND 1 PRECEDING
                    )
                )
                WHEN 1 THEN 'up'
                WHEN 0 THEN 'stay'
                WHEN -1 THEN 'down'
                ELSE NULL
            END AS diff,
            ROW_NUMBER() OVER(
                ORDER BY
                    deal_date
            ) AS row_num
        FROM
            my_stock
    ) tmp
WHERE
    diff = 'up';

-- 自己結合でシーケンスをグループ化
SELECT
    MIN(deal_date) AS start_date,
    '~',
    MAX(deal_date) AS end_date
FROM
    (
        SELECT
            M1.deal_date,
            COUNT(M2.row_num) - MIN(M1.row_num) AS gap
        FROM
            my_stock_up_seq M1
            INNER JOIN my_stock_up_seq M2 ON M2.row_num <= M1.row_num
        GROUP BY
            M1.deal_date
    ) tmp
GROUP BY
    gap;

SELECT
    M1.deal_date,
    COUNT(M2.row_num) cnt,
    MIN(M1.row_num) min_row_num,
    COUNT(M2.row_num) - MIN(M1.row_num) AS gap
FROM
    my_stock_up_seq M1
    INNER JOIN my_stock_up_seq M2 ON M2.row_num <= M1.row_num
GROUP BY
    M1.deal_date;
