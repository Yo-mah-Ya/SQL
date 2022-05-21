-- workout1-①：複数列の最大値
CREATE TABLE Greatests (
    KEY CHAR(1) PRIMARY KEY,
    x INTEGER NOT NULL,
    y INTEGER NOT NULL,
    z INTEGER NOT NULL
);

INSERT INTO
    Greatests
VALUES
    ('A', 1, 2, 3),
    ('B', 5, 5, 2),
    ('C', 4, 7, 1),
    ('D', 3, 3, 8);

-- xとyの最大値
SELECT
    KEY,
    CASE
        WHEN x < y THEN y
        ELSE x
    END AS greatest
FROM
    Greatests;

-- xとyとzの最大値
SELECT
    KEY,
    CASE
        WHEN CASE
            WHEN x < y THEN y
            ELSE x
        END < z THEN z
        ELSE CASE
            WHEN x < y THEN y
            ELSE x
        END
    END AS greatest
FROM
    Greatests;

-- Oracle、MySQL、PostgreSQL
SELECT
    KEY,
    GREATEST(GREATEST(x, y), z) AS greatest
FROM
    Greatests;

-- workout1-②：合計と再掲を表頭に出力する行列変換
CREATE TABLE pop_tbl2 (
    pref_name VARCHAR(32),
    sex CHAR(1) NOT NULL,
    population INTEGER NOT NULL,
    PRIMARY KEY(pref_name, sex)
);

INSERT INTO
    pop_tbl2
VALUES
    ('Boston', '1', 60),
    ('Boston', '2', 40),
    ('Vancouver', '1', 100),
    ('Vancouver', '2', 100),
    ('Paris', '1', 100),
    ('Paris', '2', 50),
    ('Los Angeles', '1', 100),
    ('Los Angeles', '2', 100),
    ('Houston', '1', 100),
    ('Houston', '2', 200),
    ('New York', '1', 20),
    ('New York', '2', 80),
    ('Berlin', '1', 125),
    ('Berlin', '2', 125),
    ('Singapore', '1', 250),
    ('Singapore', '2', 150);

SELECT
    sex,
    SUM(population) AS total,
    SUM(
        CASE
            WHEN pref_name = 'Boston' THEN population
            ELSE 0
        END
    ) AS tokushima,
    SUM(
        CASE
            WHEN pref_name = 'Vancouver' THEN population
            ELSE 0
        END
    ) AS kagawa,
    SUM(
        CASE
            WHEN pref_name = 'Paris' THEN population
            ELSE 0
        END
    ) AS ehime,
    SUM(
        CASE
            WHEN pref_name = 'Los Angeles' THEN population
            ELSE 0
        END
    ) AS kouchi,
    SUM(
        CASE
            WHEN pref_name IN ('Boston', 'Vancouver', 'Paris', 'Los Angeles') THEN population
            ELSE 0
        END
    ) AS saikei
FROM
    pop_tbl2
GROUP BY
    sex;

-- workout1-③：ORDER BYでソート列を作る
SELECT
    KEY
FROM
    Greatests
ORDER BY
    CASE
        KEY
        WHEN 'B' THEN 1
        WHEN 'A' THEN 2
        WHEN 'D' THEN 3
        WHEN 'C' THEN 4
        ELSE NULL
    END;

SELECT
    KEY,
    CASE
        KEY
        WHEN 'B' THEN 1
        WHEN 'A' THEN 2
        WHEN 'D' THEN 3
        WHEN 'C' THEN 4
        ELSE NULL
    END AS sort_col
FROM
    Greatests
ORDER BY
    sort_col;

-- workout2-①：ウィンドウ関数の結果予想　その1
CREATE TABLE serverload_sample (
    server CHAR(4) NOT NULL,
    sample_date DATE NOT NULL,
    load_val INTEGER NOT NULL,
    PRIMARY KEY (server, sample_date)
);

INSERT INTO
    serverload_sample
