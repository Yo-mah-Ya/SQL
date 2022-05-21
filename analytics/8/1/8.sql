-- MAP (Mean Average Precision)
WITH search_result_with_correct_items AS (
    SELECT
        COALESCE(r.keyword, c.keyword) AS keyword,
        r.rank,
        COALESCE(r.item, c.item) AS item,
        CASE
            WHEN c.item IS NOT NULL THEN 1
            ELSE 0
        END AS correct
    FROM
        search_result AS r FULL
        OUTER JOIN correct_result AS c ON r.keyword = c.keyword
        AND r.item = c.item
),
search_result_with_precision AS (
    SELECT
        *,
        SUM(correct) OVER(
            PARTITION BY keyword
            ORDER BY
                COALESCE(rank, 10000) ASC ROWS BETWEEN UNBOUNDED PRECEDING
                AND CURRENT ROW
        ) AS cum_correct,
        CASE
            WHEN rank IS NULL THEN.0
            ELSE 100.* SUM(correct) OVER(
                PARTITION BY keyword
                ORDER BY
                    COALESCE(rank, 10000) ASC ROWS BETWEEN UNBOUNDED PRECEDING
                    AND CURRENT ROW
            ) / COUNT(1) OVER(
                PARTITION BY keyword
                ORDER BY
                    COALESCE(rank, 10000) ASC ROWS BETWEEN UNBOUNDED PRECEDING
                    AND CURRENT ROW
            )
        END AS precision
    FROM
        search_result_with_correct_items
),
average_precision_for_keywords AS (
    SELECT
        keyword,
        AVG(precision) AS average_precision
    FROM
        search_result_with_precision
    WHERE
        correct = 1
    GROUP BY
        keyword
)
SELECT
    *
FROM
    average_precision_for_keywords;
