/* 既存のコード体系を新しい体系に変換して集計 */
CREATE TABLE pop_tbl (
    pref_name VARCHAR(32) PRIMARY KEY,
    population INTEGER NOT NULL
);

INSERT INTO
    pop_tbl
VALUES
    ('徳島', 100),
    ('香川', 200),
    ('愛媛', 150),
    ('高知', 200),
    ('福岡', 300),
    ('佐賀', 100),
    ('長崎', 200),
    ('Singapore', 400),
    ('群馬', 50);

/* 異なる条件の集計を1つのSQLで行う */
CREATE TABLE pop_tbl2 (
    pref_name VARCHAR(32),
    sex CHAR(1) NOT NULL,
    population INTEGER NOT NULL,
    PRIMARY KEY(pref_name, sex)
);

INSERT INTO
    pop_tbl2
VALUES
    ('徳島', '1', 60),
    ('徳島', '2', 40),
    ('香川', '1', 100),
    ('香川', '2', 100),
    ('愛媛', '1', 100),
    ('愛媛', '2', 50),
    ('高知', '1', 100),
    ('高知', '2', 100),
    ('福岡', '1', 100),
    ('福岡', '2', 200),
    ('佐賀', '1', 20),
    ('佐賀', '2', 80),
    ('長崎', '1', 125),
    ('長崎', '2', 125),
    ('Singapore', '1', 250),
    ('Singapore', '2', 150);

/* CHECK制約で複数の列の条件関係を定義する */
CREATE TABLE TestSal (
    sex CHAR(1),
    salary INTEGER,
    CONSTRAINT check_salary CHECK (
        CASE
            WHEN sex = '2' THEN CASE
                WHEN salary <= 200000 THEN 1
                ELSE 0
            END
            ELSE 1
        END = 1
    )
);

INSERT INTO
    TestSal
VALUES
    (1, 200000),
    (1, 300000),
    (1, NULL),
    (2, 200000),
    (2, 300000),
    (2, NULL),
    (1, 300000);

/* 条件を分岐させたUPDATE */
CREATE TABLE sample_table (
    p_key CHAR(1) PRIMARY KEY,
    col_1 INTEGER NOT NULL,
    col_2 CHAR(2) NOT NULL
);

INSERT INTO
    sample_table
VALUES
    ('a', 1, 'あ'),
    ('b', 2, 'い'),
    ('c', 3, 'う');

/* テーブル同士のマッチング */
CREATE TABLE course_master (
    course_id INTEGER PRIMARY KEY,
    course_name VARCHAR(32) NOT NULL
);

INSERT INTO
    course_master
VALUES
    (1, '経理入門'),
    (2, '財務知識'),
    (3, '簿記検定'),
    (4, '税理士');

CREATE TABLE open_courses (
    MONTH INTEGER,
    course_id INTEGER,
    PRIMARY KEY(MONTH, course_id)
);

INSERT INTO
    open_courses
VALUES
    (201806, 1),
    (201806, 3),
    (201806, 4),
    (201807, 4),
    (201808, 2),
    (201808, 4);

/* CASE式の中で集約関数を使う */
CREATE TABLE student_club (
    std_id INTEGER,
    club_id INTEGER,
    club_name VARCHAR(32),
    main_club_flg CHAR(1),
    PRIMARY KEY (std_id, club_id)
);

INSERT INTO
    student_club
VALUES
    (100, 1, '野球', 'Y'),
    (100, 2, '吹奏楽', 'N'),
    (200, 2, '吹奏楽', 'N'),
    (200, 3, 'バドミントン', 'Y'),
    (200, 4, 'サッカー', 'N'),
    (300, 4, 'サッカー', 'N'),
    (400, 5, '水泳', 'N'),
    (500, 6, '囲碁', 'N');

SELECT
    CASE
        pref_name
        WHEN '徳島' THEN '四国'
        WHEN '香川' THEN '四国'
        WHEN '愛媛' THEN '四国'
        WHEN '高知' THEN '四国'
        WHEN '福岡' THEN '九州'
        WHEN '佐賀' THEN '九州'
        WHEN '長崎' THEN '九州'
        ELSE 'その他'
    END AS district,
    SUM(population)
FROM
    pop_tbl
GROUP BY
    CASE
        pref_name
        WHEN '徳島' THEN '四国'
        WHEN '香川' THEN '四国'
        WHEN '愛媛' THEN '四国'
        WHEN '高知' THEN '四国'
        WHEN '福岡' THEN '九州'
        WHEN '佐賀' THEN '九州'
        WHEN '長崎' THEN '九州'
        ELSE 'その他'
    END;

--人口階級ごとに都道府県を分類する
SELECT
    CASE
        WHEN population < 100 THEN '01'
        WHEN population >= 100
        AND population < 200 THEN '02'
        WHEN population >= 200
        AND population < 300 THEN '03'
        WHEN population >= 300 THEN '04'
        ELSE NULL
    END AS pop_class,
    COUNT(*) AS cnt
FROM
    pop_tbl
GROUP BY
    CASE
        WHEN population < 100 THEN '01'
        WHEN population >= 100
        AND population < 200 THEN '02'
        WHEN population >= 200
        AND population < 300 THEN '03'
        WHEN population >= 300 THEN '04'
        ELSE NULL
    END;

