SELECT
    register_date,
    COUNT(DISTINCT user_id) AS register_count
FROM
    mst_users
GROUP BY
    register_date
ORDER BY
    register_date;

WITH mst_users_with_year_month AS (
    SELECT
        *,
        SUBSTRING(register_date, 1, 7) AS year_month
    FROM
        mst_users
)
SELECT
    year_month,
    COUNT(DISTINCT user_id) AS register_count,
    LAG(COUNT(DISTINCT user_id)) OVER(
        ORDER BY
            year_month
    ) AS last_month_count,
    1.0 * COUNT(DISTINCT user_id) / LAG(COUNT(DISTINCT user_id)) OVER(
        ORDER BY
            year_month
    ) AS month_over_month_ratio
FROM
    mst_users_with_year_month
GROUP BY
    year_month;

WITH mst_users_with_year_month AS (
    SELECT
        *,
        SUBSTRING(register_date, 1, 7) AS year_month
    FROM
        mst_users
)
SELECT
    year_month,
    COUNT(DISTINCT user_id) AS register_count,
    COUNT(
        DISTINCT CASE
            WHEN register_device = 'pc' THEN user_id
        END
    ) AS register_pc,
    COUNT(
        DISTINCT CASE
            WHEN register_device = 'sp' THEN user_id
        END
    ) AS register_sp,
    COUNT(
        DISTINCT CASE
            WHEN register_device = 'app' THEN user_id
        END
    ) AS register_app
FROM
    mst_users_with_year_month
GROUP BY
    year_month;
