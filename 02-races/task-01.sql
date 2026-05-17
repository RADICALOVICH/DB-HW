WITH per_car AS (
    SELECT c.name           AS car_name,
           c.class          AS car_class,
           AVG(r.position)  AS average_position,
           COUNT(*)         AS race_count
    FROM Cars c
    INNER JOIN Results r ON r.car = c.name
    GROUP BY c.name, c.class
)
SELECT car_name, car_class, average_position, race_count
FROM per_car
WHERE (car_class, average_position) IN (
    SELECT car_class, MIN(average_position)
    FROM per_car
    GROUP BY car_class
)
ORDER BY average_position;
