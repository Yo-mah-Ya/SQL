# EXISTS

## universal quantifier

### everything meets the condition x

- NOT EXISTS

    show the names of stores where **every menus are under or equal to 500**
    => show the names of stores where **there're no menus which are higher than 500**

    This is double negative position.

    ```sql
    SELECT DISTINCT shop_name
    FROM menus m1
    WHERE NOT EXISTS (
        SELECT * FROM menus m2
        WHERE m2.shop_name = m1.shop_name
            AND m2.price > 500
    );
    ```

- ALL

    ```sql
    SELECT DISTINCT shop_name
    FROM menus m1
    WHERE  500 >= ALL (
        SELECT * FROM menus m2
        WHERE m2.shop_name = m1.shop_name
    );
    ```

    this will be evaluated like shown below,
    so if it's possible that sub query returns "NULL", it doesn't work right.

    ```sql
    (500 >= 100) AND (500 >= 200) AND (500 >= 300) AND (500 >= NULL)
    ```

- HAVING

    ```sql
    SELECT shop_name FROM menus
    GROUP BY shop_name
    HAVING MAX(price) <= 500;
    ```