VALUES
    ('A', '2018-02-01', 1024),
    ('A', '2018-02-02', 2366),
    ('A', '2018-02-05', 2366),
    ('A', '2018-02-07', 985),
    ('A', '2018-02-08', 780),
    ('A', '2018-02-12', 1000),
    ('B', '2018-02-01', 54),
    ('B', '2018-02-02', 39008),
    ('B', '2018-02-03', 2900),
    ('B', '2018-02-04', 556),
    ('B', '2018-02-05', 12600),
    ('B', '2018-02-06', 7309),
    ('C', '2018-02-01', 1000),
    ('C', '2018-02-07', 2000),
    ('C', '2018-02-16', 500);

SELECT
    server,
    sample_date,
    SUM(load_val) OVER () AS sum_load
FROM
    serverload_sample;

-- workout2-②：ウィンドウ関数の結果予想 その2
SELECT
    server,
    sample_date,
    SUM(load_val) OVER (PARTITION BY server) AS sum_load
FROM
    serverload_sample;

-- workout3-①：重複組み合わせ
SELECT
    P1.name AS name_1,
    P2.name AS name_2
FROM
    products P1
    INNER JOIN products P2 ON P1.name >= P2.name;

-- workout3-②：ウィンドウ関数で重複削除
DROP TABLE products;

CREATE TABLE products (
    name VARCHAR(16) NOT NULL,
    price INTEGER NOT NULL
);

--重複するレコード
INSERT INTO
    products
VALUES
    ('apple', 50),
    ('orange', 100),
    ('orange', 100),
    ('orange', 100),
    ('banana', 80);

-- (name, price)のパーティションに一意な連番を振ったテーブルを作成
CREATE TABLE products_no_redundant AS
SELECT
    ROW_NUMBER() OVER(
        PARTITION BY name,
        price
        ORDER BY
            name
    ) AS row_num,
    name,
    price
FROM
    products;

-- 連番が1以外のレコードを削除
DELETE FROM
    products_no_redundant
WHERE
    row_num > 1;

DELETE FROM
    (
        SELECT
            ROW_NUMBER() OVER(
                PARTITION BY name,
                price
                ORDER BY
                    name
            ) AS row_num
        FROM
            products
    )
WHERE
    row_num > 1;

-- workout5-①：配列テーブル行持ちの場合
/* 5-1：配列テーブル――行持ちの場合 */
CREATE TABLE array_tbl2 (
    KEY CHAR(1) NOT NULL,
    i INTEGER NOT NULL,
    val INTEGER,
    PRIMARY KEY (KEY, i)
);

/* AはオールNULL、Bは一つだけ非NULL、Cはオール非NULL */
INSERT INTO
    array_tbl2
VALUES
    ('A', 1, NULL),
    ('A', 2, NULL),
    ('A', 3, NULL),
    ('A', 4, NULL),
    ('A', 5, NULL),
    ('A', 6, NULL),
    ('A', 7, NULL),
    ('A', 8, NULL),
    ('A', 9, NULL),
    ('A', 10, NULL),
    ('B', 1, 3),
    ('B', 2, NULL),
    ('B', 3, NULL),
    ('B', 4, NULL),
    ('B', 5, NULL),
    ('B', 6, NULL),
    ('B', 7, NULL),
    ('B', 8, NULL),
    ('B', 9, NULL),
    ('B', 10, NULL),
    ('C', 1, 1),
    ('C', 2, 1),
    ('C', 3, 1),
    ('C', 4, 1),
    ('C', 5, 1),
    ('C', 6, 1),
    ('C', 7, 1),
    ('C', 8, 1),
    ('C', 9, 1),
    ('C', 10, 1);

-- 間違った答え
SELECT
    DISTINCT KEY
FROM
    array_tbl2 AT1
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            array_tbl2 AT2
        WHERE
            AT1.key = AT2.key
            AND AT2.val <> 1
    );

