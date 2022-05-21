SELECT
    year,
    q1,
    q2,
    CASE
        WHEN q1 < q2 THEN '+'
        WHEN q1 = q2 THEN ' '
        ELSE '-'
    END AS judge_q1_q2,
    q2 - q1 AS diff_q2_q1,
    SIGN(q2 - q1) AS sign_q2_q1
FROM
    quarterly_sales
ORDER BY
    year;

SELECT
    year,
    GREATEST(q1, q2, q3, q4) AS greatest_sales,
    LEAST(q1, q2, q3, q4) AS least_sales
FROM
    quarterly_sales
ORDER BY
    year;

-- simple division
SELECT
    year,
    (q1 + q2 + q3 + q4) / 4 AS average
FROM
    quarterly_sales
ORDER BY
    year;

-- correct the denominator
SELECT
    year,
    CASE
        WHEN NULLIF(
            (
                SIGN(COALESCE(q1, 0)) + SIGN(COALESCE(q2, 0)) + SIGN(COALESCE(q3, 0)) + SIGN(COALESCE(q4, 0))
            ),
            0
        ) THEN (
            COALESCE(q1, 0) + COALESCE(q2, 0) + COALESCE(q3, 0) + COALESCE(q4, 0)
        ) / (
            SIGN(COALESCE(q1, 0)) + SIGN(COALESCE(q2, 0)) + SIGN(COALESCE(q3, 0)) + SIGN(COALESCE(q4, 0))
        ) AS average
    END
FROM
    quarterly_sales
ORDER BY
    year;
