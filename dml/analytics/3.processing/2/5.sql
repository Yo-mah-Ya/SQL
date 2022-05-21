SELECT
    user_id,
    register_stamp :: TIMESTAMP AS register_stamp,
    register_stamp :: TIMESTAMP + '1 hour' :: INTERVAL AS after_1_hour,
    register_stamp :: TIMESTAMP - '30 minutes' :: INTERVAL AS before_30_minutes,
    register_stamp :: DATE AS register_date,
    (register_stamp :: DATE + '1 day' :: INTERVAL) :: DATE AS after_1_day,
    (register_stamp :: DATE - '1 month' :: INTERVAL) :: DATE AS before_1_month,
    (register_stamp :: DATE - '1 month' :: INTERVAL) AS before_1_month2
FROM
    mst_users_with_birthday;

SELECT
    user_id,
    CURRENT_DATE AS today,
    register_stamp :: DATE AS register_date,
    CURRENT_DATE - register_stamp :: DATE AS diff_days
FROM
    mst_users_with_birthday;

SELECT
    user_id,
    CURRENT_DATE AS today,
    register_stamp :: DATE AS register_date,
    birth_date :: DATE AS birth_date,
    EXTRACT(
        YEAR
        FROM
            AGE(birth_date :: DATE)
    ) AS current_age,
    EXTRACT(
        YEAR
        FROM
            AGE(register_stamp :: DATE, birth_date :: DATE)
    ) AS register_age
FROM
    mst_users_with_birthday;