--地方単位にコードを再分類する その2：CASE式を一箇所にまとめる
SELECT
    CASE
        pref_name
        WHEN '徳島' THEN '四国'
        WHEN '香川' THEN '四国'
        WHEN '愛媛' THEN '四国'
        WHEN '高知' THEN '四国'
        WHEN '福岡' THEN '九州'
        WHEN '佐賀' THEN '九州'
        WHEN '長崎' THEN '九州'
        ELSE 'その他'
    END AS district,
    SUM(population)
FROM
    pop_tbl
GROUP BY
    district;

SELECT
    pref_name,
    population
FROM
    pop_tbl2
WHERE
    sex = '1';

SELECT
    pref_name,
    population
FROM
    pop_tbl2
WHERE
    sex = '2';

SELECT
    pref_name,
    --男性の人口
    SUM(
        CASE
            WHEN sex = '1' THEN population
            ELSE 0
        END
    ) AS cnt_m,
    --女性の人口
    SUM(
        CASE
            WHEN sex = '2' THEN population
            ELSE 0
        END
    ) AS cnt_f
FROM
    pop_tbl2
GROUP BY
    pref_name;

SELECT
    pref_name,
    --男性の人口
    CASE
        WHEN sex = '1' THEN population
        ELSE 0
    END AS cnt_m,
    --女性の人口
    CASE
        WHEN sex = '2' THEN population
        ELSE 0
    END AS cnt_f
FROM
    pop_tbl2;

CONSTRAINT check_salary CHECK (
    CASE
        WHEN sex = '2' THEN CASE
            WHEN salary <= 200000 THEN 1
            ELSE 0
        END
        ELSE 1
    END = 1
) CONSTRAINT check_salary CHECK (
    sex = '2'
    AND salary <= 200000
) --条件1
UPDATE
    personnel
SET
    salary = salary * 0.9
WHERE
    salary >= 300000;

--条件2
UPDATE
    personnel
SET
    salary = salary * 1.2
WHERE
    salary >= 250000
    AND salary < 280000;

UPDATE
    personnel
SET
    salary = CASE
        WHEN salary >= 300000 THEN salary * 0.9
        WHEN salary >= 250000
        AND salary < 280000 THEN salary * 1.2
        ELSE salary
    END;

--1．aをワーク用の値dへ退避
UPDATE
    sample_table
SET
    p_key = 'd'
WHERE
    p_key = 'a';

--2．bをaへ変換
UPDATE
    sample_table
SET
    p_key = 'a'
WHERE
    p_key = 'b';

--3．dをbへ変換
UPDATE
    sample_table
SET
    p_key = 'b'
WHERE
    p_key = 'd';

--CASE式で主キーを入れ替える
UPDATE
    sample_table
SET
    p_key = CASE
        WHEN p_key = 'a' THEN 'b'
        WHEN p_key = 'b' THEN 'a'
        ELSE p_key
    END
WHERE
    p_key IN ('a', 'b');

--テーブルのマッチング：IN述語の利用
SELECT
    course_name,
    CASE
        WHEN course_id IN (
            SELECT
                course_id
            FROM
                open_courses
            WHERE
                MONTH = 201806
        ) THEN '○'
        ELSE 'x'
    END AS "6 月",
    CASE
        WHEN course_id IN (
            SELECT
                course_id
            FROM
                open_courses
            WHERE
                MONTH = 201807
        ) THEN '○'
        ELSE 'x'
    END AS "7 月",
    CASE
        WHEN course_id IN (
            SELECT
                course_id
            FROM
                open_courses
            WHERE
                MONTH = 201808
        ) THEN '○'
        ELSE 'x'
    END AS "8 月"
FROM
    course_master;

--テーブルのマッチング：EXISTS述語の利用
SELECT
    CM.course_name,
    CASE
        WHEN EXISTS (
            SELECT
                course_id
            FROM
                open_courses OC
            WHERE
                MONTH = 201806
                AND OC.course_id = CM.course_id
        ) THEN '○'
        ELSE 'x'
    END AS "6 月",
    CASE
        WHEN EXISTS (
            SELECT
                course_id
            FROM
                open_courses OC
            WHERE
                MONTH = 201807
                AND OC.course_id = CM.course_id
        ) THEN '○'
        ELSE 'x'
    END AS "7 月",
    CASE
        WHEN EXISTS (
            SELECT
                course_id
            FROM
                open_courses OC
            WHERE
                MONTH = 201808
                AND OC.course_id = CM.course_id
        ) THEN '○'
        ELSE 'x'
    END AS "8 月"
FROM
    course_master CM;

--条件1：1つのクラブに専念している学生を選択
SELECT
    std_id,
    MAX(club_id) AS main_club
FROM
    student_club
GROUP BY
    std_id
HAVING
    COUNT(*) = 1;

--条件2：クラブをかけ持ちしている学生を選択
SELECT
    std_id,
    club_id AS main_club
FROM
    student_club
WHERE
    main_club_flg = 'Y';

SELECT
    std_id,
    CASE
        WHEN COUNT(*) = 1 --1つのクラブに専念する学生の場合
        THEN MAX(club_id)
        ELSE MAX(
            CASE
                WHEN main_club_flg = 'Y' THEN club_id
                ELSE NULL
            END
        )
    END AS main_club
FROM
    student_club
GROUP BY
    std_id;
