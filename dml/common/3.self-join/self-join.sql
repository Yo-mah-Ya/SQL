WITH users (id, name, email, age) AS(
    VALUES
        (1, 'Nick', 'nick@example.com', 19),
        (2, 'James', 'james@example.net', 20),
        (3, 'Watt', 'watt@example.com', 31),
        (4, 'Tom', 'tom@example1.jp', 23),
        (5, 'Emma', 'emma@example.jp', 28)
),
follows (follower_id, followee_id) AS(
    VALUES
        (1, 2),
        (1, 3),
        (1, 4),
        (1, 5),
        (3, 1),
        (3, 2),
        (4, 5),
        (5, 1),
        (5, 2),
        (5, 3),
        (5, 4)
)
SELECT
    u1.*,
    u2.*
FROM
    users u1
    INNER JOIN follows f ON u1.id = f.follower_id
    INNER JOIN users u2 ON f.followee_id = u2.id;

/*
 id | name |      email       | age | id | name  |       email       | age
 ----+------+------------------+-----+----+-------+-------------------+-----
 1 | Nick | nick@example.com |  19 |  2 | James | james@example.net |  20
 1 | Nick | nick@example.com |  19 |  3 | Watt  | watt@example.com  |  31
 1 | Nick | nick@example.com |  19 |  4 | Tom   | tom@example1.jp   |  23
 1 | Nick | nick@example.com |  19 |  5 | Emma  | emma@example.jp   |  28
 3 | Watt | watt@example.com |  31 |  1 | Nick  | nick@example.com  |  19
 3 | Watt | watt@example.com |  31 |  2 | James | james@example.net |  20
 4 | Tom  | tom@example1.jp  |  23 |  5 | Emma  | emma@example.jp   |  28
 5 | Emma | emma@example.jp  |  28 |  1 | Nick  | nick@example.com  |  19
 5 | Emma | emma@example.jp  |  28 |  2 | James | james@example.net |  20
 5 | Emma | emma@example.jp  |  28 |  3 | Watt  | watt@example.com  |  31
 5 | Emma | emma@example.jp  |  28 |  4 | Tom   | tom@example1.jp   |  23
 (11 rows)
 */
