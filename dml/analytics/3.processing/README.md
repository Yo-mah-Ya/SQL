# 3 SQL for data processing

## 3-1 Operation on a value

### 3-1-1 replace code to label
### 3-1-2 extract elements from an URL
### 3-1-3 divide strings into arrays
### 3-1-4 handling datetime and timestamp
### 3-1-5 replace NULL to default values with the COALESCE function

## 3-2 Operation on plural values

### 3-2-1 Concatenate strings
### 3-2-2 Compare multiple values

Get the sign of a number

**1 means +, 0 means equal, -1 means -**

```sql
SIGN(q2 - q1) AS sign_q2_q1
```

Get the greatest and least value of the list of arguments

```sql
GREATEST(q1, q2, q3, q4) AS greatest_sales,
LEAST(q1, q2, q3, q4) AS least_sales
```

Get the average value in a same row

```sql
CASE
	-- avoid the zero division using NULLIF
    WHEN NULLIF(
        (
            SIGN(COALESCE(q1, 0)) + SIGN(COALESCE(q2, 0)) + SIGN(COALESCE(q3, 0)) + SIGN(COALESCE(q4, 0))
        ),
        0
    ) THEN (
        -- avoid the NULL propagating
        COALESCE(q1, 0) + COALESCE(q2, 0) + COALESCE(q3, 0) + COALESCE(q4, 0)
    ) / (
        -- avoid the NULL propagating and get the appropriate the number of denominator using SIGN
        SIGN(COALESCE(q1, 0)) + SIGN(COALESCE(q2, 0)) + SIGN(COALESCE(q3, 0)) + SIGN(COALESCE(q4, 0))
    ) AS average
END
```

### 3-2-3 Calculate the ratio of two values
### 3-2-4 Calculate the distance between two values

**RMS: Root Mean Square**

```sql
SQRT(POWER(x1 - x2, 2)) AS rms
```

### 3-2-5 Calculate date/time series
### 3-2-6 Handling IP Addresses

## 3-3 Operation on a table

### 3-3-1 Capture the characteristics of one group
### 3-3-2 Dealing with Order in Groups

- Extract the first 2 rows every the top ranking by category

	1. get the ranking using sub query
    2. filter the ranking with WHERE clause

- Extract the first row every the top ranking by category

	If you get only one row by category, you can use window function

		1. FIRST_VALUE, LAST_VALUE function
        2. Use DISTINCT to group by instead of using GROUP BY clause

### 3-3-3 Convert vertical data to horizontal data

- If you're sure **what kind of** and **how many** data is gonna be converted to horizontal data.

```sql
MAX(
    CASE
        WHEN indicator = 'impressions' THEN val
    END
) AS impressions
```

- If not

```sql
STRING_AGG(product_id, '/') AS product_ids
```

### 3-3-4 Convert horizontal data to vertical data

- convert columns' values to vertical data using **pivot table**

1. create pivot table using **CROSS JOIN**
2. place values with the index - pivot number.

- convert array values to vertical data

1. use **table function** like UNNEST

## 3-4 Operation on plural tables

### 3-4-1 Arrange multiple tables vertically.

UNION, INTERSECT, EXCEPT

### 3-4-2 Arrange multiple tables side by side

JOIN

### 3-4-3 Express flags of conditions as 0 and 1
### 3-4-4 Name and reuse calculated tables

CTE: Common Table Expression

### 3-4-5 Create pseudo tables
