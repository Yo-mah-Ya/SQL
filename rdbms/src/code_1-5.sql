/* テーブルに存在「しない」データを探す */
CREATE TABLE meetings (
    meeting CHAR(32) NOT NULL,
    person CHAR(32) NOT NULL,
    PRIMARY KEY (meeting, person)
);

INSERT INTO
    meetings
VALUES
    ('first', 'Cathy'),
    ('first', 'Daniel'),
    ('first', 'Natalie'),
    ('second', 'Cathy'),
    ('second', 'Jack'),
    ('third', 'Natalie'),
    ('third', 'Daniel'),
    ('third', 'Jack');

SELECT
    DISTINCT m1.meeting,
    m2.person
FROM
    meetings m1
    CROSS JOIN meetings m2;

--欠席者だけを求めるクエリ：その1　existential quantifierの応用
SELECT
    DISTINCT m1.meeting,
    m2.person
FROM
    meetings m1
    CROSS JOIN meetings m2
WHERE
    NOT EXISTS (
        SELECT
            *
        FROM
            meetings M3
        WHERE
            m1.meeting = M3.meeting
            AND m2.person = M3.person
    );

--欠席者だけを求めるクエリ：その2　差集合演算の利用
SELECT
    m1.meeting,
    m2.person
FROM
    meetings m1,
    meetings m2
EXCEPT
SELECT
    meeting,
    person
FROM
    meetings;

/* universal quantifier　その１：肯定⇔二重否定の変換に慣れよう */
CREATE TABLE test_scores (
    student_id INTEGER,
    subject VARCHAR(32),
    score INTEGER,
    PRIMARY KEY(student_id, subject)
);

INSERT INTO
    test_scores
VALUES
    (100, 'math', 100),
    (100, 'English', 80),
    (100, 'science', 80),
    (200, 'math', 80),
    (200, 'English', 95),
    (300, 'math', 40),
    (300, 'English', 90),
    (300, 'social studies', 55),
    (400, 'math', 80);

SELECT
    DISTINCT student_id
FROM
    test_scores ts1
WHERE
    NOT EXISTS -- 以下の条件を満たす行が存在しない
    (
        SELECT
            *
        FROM
            test_scores ts2
        WHERE
            ts2.student_id = ts1.student_id
            AND ts2.score < 50
    );

--50 点未満の教科
SELECT
    DISTINCT student_id
FROM
    test_scores ts1
WHERE
    subject IN ('math', 'English')
    AND NOT EXISTS (
        SELECT
            *
        FROM
            test_scores ts2
        WHERE
            ts2.student_id = ts1.student_id
            AND 1 = CASE
                WHEN subject = 'math'
                AND score < 80 THEN 1
                WHEN subject = 'English'
                AND score < 50 THEN 1
                ELSE 0
            END
    );

SELECT
    student_id
FROM
    test_scores ts1
WHERE
    subject IN ('math', 'English')
    AND NOT EXISTS (
        SELECT
            *
        FROM
            test_scores ts2
        WHERE
            ts2.student_id = ts1.student_id
            AND 1 = CASE
                WHEN subject = 'math'
                AND score < 80 THEN 1
                WHEN subject = 'English'
                AND score < 50 THEN 1
                ELSE 0
            END
    )
GROUP BY
    student_id
HAVING
    COUNT(*) = 2;

/* universal quantifier　その２：集合VS 述語――凄いのはどっちだ？ */
CREATE TABLE projects (
    project_id VARCHAR(32),
    step_nbr INTEGER,
    STATUS VARCHAR(32),
    PRIMARY KEY(project_id, step_nbr)
);

INSERT INTO
    projects
VALUES
    ('AA100', 0, 'finished'),
    ('AA100', 1, 'wating'),
    ('AA100', 2, 'wating'),
    ('B200', 0, 'wating'),
    ('B200', 1, 'wating'),
    ('CS300', 0, 'finished'),
    ('CS300', 1, 'finished'),
    ('CS300', 2, 'wating'),
    ('CS300', 3, 'wating'),
    ('DY400', 0, 'finished'),
    ('DY400', 1, 'finished'),
    ('DY400', 2, 'finished');

--工程1番までfinishedのプロジェクトを選択：集合指向的な解答
SELECT
    project_id
FROM
    projects
GROUP BY
    project_id
HAVING
    COUNT(*) = SUM(
        CASE
            WHEN step_nbr <= 1
            AND STATUS = 'finished' THEN 1
            WHEN step_nbr > 1
            AND STATUS = 'wating' THEN 1
            ELSE 0
        END
    );

--工程1番までfinishedのプロジェクトを選択：述語論理的な解答
SELECT
    *
FROM
    projects p1
WHERE
    NOT EXISTS (
        SELECT
            STATUS
        FROM
            projects p2
        WHERE
            p1.project_id = p2.project_id --プロジェクトごとに条件を調べる
            AND STATUS <> CASE
                WHEN step_nbr <= 1 --全称文を二重否定で表現する
                THEN 'finished'
                ELSE 'wating'
            END
    );

/* 列に対する量化：オール１の行を探せ */
CREATE TABLE array_tbl (
    keycol CHAR(1) PRIMARY KEY,
    col1 INTEGER,
    col2 INTEGER,
    col3 INTEGER,
    col4 INTEGER,
    col5 INTEGER,
    col6 INTEGER,
    col7 INTEGER,
    col8 INTEGER,
    col9 INTEGER,
    col10 INTEGER
);

--オールNULL
INSERT INTO
    array_tbl
VALUES
    (
        'A',
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL
    ),
    (
        'B',
        3,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL
    ),
    --オール1
    ('C', 1, 1, 1, 1, 1, 1, 1, 1, 1, 1),
    --少なくとも一つは9
    (
        'D',
        NULL,
        NULL,
        9,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL,
        NULL
    ),
    (
        'E',
        NULL,
        3,
        NULL,
        1,
        9,
        NULL,
        NULL,
        9,
        NULL,
        NULL
    );

--列方向へのuniversal quantifier：芸のある答え
SELECT
    *
FROM
    array_tbl
WHERE
    1 = ALL (
        col1,
        col2,
        col3,
        col4,
        col5,
        col6,
        col7,
        col8,
        col9,
        col10
    );

SELECT
    *
FROM
    array_tbl
WHERE
    9 = ANY (
        col1,
        col2,
        col3,
        col4,
        col5,
        col6,
        col7,
        col8,
        col9,
        col10
    );

SELECT
    *
FROM
    array_tbl
WHERE
    9 IN (
        col1,
        col2,
        col3,
        col4,
        col5,
        col6,
        col7,
        col8,
        col9,
        col10
    );

--オールNULLの行を探す：間違った答え
SELECT
    *
FROM
    array_tbl
WHERE
    NULL = ALL (
        col1,
        col2,
        col3,
        col4,
        col5,
        col6,
        col7,
        col8,
        col9,
        col10
    );

--オールNULLの行を探す：正しい答え
SELECT
    *
FROM
    array_tbl
WHERE
    COALESCE(
        col1,
        col2,
        col3,
        col4,
        col5,
        col6,
        col7,
        col8,
        col9,
        col10
    ) IS NULL;

-- workout
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
