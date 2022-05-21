# NULL

## What would NULL be evaluated

- When you join conditions with **AND**:

    false is the prioritized the most

    **false > unknown > true**


- When **OR**:

    true is the prioritized the most

    **true > unknown > false**

## expression with NULL

- =

    use IS NULL instead of =

    ```sql
    age IS NULL
    ```

- <>

    use IS NOT NULL instead of <>

    ```sql
    age IS NOT NULL
    ```

- NOT IN

    ```sql
    age NOT IN (22, 23, NULL)
    -- this is evaluated like this
    -- (age <> 22) AND (age <> 23) AND (age <> NULL)
    ```

    so use NOT EXISTS instead of NOT IN

    ```sql
    FROM table_a AS a
    WHERE NOT EXISTS (
        SELECT age FROM table_b AS b
        WHERE a.age = b.age
    );
    ```

- ALL

    ```sql
    age < ALL (22, 23, NULL)
    -- this is evaluated like this
    -- (age < 22) AND (age < 23) AND (age < NULL)
    ```

    so use coalesce instead of < ALL

    ```sql
    WHERE age < ALL (
        COALESCE(22, 0),
        COALESCE(23, 0),
        COALESCE(NULL, 0)
    );
    ```
