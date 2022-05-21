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
    p.category AS product_category,
    u.category AS user_category,
    COUNT(*) AS pruchase_count
FROM
    action_log AS p
    INNER JOIN mst_users_with_category AS u ON p.user_id = u.user_id
WHERE
    ACTION = 'purchase'
GROUP BY
    p.category,
    u.category
ORDER BY
    p.category,
    u.category;
