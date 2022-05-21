/* 外部結合で行列変換　その1（行→列）：クロス表を作る */
CREATE TABLE Courses (
    name VARCHAR(32),
    course VARCHAR(32),
    PRIMARY KEY(name, course)
);

INSERT INTO
    Courses
VALUES
    ('赤井', 'SQL'),
    ('赤井', 'UNIX'),
    ('鈴木', 'SQL'),
    ('工藤', 'SQL'),
    ('工藤', 'Java'),
    ('吉田', 'UNIX'),
    ('渡辺', 'SQL');

-- クロス表を求める水平展開：その1　外部結合の利用
SELECT
    C0.name,
    CASE
        WHEN C1.name IS NOT NULL THEN '○'
        ELSE NULL
    END AS "SQL",
    CASE
        WHEN C2.name IS NOT NULL THEN '○'
        ELSE NULL
    END AS "UNIX",
    CASE
        WHEN C3.name IS NOT NULL THEN '○'
        ELSE NULL
    END AS "Java"
FROM
    (
        SELECT
            DISTINCT name
        FROM
            Courses
    ) C0 --このC0が表側になる
    LEFT OUTER JOIN (
        SELECT
            name
        FROM
            Courses
        WHERE
            course = 'SQL'
    ) C1 ON C0.name = C1.name
    LEFT OUTER JOIN (
        SELECT
            name
        FROM
            Courses
        WHERE
            course = 'UNIX'
    ) C2 ON C0.name = C2.name
    LEFT OUTER JOIN (
        SELECT
            name
        FROM
            Courses
        WHERE
            course = 'Java'
    ) C3 ON C0.name = C3.name;

-- 水平展開：その2　スカラサブクエリの利用
SELECT
    C0.name,
    (
        SELECT
            '○'
        FROM
            Courses C1
        WHERE
            course = 'SQL'
            AND C1.name = C0.name
    ) AS "SQL",
    (
        SELECT
            '○'
        FROM
            Courses C2
        WHERE
            course = 'UNIX'
            AND C2.name = C0.name
    ) AS "UNIX",
    (
        SELECT
            '○'
        FROM
            Courses C3
        WHERE
            course = 'Java'
            AND C3.name = C0.name
    ) AS "Java"
FROM
    (
        SELECT
            DISTINCT name
        FROM
            Courses
    ) C0;

--このC0が表側になる
-- 水平展開：その3　CASE式を入れ子にする
SELECT
    name,
    CASE
        WHEN SUM(
            CASE
                WHEN course = 'SQL' THEN 1
                ELSE NULL
            END
        ) = 1 THEN '○'
        ELSE NULL
    END AS "SQL",
    CASE
        WHEN SUM(
            CASE
                WHEN course = 'UNIX' THEN 1
                ELSE NULL
            END
        ) = 1 THEN '○'
        ELSE NULL
    END AS "UNIX",
    CASE
        WHEN SUM(
            CASE
                WHEN course = 'Java' THEN 1
                ELSE NULL
            END
        ) = 1 THEN '○'
        ELSE NULL
    END AS "Java"
FROM
    Courses
GROUP BY
    name;

/* 外部結合で行列変換　その2（列→行）：繰り返し項目を1 列にまとめる */
CREATE TABLE personnel (
    employee VARCHAR(32),
    child_1 VARCHAR(32),
    child_2 VARCHAR(32),
    child_3 VARCHAR(32),
    PRIMARY KEY(employee)
);

INSERT INTO
    personnel
VALUES
    ('赤井', '一郎', '二郎', '三郎'),
    ('工藤', '春子', '夏子', NULL),
    ('鈴木', '夏子', NULL, NULL),
    ('吉田', NULL, NULL, NULL);

-- 列から行への変換：UNION ALLの利用
SELECT
    employee,
    child_1 AS child
FROM
    personnel
UNION
ALL
SELECT
    employee,
    child_2 AS child
FROM
    personnel
UNION
ALL
SELECT
    employee,
    child_3 AS child
