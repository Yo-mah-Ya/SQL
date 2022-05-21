SELECT
    a.ip,
    l.continent_name,
    l.country_name,
    l.city_name,
    l.time_zone
FROM
    action_log_with_ip AS a
    LEFT OUTER JOIN mst_city_ip AS i ON a.ip :: inet << i.network
    LEFT OUTER JOIN mst_locations AS l ON i.geoname_id = l.geoname_id;

WITH path_stat AS (
    SELECT
        path,
        COUNT(DISTINCT long_session) AS access_users,
        COUNT(DISTINCT short_session) AS access_count,
        COUNT(*) AS page_view
    FROM
        access_log
    GROUP BY
        path
),
path_ranking AS (
    SELECT
        'access_user' AS TYPE,
        path,
        RANK() OVER(
            ORDER BY
                access_users DESC
        ) AS rank
    FROM
        path_stat
    UNION
    ALL
    SELECT
        'access_count' AS TYPE,
        path,
        RANK() OVER(
            ORDER BY
                access_count DESC
        ) AS rank
    FROM
        path_stat
    UNION
    ALL
    SELECT
        'page_view' AS TYPE,
        path,
        RANK() OVER(
            ORDER BY
                page_view DESC
        ) AS rank
    FROM
        path_stat
)
SELECT
    *
FROM
    path_ranking
ORDER BY
    TYPE,
    rank;

WITH path_stat AS (
    SELECT
        path,
        COUNT(DISTINCT long_session) AS access_users,
        COUNT(DISTINCT short_session) AS access_count,
        COUNT(*) AS page_view
    FROM
        access_log
    GROUP BY
        path
),
path_ranking AS (
    SELECT
        'access_user' AS TYPE,
        path,
        RANK() OVER(
            ORDER BY
                access_users DESC
        ) AS rank
    FROM
        path_stat
    UNION
    ALL
    SELECT
        'access_count' AS TYPE,
        path,
        RANK() OVER(
            ORDER BY
                access_count DESC
        ) AS rank
    FROM
        path_stat
    UNION
    ALL
    SELECT
        'page_view' AS TYPE,
        path,
        RANK() OVER(
            ORDER BY
                page_view DESC
        ) AS rank
    FROM
        path_stat
),
pair_ranking AS (
    SELECT
        r1.path,
        r1.type AS type1,
        r1.rank AS rank1,
        r2.type AS type2,
        r2.rank AS rank2,
        POWER(r1.rank - r2.rank, 2) AS diff
    FROM
        path_ranking AS r1
        JOIN path_ranking AS r2 ON r1.path = r2.path
)
SELECT
    *
FROM
    pair_ranking;

-- The proof and measurement of association between two things by "Charles Spearman"
WITH path_stat AS (
    SELECT
        path,
        COUNT(DISTINCT long_session) AS access_users,
        COUNT(DISTINCT short_session) AS access_count,
        COUNT(*) AS page_view
    FROM
        access_log
    GROUP BY
        path
),
path_ranking AS (
    SELECT
        'access_user' AS TYPE,
        path,
        RANK() OVER(
            ORDER BY
                access_users DESC
        ) AS rank
    FROM
        path_stat
    UNION
    ALL
    SELECT
        'access_count' AS TYPE,
        path,
        RANK() OVER(
            ORDER BY
                access_count DESC
        ) AS rank
    FROM
        path_stat
    UNION
    ALL
    SELECT
        'page_view' AS TYPE,
        path,
        RANK() OVER(
            ORDER BY
                page_view DESC
        ) AS rank
    FROM
        path_stat
),
pair_ranking AS (
    SELECT
        r1.path,
        r1.type AS type1,
        r1.rank AS rank1,
        r2.type AS type2,
        r2.rank AS rank2,
        POWER(r1.rank - r2.rank, 2) AS diff
    FROM
        path_ranking AS r1
        JOIN path_ranking AS r2 ON r1.path = r2.path
)
SELECT
    type1,
    type2,
    1 - (6 * SUM(diff) / (POWER(COUNT(1), 3) - COUNT(1))) AS spearman
FROM
    pair_ranking
GROUP BY
    type1,
    type2
ORDER BY
    type1 DESC,
    type2 DESC;
