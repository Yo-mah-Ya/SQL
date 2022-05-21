/* データの歯抜けを探す */
CREATE TABLE sequence_table (
    seq INTEGER PRIMARY KEY,
    name VARCHAR(16) NOT NULL
);

INSERT INTO
    sequence_table
VALUES
    (1, 'ディック'),
    (2, 'アン'),
    (3, 'ライル'),
    (5, 'カー'),
    (6, 'マリー'),
    (8, 'ベン');

-- 結果が返れば歯抜けあり
SELECT
    '歯抜けあり ' AS gap
FROM
    sequence_table
HAVING
    COUNT(*) <> MAX(seq);

-- 空のGROUP BY句
SELECT
    '歯抜けあり ' AS gap
FROM
    sequence_table
GROUP BY
    ()
HAVING
    COUNT(*) <> MAX(seq);

-- 歯抜けの最小値を探す
SELECT
    MIN(seq + 1) AS gap
FROM
    sequence_table
WHERE
    (seq + 1) NOT IN (
        SELECT
            seq
        FROM
            sequence_table
    );

-- 欠番を探せ：発展版
CREATE TABLE sequence_table (seq INTEGER NOT NULL PRIMARY KEY);

-- 歯抜けなし：開始値が1
DELETE FROM
    sequence_table;

INSERT INTO
    sequence_table
VALUES
    (1),
    (2),
    (3),
    (4),
    (5);

-- 歯抜けあり：開始値が1
DELETE FROM
    sequence_table;

INSERT INTO
    sequence_table
VALUES
    (1),
    (2),
    (4),
    (5),
    (8);

-- 歯抜けなし：開始値が1ではない
DELETE FROM
    sequence_table;

INSERT INTO
    sequence_table
VALUES
    (3),
    (4),
    (5),
    (6),
    (7);

-- 歯抜けあり：開始値が1ではない
DELETE FROM
    sequence_table;

INSERT INTO
    sequence_table
VALUES
    (3),
    (4),
    (7),
    (8),
    (10);

SELECT
    '歯抜けあり ' AS gap
FROM
    sequence_table
HAVING
    COUNT(*) <> MAX(seq) - MIN(seq) + 1;

-- 欠番があってもなくても一行返す
SELECT
    CASE
        WHEN COUNT(*) = 0 THEN 'テーブルが空です '
        WHEN COUNT(*) <> MAX(seq) - MIN(seq) + 1 THEN '歯抜けあり '
        ELSE '連続 '
    END AS gap
FROM
    sequence_table;

-- 歯抜けの最小値を探す：テーブルに 1がない場合は、 1を返す
SELECT
    CASE
        WHEN COUNT(*) = 0
        OR MIN(seq) > 1 -- 下限が 1でない場合 → 1を返す
        THEN 1
        ELSE (
            SELECT
                MIN(seq + 1) -- 下限が 1の場合 →最小の欠番を返す
            FROM
                sequence_table s1
            WHERE
                NOT EXISTS (
                    SELECT
                        *
                    FROM
                        sequence_table s2
                    WHERE
                        s2.seq = s1.seq + 1
                )
        )
    END
FROM
    sequence_table;

CREATE TABLE Graduates (
    name VARCHAR(16) PRIMARY KEY,
    income INTEGER NOT NULL
);

INSERT INTO
    Graduates
VALUES
    ('Sampson', 400000),
    ('Mike', 30000),
    ('White', 20000),
    ('Arnold', 20000),
    ('Smith', 20000),
    ('Lawrence', 15000),
    ('Hadson', 15000),
    ('Kent', 10000),
    ('Becker', 10000),
    ('Scott', 10000);

-- 最頻値を求める SQL　その 1：ALL述語の利用
SELECT
    income,
    COUNT(*) AS cnt
FROM
    Graduates
GROUP BY
    income
HAVING
    COUNT(*) >= ALL (
        SELECT
            COUNT(*)
        FROM
            Graduates
        GROUP BY
            income
    );

-- 最頻値を求める SQL　その 2：極値関数の利用
SELECT
    income,
    COUNT(*) AS cnt
FROM
    Graduates
GROUP BY
    income
HAVING
    COUNT(*) >= (
        SELECT
            MAX(cnt)
        FROM
            (
                SELECT
                    COUNT(*) AS cnt
                FROM
                    Graduates
                GROUP BY
                    income
            ) tmp
    );

CREATE TABLE null_tbl (col_1 INTEGER);

INSERT INTO
    null_tbl
VALUES
    (NULL),
    (NULL),
    (NULL);

SELECT
    COUNT(*),
    COUNT(col_1)
FROM
    null_tbl;

