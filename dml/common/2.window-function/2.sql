/*
show these data

1. city
2. park
3. ip_adress
4. number_of_visitors_by_city
5. number_of_visitors_by_city_and_park
6. number_of_unique_visitors_flag_by_city
7. number_of_unique_visitors_by_park
8. number_of_unique_visitors

we can get No. 1 and 2 using SUM() OVER()

we can't use COUNT DISTINCT in Postgres for No. 3
so use LAG and SUM
 */
WITH test (id, city, park, ip_address) AS(
    VALUES
        (1, 'NewYork', 'Central Park', '1.1.1.1'),
        (2, 'NewYork', 'Central Park', '1.1.1.1'),
        (3, 'NewYork', 'Central Park', '2.2.2.2'),
        (4, 'NewYork', 'Central Park', '3.3.3.3'),
        (5, 'NewYork', 'Riverside Park', '4.4.4.4'),
        (6, 'NewYork', 'Riverside Park', '4.3.2.1'),
        (7, 'Boston', 'The Public Garden', '10.11.1.1'),
        (8, 'Boston', 'The Public Garden', '12.11.123.1'),
        (9, 'Boston', 'The Public Garden', '10.11.1.1'),
        (10, 'Boston', 'Boston Common', '1.1.1.1'),
        (11, 'Boston', 'Boston Common', '11.23.45.67'),
        (12, 'Boston', 'Boston Common', '11.23.45.67'),
        (13, 'Boston', 'Boston Common', '12.1.1.1')
),
unique_visitors_by_city AS (
    SELECT
        city,
        COUNT(DISTINCT ip_address) AS number_of_unique_visitors_by_city
    FROM test
    GROUP BY city
),
unique_visitors_by_park AS (
    SELECT
        park,
        COUNT(DISTINCT ip_address) AS number_of_unique_visitors_by_park
    FROM test
    GROUP BY park
)
,unique_visitors AS (
    SELECT
        ip_address,
        COUNT(ip_address) AS number_of_unique_visitors
    FROM test
    GROUP BY ip_address
)
SELECT
    t.city,
    t.park,
    t.ip_address,
    COUNT(t.ip_address) OVER(PARTITION BY t.city ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS number_of_visitors_by_city,
    COUNT(t.ip_address) OVER(PARTITION BY t.city, t.park ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS number_of_visitors_by_city_and_park,
    unique_visitors_by_city.number_of_unique_visitors_by_city AS number_of_unique_visitors_by_city,
    unique_visitors_by_park.number_of_unique_visitors_by_park AS number_of_unique_visitors_by_park,
    unique_visitors.number_of_unique_visitors
FROM test AS t
INNER JOIN unique_visitors_by_city ON t.city = unique_visitors_by_city.city
INNER JOIN unique_visitors_by_park ON t.park = unique_visitors_by_park.park
INNER JOIN unique_visitors ON t.ip_address = unique_visitors.ip_address;

/*
  city   |       park        | ip_address  | number_of_visitors_by_city | number_of_visitors_by_city_and_park | number_of_unique_visitors_by_city | number_of_unique_visitors_by_park | number_of_unique_visitors
---------+-------------------+-------------+----------------------------+-------------------------------------+-----------------------------------+-----------------------------------+---------------------------
 Boston  | Boston Common     | 1.1.1.1     |                          7 |                                   4 |                                 5 |                                 3 |                         3
 Boston  | Boston Common     | 12.1.1.1    |                          7 |                                   4 |                                 5 |                                 3 |                         1
 Boston  | Boston Common     | 11.23.45.67 |                          7 |                                   4 |                                 5 |                                 3 |                         2
 Boston  | Boston Common     | 11.23.45.67 |                          7 |                                   4 |                                 5 |                                 3 |                         2
 Boston  | The Public Garden | 10.11.1.1   |                          7 |                                   3 |                                 5 |                                 2 |                         2
 Boston  | The Public Garden | 12.11.123.1 |                          7 |                                   3 |                                 5 |                                 2 |                         1
 Boston  | The Public Garden | 10.11.1.1   |                          7 |                                   3 |                                 5 |                                 2 |                         2
 NewYork | Central Park      | 2.2.2.2     |                          6 |                                   4 |                                 5 |                                 3 |                         1
 NewYork | Central Park      | 1.1.1.1     |                          6 |                                   4 |                                 5 |                                 3 |                         3
 NewYork | Central Park      | 3.3.3.3     |                          6 |                                   4 |                                 5 |                                 3 |                         1
 NewYork | Central Park      | 1.1.1.1     |                          6 |                                   4 |                                 5 |                                 3 |                         3
 NewYork | Riverside Park    | 4.4.4.4     |                          6 |                                   2 |                                 5 |                                 2 |                         1
 NewYork | Riverside Park    | 4.3.2.1     |                          6 |                                   2 |                                 5 |                                 2 |                         1
(13 rows)
 */