FROM
    personnel;

CREATE VIEW children(child) AS
SELECT
    child_1
FROM
    personnel
UNION
SELECT
    child_2
FROM
    personnel
UNION
SELECT
    child_3
FROM
    personnel;

-- 社員の子どもリストを得るSQL（子どものいない社員も出力する）
SELECT
    EMP.employee,
    children.child
FROM
    personnel EMP
    LEFT OUTER JOIN children ON children.child IN (EMP.child_1, EMP.child_2, EMP.child_3);

/* クロス表で入れ子の表側を作る */
CREATE TABLE tbl_sex (
    sex_cd CHAR(1),
    sex VARCHAR(5),
    PRIMARY KEY(sex_cd)
);

CREATE TABLE tbl_age (
    age_class CHAR(1),
    age_range VARCHAR(30),
    PRIMARY KEY(age_class)
);

CREATE TABLE tbl_pop (
    pref_name VARCHAR(30),
    age_class CHAR(1),
    sex_cd CHAR(1),
    population integer,
    PRIMARY KEY(pref_name, age_class, sex_cd)
);

INSERT INTO
    tbl_sex (sex_cd, sex)
VALUES
    ('m', '男'),
    ('f', '女');

INSERT INTO
    tbl_age (age_class, age_range)
VALUES
    ('1', '21~30'),
    ('2', '31~40'),
    ('3', '41~50');

INSERT INTO
    tbl_pop
VALUES
    ('New York', '1', 'm', 400),
    ('New York', '3', 'm', 1000),
    ('New York', '1', 'f', 800),
    ('New York', '3', 'f', 1000),
    ('Boston', '1', 'm', 700),
    ('Boston', '1', 'f', 500),
    ('Boston', '3', 'f', 800),
    ('Singapore', '1', 'm', 900),
    ('Singapore', '1', 'f', 1500),
    ('Singapore', '3', 'f', 1200),
    ('Beijin', '1', 'm', 900),
    ('Beijin', '1', 'f', 1000),
    ('Beijin', '3', 'f', 900);

-- 外部結合で入れ子の表側を作る：間違ったSQL
SELECT
    master1.age_class AS age_class,
    master2.sex_cd AS sex_cd,
    DATA.pop_tohoku AS pop_tohoku,
    DATA.pop_kanto AS pop_kanto
FROM
    (
        SELECT
            age_class,
            sex_cd,
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
            tbl_pop
        GROUP BY
            age_class,
            sex_cd
    ) DATA
    RIGHT OUTER JOIN tbl_age master1 --外部結合1：年齢階級マスタと結合
    ON master1.age_class = DATA.age_class
    RIGHT OUTER JOIN tbl_sex master2 --外部結合2：性別マスタと結合
    ON master2.sex_cd = DATA.sex_cd;

-- 最初の外部結合で止めた場合：年齢階級「2」も結果に現われる
SELECT
    master1.age_class AS age_class,
    DATA.sex_cd AS sex_cd,
    DATA.pop_tohoku AS pop_tohoku,
    DATA.pop_kanto AS pop_kanto
FROM
    (
        SELECT
            age_class,
            sex_cd,
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
            tbl_pop
        GROUP BY
            age_class,
            sex_cd
    ) DATA
    RIGHT OUTER JOIN tbl_age master1 ON master1.age_class = DATA.age_class;

-- 外部結合で入れ子の表側を作る：正しいSQL
SELECT
    MASTER.age_class AS age_class,
    MASTER.sex_cd AS sex_cd,
    DATA.pop_tohoku AS pop_tohoku,
    DATA.pop_kanto AS pop_kanto
FROM
    (
        SELECT
            age_class,
            sex_cd
        FROM
            tbl_age
            CROSS JOIN tbl_sex
    ) MASTER --クロス結合でマスタ同士の直積を作る
    LEFT OUTER JOIN (
        SELECT
            age_class,
            sex_cd,
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
            tbl_pop
        GROUP BY
            age_class,
            sex_cd
    ) DATA ON MASTER.age_class = DATA.age_class
    AND MASTER.sex_cd = DATA.sex_cd;