/* NULL を含まない集合を探す */
CREATE TABLE students (
    student_id INTEGER PRIMARY KEY,
    dpt VARCHAR(16) NOT NULL,
    sbmt_date DATE
);

INSERT INTO
    students
VALUES
    (100, '理学部', '2018-10-10'),
    (101, '理学部', '2018-09-22'),
    (102, '文学部', NULL),
    (103, '文学部', '2018-09-10'),
    (200, '文学部', '2018-09-22'),
    (201, '工学部', NULL),
    (202, '経済学部', '2018-09-25');

-- 提出日に NULLを含まない学部を選択する　その１： COUNT関数の利用
SELECT
    dpt
FROM
    students
GROUP BY
    dpt
HAVING
    COUNT(*) = COUNT(sbmt_date);

-- 提出日に NULLを含まない学部を選択する　その２： CASE式の利用
SELECT
    dpt
FROM
    students
GROUP BY
    dpt
HAVING
    COUNT(*) = SUM(
        CASE
            WHEN sbmt_date IS NOT NULL THEN 1
            ELSE 0
        END
    );

-- 集合にきめ細かな条件を設定する
CREATE TABLE test_results (
    student_id CHAR(12) NOT NULL PRIMARY KEY,
    class CHAR(1) NOT NULL,
    sex CHAR(1) NOT NULL,
    score INTEGER NOT NULL
);

INSERT INTO
    test_results
VALUES
    ('001', 'A', '男', 100),
    ('002', 'A', '女', 100),
    ('003', 'A', '女', 49),
    ('004', 'A', '男', 30),
    ('005', 'B', '女', 100),
    ('006', 'B', '男', 92),
    ('007', 'B', '男', 80),
    ('008', 'B', '男', 80),
    ('009', 'B', '女', 10),
    ('010', 'C', '男', 92),
    ('011', 'C', '男', 80),
    ('012', 'C', '女', 21),
    ('013', 'D', '女', 100),
    ('014', 'D', '女', 0),
    ('015', 'D', '女', 0);

SELECT
    class
FROM
    test_results
GROUP BY
    class
HAVING
    COUNT(*) * 0.75 <= SUM(
        CASE
            WHEN score >= 80 THEN 1
            ELSE 0
        END
    );

SELECT
    class
FROM
    test_results
GROUP BY
    class
HAVING
    SUM(
        CASE
            WHEN score >= 50
            AND sex = '男' THEN 1
            ELSE 0
        END
    ) > SUM(
        CASE
            WHEN score >= 50
            AND sex = '女' THEN 1
            ELSE 0
        END
    );

-- 男子と女子の平均点を比較するクエリその 1：空集合に対する平均を0で返す
SELECT
    class
FROM
    test_results
GROUP BY
    class
HAVING
    AVG(
        CASE
            WHEN sex = '男' THEN score
            ELSE 0
        END
    ) < AVG(
        CASE
            WHEN sex = '女' THEN score
            ELSE 0
        END
    );

-- 男子と女子の平均点を比較するクエリその 2：空集合に対する平均を NULLで返す
SELECT
    class
FROM
    test_results
GROUP BY
    class
HAVING
    AVG(
        CASE
            WHEN sex = '男' THEN score
            ELSE NULL
        END
    ) < AVG(
        CASE
            WHEN sex = '女' THEN score
            ELSE NULL
        END
    );

CREATE TABLE teams (
    member CHAR(12) NOT NULL PRIMARY KEY,
    team_id INTEGER NOT NULL,
    STATUS CHAR(8) NOT NULL
);

INSERT INTO
    teams
VALUES
    ('ジョー', 1, 'wating'),
    ('ケン', 1, '出動中'),
    ('ミック', 1, 'wating'),
    ('カレン', 2, '出動中'),
    ('キース', 2, '休暇'),
    ('ジャン', 3, 'wating'),
    ('ハート', 3, 'wating'),
    ('ディック', 3, 'wating'),
    ('ベス', 4, 'wating'),
    ('アレン', 5, '出動中'),
    ('ロバート', 5, '休暇'),
    ('ケーガン', 5, 'wating');

-- 全称文を述語で表現する
SELECT
    team_id,
    member
FROM
    teams T1
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            teams T2
        WHERE
            T1.team_id = T2.team_id
            AND STATUS <> 'wating '
    );

/* 全称文を集合で表現する：その1 */
SELECT
    team_id
FROM
    teams
GROUP BY
    team_id
HAVING
    COUNT(*) = SUM(
        CASE
            WHEN STATUS = 'wating' THEN 1
            ELSE 0
        END
    );