-- 正しい答え
SELECT
    DISTINCT KEY
FROM
    array_tbl2 A1
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            array_tbl2 A2
        WHERE
            A1.key = A2.key
            AND (
                A2.val <> 1
                OR A2.val IS NULL
            )
    );

-- 別解1：ALL述語の利用
SELECT
    DISTINCT KEY
FROM
    array_tbl2 A1
WHERE
    1 = ALL (
        SELECT
            val
        FROM
            array_tbl2 A2
        WHERE
            A1.key = A2.key
    );

-- 別解2：HAVING句の利用
SELECT
    KEY
FROM
    array_tbl2
GROUP BY
    KEY
HAVING
    SUM(
        CASE
            WHEN val = 1 THEN 1
            ELSE 0
        END
    ) = 10;

-- 別解その3：HAVING句で極値関数を利用する
SELECT
    KEY
FROM
    array_tbl2
GROUP BY
    KEY
HAVING
    MAX(val) = 1
    AND MIN(val) = 1;

-- workout5-②：ALL述語によるuniversal quantifier
-- 工程1 番までfinishedのプロジェクトを選択：ALL述語による解答
SELECT
    *
FROM
    projects P1
WHERE
    '○' = ALL (
        SELECT
            CASE
                WHEN step_nbr <= 1
                AND STATUS = 'finished' THEN '○'
                WHEN step_nbr > 1
                AND STATUS = 'wating' THEN '○'
                ELSE 'x'
            END
        FROM
            projects P2
        WHERE
            P1.project_id = P2.project_id
    );

-- workout5-③：素数を求める
CREATE TABLE Digits (digit INTEGER PRIMARY KEY);

INSERT INTO
    Digits
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

DROP TABLE Numbers;

CREATE TABLE Numbers AS
SELECT
    D1.digit + (D2.digit * 10) AS num
FROM
    Digits D1
    CROSS JOIN Digits D2
WHERE
    D1.digit + (D2.digit * 10) BETWEEN 1
    AND 100;

-- 答え： NOT EXISTSでuniversal quantifierを表現
SELECT
    num AS prime
FROM
    Numbers Dividend
WHERE
    num > 1
    AND NOT EXISTS (
        SELECT
            *
        FROM
            Numbers Divisor
        WHERE
            Divisor.num <= Dividend.num / 2
            AND Divisor.num <> 1 --1 は約数に含まない
            AND MOD(Dividend.num, Divisor.num) = 0
    )
ORDER BY
    prime;

-- workout6-①：歯抜けを探す——改良版
SELECT
    ' 歯抜けあり' AS gap
FROM
    sequence_table
HAVING
    COUNT(*) <> MAX(seq)
UNION
ALL
SELECT
    ' 歯抜けなし' AS gap
FROM
    sequence_table
HAVING
    COUNT(*) = MAX(seq);

SELECT
    CASE
        WHEN COUNT(*) <> MAX(seq) THEN '歯抜けあり'
        ELSE '歯抜けなし'
    END AS gap
FROM
    sequence_table;

-- workout6-②：特性関数の練習
-- 全員が9月中に提出済みの学部を選択する　その1：BETWEEN述語の利用
SELECT
    dpt
FROM
    students
GROUP BY
    dpt
HAVING
    COUNT(*) = SUM(
        CASE
            WHEN sbmt_date BETWEEN '2018-09-01'
            AND '2018-09-30' THEN 1
            ELSE 0
        END
    );

SELECT
    dpt
FROM
    students
GROUP BY
    dpt
HAVING
    COUNT(*) = SUM(
        CASE
            WHEN EXTRACT (
                YEAR
                FROM
                    sbmt_date
            ) = 2018
            AND EXTRACT (
                MONTH
                FROM
                    sbmt_date
            ) = 09 THEN 1
            ELSE 0
        END
    );

