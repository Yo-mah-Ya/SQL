SELECT
    a.action,
    a.stamp,
    c.dow,
    c.holiday_name,
    c.dow_num IN (0, 6)
    OR c.holiday_name IS NOT NULL AS is_day_off
FROM
    action_log AS a
    JOIN mst_calendar AS c ON CAST(SUBSTRING(a.stamp, 1, 4) AS INT) = c.year
    AND CAST(SUBSTRING(a.stamp, 6, 2) AS INT) = c.month
    AND CAST(SUBSTRING(a.stamp, 9, 2) AS INT) = c.day;
