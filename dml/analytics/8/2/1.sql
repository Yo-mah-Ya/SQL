-- data mining
WITH purchase_id_count AS (
    SELECT
        COUNT(DISTINCT purchase_id) AS purchase_count
    FROM
        purchase_detail_log
),
purchase_detail_log_with_counts AS (
    SELECT
        d.purchase_id,
        p.purchase_count,
        d.product_id,
        COUNT(1) OVER(PARTITION BY d.product_id) AS product_count
    FROM
        purchase_detail_log AS d
        CROSS JOIN purchase_id_count AS p
)
SELECT
    *
FROM
    purchase_detail_log_with_counts
ORDER BY
    product_id,
    purchase_id;

WITH purchase_id_count AS (
    SELECT
        COUNT(DISTINCT purchase_id) AS purchase_count
    FROM
        purchase_detail_log
),
purchase_detail_log_with_counts AS (
    SELECT
        d.purchase_id,
        p.purchase_count,
        d.product_id,
        COUNT(1) OVER(PARTITION BY d.product_id) AS product_count
    FROM
        purchase_detail_log AS d
        CROSS JOIN purchase_id_count AS p
),
product_pair_with_stat AS (
    SELECT
        l1.product_id AS p1,
        l2.product_id AS p2,
        l1.product_count AS p1_count,
        l2.product_count AS p2_count,
        COUNT(11) AS p1_p2_count,
        l1.purchase_count AS purchase_count
    FROM
        purchase_detail_log_with_counts AS l1
        INNER JOIN purchase_detail_log_with_counts AS l2 ON l1.purchase_id = l2.purchase_id
    WHERE
        l1.product_id <> l2.product_id
    GROUP BY
        l1.product_id,
        l2.product_id,
        l1.product_count,
        l2.product_count,
        l1.purchase_count
)
SELECT
    p1,
    p2,
    100.* p1_p2_count / purchase_count AS support,
    100.* p1_p2_count / p1_count AS confidence,
    (100.* p1_p2_count / p1_count) / (100.* p2_count / purchase_count) AS lift
FROM
    product_pair_with_stat
ORDER BY
    p1,
    p2;
