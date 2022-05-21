/*
 "DISTINCT" is supposed to be applied after the window functions are applied.
 ERROR:  DISTINCT is not implemented for window functions
 */
WITH count_sample(Val) AS(
    VALUES
        (10),
        (20),
        (20),
        (30),
        (30)
)
SELECT
    Val,
    COUNT(*) OVER () AS recordCount
FROM
    (
        SELECT
            DISTINCT Val
        FROM
            count_sample
    ) AS c
ORDER BY
    Val;

-- DISTINCT ROW
WITH tmp(ID, Val1, Val2) AS(
    VALUES
        ('AA', 1, 1),
        ('AA', 1, 1),
        ('AA', 2, 2),
        ('BB', 1, 2),
        ('BB', 2, 1),
        ('BB', 2, 1),
        ('BB', 3, 1)
)
SELECT
    ID,
    COUNT(DISTINCT ROW(Val1, Val2)) AS disCnt
FROM
    tmp
GROUP BY
    ID;

/*
 id | discnt
 ----+--------
 AA |      2
 BB |      3
 */
WITH tmp(ID, Val1, Val2) AS(
    VALUES
        ('AA', 1, 1),
        ('AA', 1, 1),
        ('AA', 2, 2),
        ('BB', 1, 2),
        ('BB', 2, 1),
        ('BB', 2, 1),
        ('BB', 3, 1)
)
SELECT
    t.ID,
    COUNT(*) OVER (PARTITION BY ID) AS disCnt
FROM
    (
        SELECT
            DISTINCT ROW(Val1, Val2) AS v,
            ID
        FROM
            tmp
    ) AS t;

/*
 id | discnt
 ----+--------
 AA |      2
 AA |      2
 BB |      3
 BB |      3
 BB |      3
 */
WITH cnt_dis_sample(ID, Val) AS(
    VALUES
        (111, 1),
        (111, 1),
        (111, 2),
        (222, 4),
        (222, 5),
        (222, 6),
        (333, 7),
        (333, 7)
)
SELECT
    ID,
    Val,
    COUNT(Val) OVER (PARTITION BY ID, Val) AS disCnt
FROM
    cnt_dis_sample;

/*
 id  | val | discnt
 -----+-----+--------
 111 |   1 |      2
 111 |   1 |      2
 111 |   2 |      1
 222 |   4 |      1
 222 |   5 |      1
 222 |   6 |      1
 333 |   7 |      2
 333 |   7 |      2
 */
WITH bool_sample(ID, Val) AS(
    VALUES
        (111, 3),
        (111, 3),
        (111, 3),
        (222, 3),
        (222, 1),
        (333, 0),
        (333, 4)
),
tmp AS (
    SELECT
        ID,
        Val,
        -- universal affirmative
        MIN(
            CASE
                WHEN Val = 3 THEN 1
                ELSE 0
            END
        ) OVER (PARTITION BY ID) AS chk1,
        -- universal negative
        MIN(
            CASE
                WHEN Val = 3 THEN 0
                ELSE 1
            END
        ) OVER (PARTITION BY ID) AS chk2,
        -- particular affirmative
        MAX(
            CASE
                WHEN Val = 3 THEN 1
                ELSE 0
            END
        ) OVER (PARTITION BY ID) AS chk3,
        -- particular negative
        MAX(
            CASE
                WHEN Val = 3 THEN 0
                ELSE 1
            END
        ) OVER (PARTITION BY ID) AS chk4
    FROM
        bool_sample
    ORDER BY
        D,
        Val
)
SELECT
    ID,
    CASE
        WHEN MAX(chk1) = 1 THEN 'meets condition'
        ELSE 'does not meet condition'
    END AS chk1,
    CASE
        WHEN MAX(chk2) = 1 THEN 'meets condition'
        ELSE 'does not meet condition'
    END AS chk2,
    CASE
        WHEN MAX(chk3) = 1 THEN 'meets condition'
        ELSE 'does not meet condition'
    END AS chk3,
    CASE
        WHEN MAX(chk4) = 1 THEN 'meets condition'
        ELSE 'does not meet condition'
    END AS chk4
FROM
    tmp
GROUP BY
    ID
ORDER BY
    D ASC NULLS LAST;

-- GROUP BY + CASE WHEN
WITH evaluate (name, year, season, score) AS(
    VALUES
        ('Nick', 2018, '1Q', 100),
        ('Nick', 2018, '1Q', 99),
        ('Nick', 2018, '1Q', 98),
        ('Nick', 2018, '1Q', 97),
        ('Nick', 2018, '2Q', 96),
        ('Nick', 2018, '2Q', 95),
        ('Nick', 2018, '2Q', 94),
        ('Nick', 2018, '2Q', 93),
        ('James', 2018, '1Q', 92),
        ('James', 2018, '1Q', 91),
        ('James', 2018, '1Q', 90),
        ('James', 2018, '1Q', 89),
        ('James', 2018, '2Q', 88),
        ('James', 2018, '2Q', 87),
        ('James', 2018, '2Q', 86),
        ('James', 2018, '2Q', 85)
)
SELECT
    name,
    year,
    MAX(
        CASE
            season
            WHEN '1Q' THEN score
            ELSE NULL
        END
    ) AS 1Q_score,
    MAX(
        CASE
            WHEN season = '2Q' THEN score
            ELSE NULL
        END
    ) AS 2Q_score
FROM
    evaluate
GROUP BY
    name,
    year;