-- workout6-③：関係除算の改良
SELECT
    SI.shop,
    COUNT(SI.item) AS my_item_cnt,
    (
        SELECT
            COUNT(item)
        FROM
            items
    ) - COUNT(SI.item) AS diff_cnt
FROM
    shop_items SI
    INNER JOIN items I ON SI.item = I.item
GROUP BY
    SI.shop;

-- got moving averages by correlated-subqueries
SELECT
    prc_date,
    A1.prc_amt,
    (
        SELECT
            AVG(prc_amt)
        FROM
            accounts A2
        WHERE
            A1.prc_date >= A2.prc_date
            AND (
                SELECT
                    COUNT(*)
                FROM
                    accounts A3
                WHERE
                    A3.prc_date BETWEEN A2.prc_date
                    AND A1.prc_date
            ) <= 3
    ) AS mvg_sum
FROM
    accounts A1
ORDER BY
    prc_date;

-- 非グループ化して表示
SELECT
    A1.prc_date AS A1_date,
    A2.prc_date AS A2_date,
    A2.prc_amt AS amt
FROM
    accounts A1,
    accounts A2
WHERE
    A1.prc_date >= A2.prc_date
    AND (
        SELECT
            COUNT(*)
        FROM
            accounts A3
        WHERE
            A3.prc_date BETWEEN A2.prc_date
            AND A1.prc_date
    ) <= 3
ORDER BY
    A1_date,
    A2_date;

-- workout7-②：移動平均　その2
SELECT
    prc_date,
    prc_amt,
    CASE
        WHEN cnt < 3 THEN NULL
        ELSE mvg_avg
    END AS mvg_avg
FROM
    (
        SELECT
            prc_date,
            prc_amt,
            AVG(prc_amt) OVER(
                ORDER BY
                    prc_date ROWS BETWEEN 2 PRECEDING
                    AND CURRENT ROW
            ) mvg_avg,
            COUNT(*) OVER (
                ORDER BY
                    prc_date ROWS BETWEEN 2 PRECEDING
                    AND CURRENT ROW
            ) AS cnt
        FROM
            accounts
    ) tmp;

-- correlated-subqueries
SELECT
    prc_date,
    A1.prc_amt,
    (
        SELECT
            AVG(prc_amt)
        FROM
            accounts A2
        WHERE
            A1.prc_date >= A2.prc_date
            AND (
                SELECT
                    COUNT(*)
                FROM
                    accounts A3
                WHERE
                    A3.prc_date BETWEEN A2.prc_date
                    AND A1.prc_date
            ) <= 3
        HAVING
            COUNT(*) = 3
    ) AS mvg_sum --3 行未満は非表示
FROM
    accounts A1
ORDER BY
    prc_date;

-- workout8-①：結合が先か、集約が先か？
-- インラインビューを1つ削除した修正版
SELECT
    MASTER.age_class AS age_class,
    MASTER.sex_cd AS sex_cd,
    SUM(
        CASE
            WHEN pref_name IN ('Boston', 'New York') THEN population
            ELSE NULL
        END
    ) AS pop_tohoku,
    SUM(
        CASE
            WHEN pref_name IN ('Singapore', 'Beijin') THEN population
            ELSE NULL
        END
    ) AS pop_kanto
FROM
    (
        SELECT
            age_class,
            sex_cd
        FROM
            tbl_age
            CROSS JOIN tbl_sex
    ) MASTER
    LEFT OUTER JOIN tbl_pop DATA ON MASTER.age_class = DATA.age_class
    AND MASTER.sex_cd = DATA.sex_cd
GROUP BY
    MASTER.age_class,
    MASTER.sex_cd;

-- workout8-②：子どもの数にご用心
SELECT
    EMP.employee,
    COUNT(*) AS child_cnt
FROM
    personnel EMP
    LEFT OUTER JOIN children ON children.child IN (EMP.child_1, EMP.child_2, EMP.child_3)
GROUP BY
    EMP.employee;

