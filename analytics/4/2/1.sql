-- subtotal
WITH sub_category_amount AS (
    SELECT
        category AS category,
        sub_category AS sub_category,
        SUM(price) AS amount
    FROM
        purchase_detail_log
    GROUP BY
        category,
        sub_category
),
category_amount AS (
    SELECT
        category AS category,
        CAST('all' AS TEXT) AS sub_category,
        SUM(price) AS amount
    FROM
        purchase_detail_log
    GROUP BY
        category
),
total_amount AS (
    SELECT
        CAST('all' AS TEXT) AS category,
        CAST('all' AS TEXT) AS sub_category,
        SUM(price) AS amount
    FROM
        purchase_detail_log
)
SELECT
    category,
    sub_category,
    amount
FROM
    sub_category_amount
UNION
ALL
SELECT
    category,
    sub_category,
    amount
FROM
    category_amount
UNION
ALL
SELECT
    category,
    sub_category,
    amount
FROM
    total_amount;

SELECT
    COALESCE(category, 'all') AS category,
    COALESCE(sub_category, 'all') AS sub_category,
    SUM(price) AS amount
FROM
    purchase_detail_log
GROUP BY
    ROLLUP(category, sub_category)
ORDER BY
    category,
    sub_category;
