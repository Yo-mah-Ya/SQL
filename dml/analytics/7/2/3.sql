-- data validation
SELECT
    ACTION,
    AVG(
        CASE
            WHEN SESSION IS NOT NULL THEN 1.
            ELSE 0.
        END
    ) AS SESSION,
    AVG(
        CASE
            WHEN user_id IS NOT NULL THEN 1.
            ELSE 0.
        END
    ) AS user_is,
    AVG(
        CASE
            ACTION
            WHEN 'view' THEN CASE
                WHEN category IS NULL THEN 1.
                ELSE 0.
            END
            ELSE CASE
                WHEN category IS NOT NULL THEN 1.
                ELSE 0.
            END
        END
    ) AS category,
    AVG(
        CASE
            ACTION
            WHEN 'view' THEN CASE
                WHEN products IS NULL THEN 1.
                ELSE 0.
            END
            ELSE CASE
                WHEN products IS NOT NULL THEN 1.
                ELSE 0.
            END
        END
    ) AS products,
    AVG(
        CASE
            ACTION
            WHEN 'purchase' THEN CASE
                WHEN amount IS NOT NULL THEN 1.
                ELSE 0.
            END
            ELSE CASE
                WHEN amount IS NULL THEN 1.
                ELSE 0.
            END
        END
    ) AS amount,
    AVG(
        CASE
            WHEN stamp IS NOT NULL THEN 1.
            ELSE 0.
        END
    ) AS stamp
FROM
    invalid_action_log
GROUP BY
    ACTION;
