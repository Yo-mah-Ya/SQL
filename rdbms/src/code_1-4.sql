CREATE TABLE students (name CHAR(16) PRIMARY KEY, age INTEGER);

INSERT INTO
    students
VALUES
    ('ブラウン', 22),
    ('ラリー', 19),
    ('ジョン', NULL),
    ('ボギー', 21);

SELECT
    *
FROM
    students
WHERE
    age IS DISTINCT
FROM
    20;

-- 空文字との連結（Oracle）
SELECT
    'abc' || '' AS STRING
FROM
    dual;

-- NULLとの連結（Oracle）
SELECT
    'abc' || NULL AS STRING
FROM
    dual;

CREATE TABLE empty_str (str CHAR(8), description CHAR(16));

INSERT INTO
    empty_str
VALUES
    ('', 'empty string'),
    (NULL, 'NULL');

SELECT
    'abc' || str AS STRING,
    description
FROM
    empty_str;
