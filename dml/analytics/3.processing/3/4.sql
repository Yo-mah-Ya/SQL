-- convert rows to columns
SELECT
    q.year,
    CASE
        WHEN p.idx = 1 THEN 'q1'
        WHEN p.idx = 2 THEN 'q2'
        WHEN p.idx = 3 THEN 'q3'
        WHEN p.idx = 4 THEN 'q4'
    END AS quarter,
    CASE
        WHEN p.idx = 1 THEN q.q1
        WHEN p.idx = 2 THEN q.q2
        WHEN p.idx = 3 THEN q.q3
        WHEN p.idx = 4 THEN q.q4
    END AS sales
FROM
    quarterly_sales AS q
    CROSS JOIN (
        SELECT
            1 AS idx
        UNION
        ALL
        SELECT
            2 idx
        UNION
        ALL
        SELECT
            3 idx
        UNION
        ALL
        SELECT
            4 idx
    ) AS p;

-- table function
SELECT
    UNNEST(array ['A001','A002','A003']) AS product_id;

SELECT
    purchase_id,
    product_id
FROM
    purchase_log AS p
    CROSS JOIN (
        SELECT
            UNNEST(STRING_TO_ARRAY(product_ids, ',')) AS product_id
        FROM
            (
                SELECT
                    purchase_id,
                    STRING_AGG(product_id, ',') AS product_ids,
                    SUM(price) AS amount
                FROM
                    purchase_detail_log
                GROUP BY
                    purchase_id
                ORDER BY
                    purchase_id
            ) AS t
    ) AS q;

-- another way
SELECT
    *,
    REGEXP_SPLIT_TO_TABLE(product_ids, ',') AS product_id
FROM
    (
        SELECT
            purchase_id,
            STRING_AGG(product_id, ',') AS product_ids,
            SUM(price) AS amount
        FROM
            purchase_detail_log
        GROUP BY
            purchase_id
        ORDER BY
            purchase_id
    ) AS t;