SELECT
    EMP.employee,
    COUNT(children.child) AS child_cnt
FROM
    personnel EMP
    LEFT OUTER JOIN children ON children.child IN (EMP.child_1, EMP.child_2, EMP.child_3)
GROUP BY
    EMP.employee;

-- workout8-③：完全外部結合とMERGE文
MERGE INTO class_a A USING (
    SELECT
        *
    FROM
        class_b
) B ON (A.id = B.id)
WHEN MATCHED THEN
UPDATE
SET
    A.name = B.name
    WHEN NOT MATCHED THEN
INSERT
    (id, name)
VALUES
    (B.id, B.name);

-- workout9-①：UNIONだけを使うコンペアの改良
SELECT
    CASE
        WHEN COUNT(*) = (
            SELECT
                COUNT(*)
            FROM
                tbl_a
        )
        AND COUNT(*) = (
            SELECT
                COUNT(*)
            FROM
                tbl_b
        ) THEN 'equal'
        ELSE 'different'
    END AS result
FROM
    (
        SELECT
            *
        FROM
            tbl_a
        UNION
        SELECT
            *
        FROM
            tbl_b
    ) tmp;

-- workout9-②：厳密な関係除算
SELECT
    DISTINCT emp
FROM
    emp_skills es1
WHERE
    NOT EXISTS (
        SELECT
            skill
        FROM
            Skills
        EXCEPT
        SELECT
            skill
        FROM
            emp_skills es2
        WHERE
            es1.emp = es2.emp
    )
    AND NOT EXISTS (
        SELECT
            skill
        FROM
            emp_skills ES3
        WHERE
            es1.emp = ES3.emp
        EXCEPT
        SELECT
            skill
        FROM
            Skills
    );

SELECT
    emp
FROM
    emp_skills es1
WHERE
    NOT EXISTS (
        SELECT
            skill
        FROM
            Skills
        EXCEPT
        SELECT
            skill
        FROM
            emp_skills es2
        WHERE
            es1.emp = es2.emp
    )
GROUP BY
    emp
HAVING
    COUNT(*) = (
        SELECT
            COUNT(*)
        FROM
            Skills
    );

-- workout10-①：欠番をすべて求める―― NOT EXISTSと外部結合
SELECT
    seq
FROM
    Sequence N
WHERE
    seq BETWEEN 1
    AND 12
    AND NOT EXISTS (
        SELECT
            *
        FROM
            sequence_table S
        WHERE
            N.seq = S.seq
    );

SELECT
    N.seq
FROM
    Sequence N
    LEFT OUTER JOIN sequence_table S ON N.seq = S.seq
WHERE
    N.seq BETWEEN 1
    AND 12
    AND S.seq IS NULL;

-- workout10-②：シーケンスを求める――集合指向的発想
SELECT
    s1.seat AS start_seat,
    ' ~ ',
    s2.seat AS end_seat
FROM
    Seats s1,
    Seats s2,
    Seats S3
WHERE
    s2.seat = s1.seat + (:head_cnt - 1)
    AND S3.seat BETWEEN s1.seat
    AND s2.seat
GROUP BY
    s1.seat,
    s2.seat
HAVING
    COUNT(*) = SUM(
        CASE
            WHEN S3.status = 'available' THEN 1
            ELSE 0
        END
    );

-- 行に折り返しがある場合
SELECT
    s1.seat AS start_seat,
    ' ~ ',
    s2.seat AS end_seat
FROM
    Seats2 s1,
    Seats2 s2,
    Seats2 S3
WHERE
    s2.seat = s1.seat + (:head_cnt -1)
    AND S3.seat BETWEEN s1.seat
    AND s2.seat
GROUP BY
    s1.seat,
    s2.seat
HAVING
    COUNT(*) = SUM(
        CASE
            WHEN S3.status = 'available'
            AND S3.line_id = s1.line_id THEN 1
            ELSE 0
        END
    );
