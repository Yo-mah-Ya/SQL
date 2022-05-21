SELECT
    new_mst.*
FROM
    mst_products_20170101 AS new_mst
    LEFT OUTER JOIN mst_products_20161201 AS old_mst ON new_mst.product_id = old_mst.product_id
WHERE
    old_mst.product_id IS NULL;

-- deleted data
SELECT
    new_mst.*
FROM
    mst_products_20170101 AS new_mst
    LEFT OUTER JOIN mst_products_20161201 AS old_mst ON new_mst.product_id = old_mst.product_id
WHERE
    old_mst.product_id IS NULL;

-- updated data
SELECT
    new_mst.product_id,
    old_mst.name AS old_name,
    old_mst.price AS old_price,
    new_mst.name AS new_name,
    new_mst.price AS new_price,
    new_mst.updated_at
FROM
    mst_products_20170101 AS new_mst
    INNER JOIN mst_products_20161201 AS old_mst ON new_mst.product_id = old_mst.product_id
WHERE
    new_mst.updated_at <> old_mst.updated_at;