/* 掛け算としての結合 */
CREATE TABLE items (
    item_no INTEGER PRIMARY KEY,
    item VARCHAR(32) NOT NULL
);

INSERT INTO
    items
VALUES
    (10, 'FD'),
    (20, 'CD-R'),
    (30, 'MO'),
    (40, 'DVD');

CREATE TABLE sales_history (
    sale_date DATE NOT NULL,
    item_no INTEGER NOT NULL,
    quantity INTEGER NOT NULL,
    PRIMARY KEY(sale_date, item_no)
);

INSERT INTO
    sales_history
VALUES
    ('2018-10-01', 10, 4),
    ('2018-10-01', 20, 10),
    ('2018-10-01', 30, 3),
    ('2018-10-03', 10, 32),
    ('2018-10-03', 30, 12),
    ('2018-10-04', 20, 22),
    ('2018-10-04', 30, 7);

-- 答え：その1　結合の前に集約することで、1対1の関係を作る
SELECT
    I.item_no,
    SH.total_qty
FROM
    items I
    LEFT OUTER JOIN (
        SELECT
            item_no,
            SUM(quantity) AS total_qty
        FROM
            sales_history
        GROUP BY
            item_no
    ) SH ON I.item_no = SH.item_no;

-- 答え：その2　集約の前に1対多の結合を行なう
SELECT
    I.item_no,
    SUM(SH.quantity) AS total_qty
FROM
    items I
    LEFT OUTER JOIN sales_history SH ON I.item_no = SH.item_no --1対多の結合
GROUP BY
    I.item_no;

/* 完全外部結合 */
CREATE TABLE class_a (id CHAR(1), name VARCHAR(30), PRIMARY KEY(id));

CREATE TABLE class_b (
    id CHAR(1),
    name VARCHAR(30),
    PRIMARY KEY(id)
);

INSERT INTO
    class_a (id, name)
VALUES
    ('1', '田中'),
    ('2', '鈴木'),
    ('3', '伊集院');

INSERT INTO
    class_b (id, name)
VALUES
    ('1', '田中'),
    ('2', '鈴木'),
    ('4', '西園寺');

-- 完全外部結合は情報を「完全」に保存する
SELECT
    COALESCE(A.id, B.id) AS id,
    A.name AS A_name,
    B.name AS B_name
FROM
    class_a A FULL
    OUTER JOIN class_b B ON A.id = B.id;

-- 完全外部結合が使えない環境での代替方法
SELECT
    A.id AS id,
    A.name,
    B.name
FROM
    class_a A
    LEFT OUTER JOIN class_b B ON A.id = B.id
UNION
SELECT
    B.id AS id,
    A.name,
    B.name
FROM
    class_a A
    RIGHT OUTER JOIN class_b B ON A.id = B.id;

SELECT
    A.id AS id,
    A.name AS A_name
FROM
    class_a A
    LEFT OUTER JOIN class_b B ON A.id = B.id
WHERE
    B.name IS NULL;

SELECT
    B.id AS id,
    B.name AS B_name
FROM
    class_a A
    RIGHT OUTER JOIN class_b B ON A.id = B.id
WHERE
    A.name IS NULL;

SELECT
    COALESCE(A.id, B.id) AS id,
    COALESCE(A.name, B.name) AS name
FROM
    class_a A FULL
    OUTER JOIN class_b B ON A.id = B.id
WHERE
    A.name IS NULL
    OR B.name IS NULL;

-- 外部結合で関係除算：差集合の応用
SELECT
    DISTINCT shop
FROM
    shop_items si1
WHERE
    NOT EXISTS (
        SELECT
            I.item
        FROM
            items I
            LEFT OUTER JOIN shop_items si2 ON I.item = si2.item
            AND si1.shop = si2.shop
        WHERE
            si2.item IS NULL
    );
