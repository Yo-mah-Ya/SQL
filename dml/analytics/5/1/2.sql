WITH mst_users_with_int_birth_date AS (
    SELECT
        *,
        20170101 AS int_specific_date,
        CAST(
            REPLACE(SUBSTRING(birth_date, 1, 10), '-', '') AS INTEGER
        ) AS int_birth_date
    FROM
        mst_users
),
mst_users_with_age AS (
    SELECT
        *,
        FLOOR((int_specific_date - int_birth_date) / 10000) AS age
    FROM
        mst_users_with_int_birth_date
)
SELECT
    user_id,
    sex,
    birth_date,
    age
FROM
    mst_users_with_age;

WITH mst_users_with_int_birth_date AS (
    SELECT
        *,
        20170101 AS int_specific_date,
        CAST(
            REPLACE(SUBSTRING(birth_date, 1, 10), '-', '') AS INTEGER
        ) AS int_birth_date
    FROM
        mst_users
),
mst_users_with_age AS (
    SELECT
        *,
        FLOOR((int_specific_date - int_birth_date) / 10000) AS age
    FROM
        mst_users_with_int_birth_date
),
mst_users_with_category AS (
    SELECT
        user_id,
        sex,
        age,
        CONCAT(
            CASE
                WHEN 20 <= age THEN sex
                ELSE ''
            END,
            CASE
                WHEN age BETWEEN 4
                AND 12 THEN 'C'
                WHEN age BETWEEN 13
                AND 19 THEN 'T'
                WHEN age BETWEEN 20
                AND 34 THEN '1'
                WHEN age BETWEEN 35
                AND 49 THEN '2'
                WHEN age >= 50 THEN '3'
            END
        ) AS category
    FROM
        mst_users_with_age
)
SELECT
    category,
    COUNT(category) AS user_count
FROM
    mst_users_with_category
GROUP BY
    category;
