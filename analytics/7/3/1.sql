-- detect duplicate records
SELECT
    COUNT(1) AS total_num,
    COUNT(DISTINCT id) AS key_num
FROM
    mst_categories;

-- extract duplicate records
SELECT
    id,
    COUNT(*) AS record_num,
    STRING_AGG(name, ',') AS name_list,
    STRING_AGG(stamp, ',') AS stamp_list
FROM
    mst_categories
GROUP BY
    id
HAVING
    COUNT(*) > 1;
