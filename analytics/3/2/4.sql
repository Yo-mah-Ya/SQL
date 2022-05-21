SELECT
    ABS(x1 - x2) AS abs,
    SQRT(POWER(x1 - x2, 2)) AS rms
FROM
    location_1d;

SELECT
    SQRT(POWER(x1 - x2, 2) + POWER(y1 - y2, 2)) AS dist,
    POINT(x1, y1) < -> POINT(x2, y2) AS dist2
FROM
    location_2d;
