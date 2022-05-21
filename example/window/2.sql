/*
 集計結果として取得したいこと
 都道府県・park・訪問者IPをすべて表示し、右列に集計結果を表示してほしい。
 集計条件は

 1. number_of_visitors_by_city
 2. number_of_visitors_by_city_and_park
 3. number_of_unique_visitors_flag_by_city
 4. number_of_unique_visitors_by_park
 5. number_of_unique_visitors
 です。
 1と2だけならWindow関数のSUM() OVER()で取得可能です。
 3からが普通に考えるとCOUNT DISTINCTが必要になります。
 が、残念なことにPostgreSQLではWindow関数でのDISTINCTが実装されていません。

 直前の行が同じ値だったら0違えば1を立てて、そのあとでSUMったらOKじゃね？
 LAG(ip_address, 1) OVER (PARTITION BY xxxxx ORDER BY xxx)
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
t AS (
    SELECT
        city,
        park,
        ip_address,
        COUNT(ip_address) OVER(PARTITION BY city) AS number_of_visitors_by_city,
        COUNT(ip_address) OVER(
            PARTITION BY city,
            park
        ) AS number_of_visitors_by_city_and_park,
        CASE
            WHEN ip_address = LAG(ip_address, 1) OVER(PARTITION BY city) THEN 0
            ELSE 1
        END AS number_of_unique_visitors_flag_by_city,
        CASE
            WHEN ip_address = LAG(ip_address, 1) OVER(PARTITION BY park) THEN 0
            ELSE 1
        END AS number_of_unique_visitors_flag_by_park,
        CASE
            WHEN ip_address = LAG(ip_address, 1) OVER() THEN 0
            ELSE 1
        END AS number_of_unique_visitors_flag
    FROM
        test
    ORDER BY
        city,
        park
)
SELECT
    city,
    park,
    ip_address,
    number_of_visitors_by_city,
    number_of_visitors_by_city_and_park,
    SUM(number_of_unique_visitors_flag_by_city) OVER(
        PARTITION BY city
        ORDER BY
            city
    ) AS number_of_unique_visitors_flag_by_city,
    SUM(number_of_unique_visitors_flag_by_park) OVER(
        PARTITION BY park
        ORDER BY
            park
    ) AS number_of_unique_visitors_by_park,
    SUM(number_of_unique_visitors_flag) OVER() AS number_of_unique_visitors
FROM
    t
ORDER BY
    city,
    park;

/*
 city   |       park        | ip_address  | number_of_visitors_by_city | number_of_visitors_by_city_and_park | number_of_unique_visitors_flag_by_city | number_of_unique_visitors_by_park | number_of_unique_visitors
 ---------+-------------------+-------------+----------------------------+-------------------------------------+----------------------------------------+-----------------------------------+---------------------------
 Boston  | Boston Common     | 11.23.45.67 |                          7 |                                   4 |                                      5 |                                 3 |                        10
 Boston  | Boston Common     | 11.23.45.67 |                          7 |                                   4 |                                      5 |                                 3 |                        10
 Boston  | Boston Common     | 12.1.1.1    |                          7 |                                   4 |                                      5 |                                 3 |                        10
 Boston  | Boston Common     | 1.1.1.1     |                          7 |                                   4 |                                      5 |                                 3 |                        10
 Boston  | The Public Garden | 12.11.123.1 |                          7 |                                   3 |                                      5 |                                 3 |                        10
 Boston  | The Public Garden | 10.11.1.1   |                          7 |                                   3 |                                      5 |                                 3 |                        10
 Boston  | The Public Garden | 10.11.1.1   |                          7 |                                   3 |                                      5 |                                 3 |                        10
 NewYork | Central Park      | 1.1.1.1     |                          6 |                                   4 |                                      5 |                                 3 |                        10
 NewYork | Central Park      | 3.3.3.3     |                          6 |                                   4 |                                      5 |                                 3 |                        10
 NewYork | Central Park      | 2.2.2.2     |                          6 |                                   4 |                                      5 |                                 3 |                        10
 NewYork | Central Park      | 1.1.1.1     |                          6 |                                   4 |                                      5 |                                 3 |                        10
 NewYork | Riverside Park    | 4.4.4.4     |                          6 |                                   2 |                                      5 |                                 2 |                        10
 NewYork | Riverside Park    | 4.3.2.1     |                          6 |                                   2 |                                      5 |                                 2 |                        10
 */
