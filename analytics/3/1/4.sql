SELECT
    CURRENT_DATE AS dt,
    CURRENT_TIMESTAMP AS stamp;

SELECT
    CAST('2016-01-30' AS DATE) AS dt,
    CAST('2016-01-30 12:00:00' AS TIMESTAMP) AS stamp;

SELECT
    stamp,
    EXTRACT(
        YEAR
        FROM
            stamp
    ) AS year,
    EXTRACT(
        MONTH
        FROM
            stamp
    ) AS month,
    EXTRACT(
        DAY
        FROM
            stamp
    ) AS DAY,
    EXTRACT(
        HOUR
        FROM
            stamp
    ) AS HOUR
FROM
    (
        SELECT
            CURRENT_TIMESTAMP AS stamp
    ) AS t;
