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
search_result_with_recall AS (
    SELECT
        *,
        SUM(correct) OVER(
            PARTITION BY keyword
            ORDER BY
                COALESCE(rank, 100000) ASC ROWS BETWEEN UNBOUNDED PRECEDING
                AND CURRENT ROW
        ) AS cum_correct,
        CASE
            WHEN rank IS NULL THEN 0.
            ELSE 100.* SUM(correct) OVER(
                PARTITION BY keyword
                ORDER BY
                    COALESCE(rank, 100000) ASC ROWS BETWEEN UNBOUNDED PRECEDING
                    AND CURRENT ROW
            ) / SUM(correct) OVER(PARTITION BY keyword)
        END AS recall
    FROM
        search_result_with_correct_items
)
SELECT
    *
FROM
    search_result_with_recall
ORDER BY
    keyword,
    rank;
