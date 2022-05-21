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