-- 全称文を集合で表現する：その 2
SELECT
    team_id
FROM
    teams
GROUP BY
    team_id
HAVING
    MAX(STATUS) = 'wating '
    AND MIN(STATUS) = 'wating ';

-- 総員スタンバイかどうかをチームごとに一覧表示
SELECT
    team_id,
    CASE
        WHEN MAX(STATUS) = 'wating '
        AND MIN(STATUS) = 'wating ' THEN '総員スタンバイ '
        ELSE '隊長！メンバーが足りません '
    END AS STATUS
FROM
    teams
GROUP BY
    team_id;

-- 一意集合と多重集合
CREATE TABLE materials (
    center CHAR(12) NOT NULL,
    receive_date DATE NOT NULL,
    material CHAR(12) NOT NULL,
    PRIMARY KEY(center, receive_date)
);

INSERT INTO
    materials
VALUES
    ('Singapore', '2018-4-01', '錫'),
    ('Singapore', '2018-4-12', '亜鉛'),
    ('Singapore', '2018-5-17', 'アルミニウム'),
    ('Singapore', '2018-5-20', '亜鉛'),
    ('大阪', '2018-4-20', '銅'),
    ('大阪', '2018-4-22', 'ニッケル'),
    ('大阪', '2018-4-29', '鉛'),
    ('名古屋', '2018-3-15', 'チタン'),
    ('名古屋', '2018-4-01', '炭素鋼'),
    ('名古屋', '2018-4-24', '炭素鋼'),
    ('名古屋', '2018-5-02', 'マグネシウム'),
    ('名古屋', '2018-5-10', 'チタン'),
    ('福岡', '2018-5-10', '亜鉛'),
    ('福岡', '2018-5-28', '錫');

-- 資材のダブっている拠点を選択する
SELECT
    center
FROM
    materials
GROUP BY
    center
HAVING
    COUNT(material) <> COUNT(DISTINCT material);

SELECT
    center,
    CASE
        WHEN COUNT(material) <> COUNT(DISTINCT material) THEN 'ダブり有り'
        ELSE 'ダブり無し'
    END AS STATUS
FROM
    materials
GROUP BY
    center;

-- ダブりのある集合：EXISTSの利用
SELECT
    center,
    material
FROM
    materials M1
WHERE
    EXISTS (
        SELECT
            *
        FROM
            materials M2
        WHERE
            M1.center = M2.center
            AND M1.receive_date <> M2.receive_date
            AND M1.material = M2.material
    );

/* 関係除算でバスケット解析 */
CREATE TABLE items (item VARCHAR(16) PRIMARY KEY);

CREATE TABLE shop_items (
    shop VARCHAR(16),
    item VARCHAR(16),
    PRIMARY KEY(shop, item)
);

INSERT INTO
    items
VALUES
    ('ビール'),
    ('紙オムツ'),
    ('自転車');

INSERT INTO
    shop_items
VALUES
    ('仙台', 'ビール'),
    ('仙台', '紙オムツ'),
    ('仙台', '自転車'),
    ('仙台', 'カーテン'),
    ('Singapore', 'ビール'),
    ('Singapore', '紙オムツ'),
    ('Singapore', '自転車'),
    ('大阪', 'テレビ'),
    ('大阪', '紙オムツ'),
    ('大阪', '自転車');

-- ビールと紙オムツと自転車をすべて置いている店舗を検索する：間違った SQL
SELECT
    DISTINCT shop
FROM
    shop_items
WHERE
    item IN (
        SELECT
            item
        FROM
            items
    );

-- ビールと紙オムツと自転車をすべて置いている店舗を検索する：正しい SQL
SELECT
    SI.shop
FROM
    shop_items SI
    INNER JOIN items I ON SI.item = I.item
GROUP BY
    SI.shop
HAVING
    COUNT(SI.item) = (
        SELECT
            COUNT(item)
        FROM
            items
    );

-- COUNT(I.item)はもはや 3とは限らない
SELECT
    SI.shop,
    COUNT(SI.item),
    COUNT(I.item)
FROM
    shop_items SI
    INNER JOIN items I ON SI.item = I.item
GROUP BY
    SI.shop;

-- 厳密な関係除算：外部結合と COUNT関数の利用
SELECT
    SI.shop
FROM
    shop_items SI
    LEFT OUTER JOIN items I ON SI.item = I.item
GROUP BY
    SI.shop
HAVING
    COUNT(SI.item) = (
        SELECT
            COUNT(item)
        FROM
            items
    ) -- 条件 1
    AND COUNT(I.item) = (
        SELECT
            COUNT(item)
        FROM
            items
    );

-- 条件 2
