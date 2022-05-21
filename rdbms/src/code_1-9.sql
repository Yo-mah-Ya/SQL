/* テーブル同士のコンペア　集合の相等性チェック */
CREATE TABLE tbl_a (
    keycol CHAR(1) PRIMARY KEY,
    col_1 INTEGER,
    col_2 INTEGER,
    col_3 INTEGER
);

CREATE TABLE tbl_b (
    keycol CHAR(1) PRIMARY KEY,
    col_1 INTEGER,
    col_2 INTEGER,
    col_3 INTEGER
);

/* 等しいテーブル同士のケース */
INSERT INTO
    tbl_a
VALUES
    ('A', 2, 3, 4),
    ('B', 0, 7, 9),
    ('C', 5, 1, 6);

INSERT INTO
    tbl_b
VALUES
    ('A', 2, 3, 4),
    ('B', 0, 7, 9),
    ('C', 5, 1, 6);

/* 「B」の行が相違するケース */
DELETE FROM
    tbl_a;

INSERT INTO
    tbl_a
VALUES
    ('A', 2, 3, 4),
    ('B', 0, 7, 9),
    ('C', 5, 1, 6);

DELETE FROM
    tbl_b;

INSERT INTO
    tbl_b
VALUES
    ('A', 2, 3, 4),
    ('B', 0, 7, 8),
    ('C', 5, 1, 6);

/* NULLを含むケース（等しい） */
DELETE FROM
    tbl_a;

INSERT INTO
    tbl_a
VALUES
    ('A', NULL, 3, 4),
    ('B', 0, 7, 9),
    ('C', NULL, NULL, NULL);

DELETE FROM
    tbl_b;

INSERT INTO
    tbl_b
VALUES
    ('A', NULL, 3, 4),
    ('B', 0, 7, 9),
    ('C', NULL, NULL, NULL);

/* NULLを含むケース（「C」の行が異なる） */
DELETE FROM
    tbl_a;

INSERT INTO
    tbl_a
VALUES
    ('A', NULL, 3, 4),
    ('B', 0, 7, 9),
    ('C', NULL, NULL, NULL);

DELETE FROM
    tbl_b;

INSERT INTO
    tbl_b
VALUES
    ('A', NULL, 3, 4),
    ('B', 0, 7, 9),
    ('C', 0, NULL, NULL);

/* 3. 差集合で関係除算を表現する */
CREATE TABLE Skills (skill VARCHAR(32), PRIMARY KEY(skill));

CREATE TABLE emp_skills (
    emp VARCHAR(32),
    skill VARCHAR(32),
    PRIMARY KEY(emp, skill)
);

INSERT INTO
    Skills
VALUES
    ('Oracle'),
    ('UNIX'),
    ('Java');

INSERT INTO
    emp_skills
VALUES
    ('Watt', 'Oracle'),
    ('Watt', 'UNIX'),
    ('Watt', 'Java'),
    ('Watt', 'C#'),
    ('Cotton', 'Oracle'),
    ('Cotton', 'UNIX'),
    ('Cotton', 'Java'),
    ('John', 'UNIX'),
    ('John', 'Oracle'),
    ('John', 'PHP'),
    ('John', 'Perl'),
    ('John', 'C++'),
    ('Michael', 'Perl'),
    ('Emma', 'Oracle');

/* 4. 等しい部分集合を見つける */
CREATE TABLE sup_parts (
    sup CHAR(32) NOT NULL,
    part CHAR(32) NOT NULL,
    PRIMARY KEY(sup, part)
);

INSERT INTO
    sup_parts
VALUES
    ('A', 'bolt'),
    ('A', 'nut'),
    ('A', 'pipe'),
    ('B', 'bolt'),
    ('B', 'pipe'),
    ('C', 'bolt'),
    ('C', 'nut'),
    ('C', 'pipe'),
    ('D', 'bolt'),
    ('D', 'pipe'),
    ('E', 'fuse'),
    ('E', 'nut'),
    ('E', 'pipe'),
    ('F', 'fuse');

/* 5. 重複行を削除する高速なクエリ
 PostgreSQLでは「with oids」をCREATE TABLE文の最後に追加すること */
CREATE TABLE products (name CHAR(16), price INTEGER);

INSERT INTO
    products
VALUES
    ('apple', 50),
    ('orange', 100),
    ('orange', 100),
    ('orange', 100),
    ('banana', 80);

/* テーブル同士のコンペア：基本編*/
SELECT
    COUNT(*) AS row_cnt
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

/* テーブル同士のコンペア：応用編（Oracleでは通らない） */
SELECT
    CASE
        WHEN COUNT(*) = 0 THEN 'equal'
        ELSE 'different'
    END AS result
FROM
    (
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
        )
        EXCEPT
            (
                SELECT
                    *
                FROM
                    tbl_a
                INTERSECT
                SELECT
                    *
                FROM
                    tbl_b
            )
    ) tmp;

/* テーブルに対するdiff：排他的和集合を求める */
(
    SELECT
        *
    FROM
        tbl_a
    EXCEPT
    SELECT
        *
    FROM
        tbl_b
)
UNION
ALL (
    SELECT
        *
    FROM
        tbl_b
    EXCEPT
    SELECT
        *
    FROM
        tbl_a
);

/* 差集合で関係除算（剰余を持った除算） */
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
    );

/* 等しい部分集合を見つける(p.134) */
SELECT
    SP1.sup,
    SP2.sup
FROM
    sup_parts SP1,
    sup_parts SP2
WHERE
    SP1.sup < SP2.sup
    /* 業者の組み合わせを作る */
    AND SP1.part = SP2.part
    /* 条件１．同じ種類の部品を扱う */
GROUP BY
    SP1.sup,
    SP2.sup
HAVING
    COUNT(*) = (
        SELECT
            COUNT(*)
            /* 条件２．同数の部品を扱う */
        FROM
            sup_parts SP3
        WHERE
            SP3.sup = SP1.sup
    )
    AND COUNT(*) = (
        SELECT
            COUNT(*)
        FROM
            sup_parts SP4
        WHERE
            SP4.sup = SP2.sup
    );

/* 重複行を削除する高速なクエリ１：補集合をEXCEPTで求める */
DELETE FROM
    products
WHERE
    rowid IN (
        SELECT
            rowid
        FROM
            products
        EXCEPT
        SELECT
            MAX(rowid)
        FROM
            products
        GROUP BY
            name,
            price
    );

/* 重複行を削除する高速なクエリ２：補集合をNOT IN で求める */
DELETE FROM
    products
WHERE
    rowid NOT IN (
        SELECT
            MAX(rowid)
        FROM
            products
        GROUP BY
            name,
            price
    );
