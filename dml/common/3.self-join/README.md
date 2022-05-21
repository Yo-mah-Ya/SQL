# self join

## sequence with repetition

```sql
FROM table_a AS a CROSS JOIN table_a AS b
```

## sequence without repetition

```sql
FROM table_a AS a INNER JOIN table_a AS b
ON a.id <> b.id
```

## combination

```sql
FROM table_a AS a INNER JOIN table_a AS b
ON a.id > b.id
```
