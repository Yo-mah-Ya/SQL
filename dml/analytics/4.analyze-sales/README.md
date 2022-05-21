# 4 Extracting data to know and estimate the amount of the sales

The table shown below shows how window frame like "ROWS BETWEEN..." is gonna be applied.

|                        | specified window frame   | not specified window frame                            |
|------------------------|--------------------------|-------------------------------------------------------|
| when `order by` is specified      | be executed as specified | **ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW**         |
| when `order by` isn't specified  | be executed as specified | **ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING** |

If you specify only **ROWS UNBOUNDED PRECEDING**, **ROWS UNBOUNDED PRECEDING AND CURRENT ROW** is gonna be applied.

## 4-1 Aggregate data in chronological order

### 4-1-1 Aggregate daily sales
### 4-1-2 moving average

```sql
AVG(SUM(purchase_amount)) OVER(
    ORDER BY dt
    ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
) AS seven_day_avg
```

### 4-1-3 cumulative sum

```sql
SUM(SUM(purchase_amount)) OVER(
    PARTITION BY SUBSTRING(dt, 1, 7)
    ORDER BY dt
) AS agg_amount
```

### 4-1-4 year-on-year

```sql
-- the sales 12 months ago
LAG(monthly, 12) OVER(
    ORDER BY year, MONTH
) AS last_year,
-- sales this year to the one 12 months ago
100.* monthly / LAG(monthly, 12) OVER(
    ORDER BY year, MONTH
) AS rate
```

### 4-1-5 Z chart

moving average + cumulative sum + year-on-year

### 4-1-6 Important things to understand sales

## 4-2 Aggregate data using multidimensional axes

### 4-2-1 subtotal

- UNION ALL

```sql
```

- ROLLUP

How ROLLUP works

```sql
-- If you give "GROUP BY ROLLUP(category, sub_category)",
-- it works as 3 types of GROUP BY like shown below.
GROUP BY category
GROUP BY category, sub_category
GROUP BY -- Not grouped by, but executed against all lines
```

```sql
SELECT
    COALESCE(category, 'all') AS category,
    COALESCE(sub_category, 'all') AS sub_category,
    SUM(price) AS amount
FROM
    purchase_detail_log
GROUP BY
    ROLLUP(category, sub_category)
ORDER BY
    category,
    sub_category;
```

### 4-2-2 ABC analytics
### 4-2-3 Fan chart
### 4-2-4 histogram
