SELECT
    product_id,
    score,
    ROW_NUMBER() OVER(
        ORDER BY
            score DESC
    ) AS ROW,
    RANK() OVER(
        ORDER BY
            score DESC
    ) AS rank,
    DENSE_RANK() OVER(
        ORDER BY
            score DESC
    ) AS dense_rank,
    LAG(product_id) OVER(
        ORDER BY
            score DESC
    ) AS lag1,
    LAG(product_id, 2) OVER(
        ORDER BY
            score DESC
    ) AS lag2,
    LEAD(product_id) OVER(
        ORDER BY
            score DESC
    ) AS lead1,
    LEAD(product_id, 2) OVER(
        ORDER BY
            score DESC
    ) AS lead2
FROM
    popular_products
ORDER BY
    ROW;

SELECT
    product_id,
    score,
    ROW_NUMBER() OVER(
        ORDER BY
            score DESC
    ) AS ROW,
    SUM(score) OVER(
        ORDER BY
            score DESC ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
    ) AS cum_score,
    AVG(score) OVER(
        ORDER BY
            score DESC ROWS BETWEEN 1 PRECEDING
            AND 1 FOLLOWING
    ) AS local_avg,
    FIRST_VALUE(product_id) OVER(
        ORDER BY
            score DESC ROWS BETWEEN UNBOUNDED PRECEDING
            AND UNBOUNDED FOLLOWING
    ) AS first_value,
    LAST_VALUE(product_id) OVER(
        ORDER BY
            score DESC ROWS BETWEEN UNBOUNDED PRECEDING
            AND UNBOUNDED FOLLOWING
    ) AS last_value
FROM
    popular_products
ORDER BY
    ROW;

SELECT
    product_id,
    ROW_NUMBER() OVER(
        ORDER BY
            score DESC
    ) AS ROW,
    ARRAY_AGG(product_id) OVER(
        ORDER BY
            score DESC ROWS BETWEEN UNBOUNDED PRECEDING
            AND UNBOUNDED FOLLOWING
    ) AS whole_agg,
    ARRAY_AGG(product_id) OVER(
        ORDER BY
            score DESC ROWS BETWEEN UNBOUNDED PRECEDING
            AND CURRENT ROW
    ) AS cum_agg,
    ARRAY_AGG(product_id) OVER(
        ORDER BY
            score DESC ROWS BETWEEN 1 PRECEDING
            AND 1 FOLLOWING
    ) AS local_agg
FROM
    popular_products
WHERE
    category = 'action'
ORDER BY
    ROW;

SELECT
    category,
    product_id,
    score,
    ROW_NUMBER() OVER(
        PARTITION BY category
        ORDER BY
            score DESC
    ) AS ROW,
    RANK() OVER(
        PARTITION BY category
        ORDER BY
            score DESC
    ) AS rank,
    DENSE_RANK() OVER(
        PARTITION BY category
        ORDER BY
            score DESC
    ) AS dense_rank
FROM
    popular_products
ORDER BY
    category,
    ROW;

-- Extract the first 2 rows every the top ranking by category
SELECT
    *
FROM
    (
        SELECT
            category,
            product_id,
            score,
            ROW_NUMBER() OVER(
                PARTITION BY category
                ORDER BY
                    score DESC
            ) AS rank
        FROM
            popular_products
    ) AS popular_products_with_rank
WHERE
    rank <= 2
ORDER BY
    category,
    rank;

-- Extract the first row every the top ranking by category
SELECT
    DISTINCT category,
    FIRST_VALUE(product_id) OVER(
        PARTITION BY category
        ORDER BY
            score DESC ROWS BETWEEN UNBOUNDED PRECEDING
            AND UNBOUNDED FOLLOWING
    ) AS product_id,
    FIRST_VALUE(score) OVER(
        PARTITION BY category
        ORDER BY
            score DESC ROWS BETWEEN UNBOUNDED PRECEDING
            AND UNBOUNDED FOLLOWING
    ) AS score
FROM
    popular_products;
