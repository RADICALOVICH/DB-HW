WITH class_stats AS (
    SELECT c.class           AS car_class,
           AVG(r.position)   AS class_avg,
           COUNT(*)          AS total_races
    FROM Cars c
    INNER JOIN Results r ON r.car = c.name
    GROUP BY c.class
),
winning_classes AS (
    SELECT car_class, total_races
    FROM class_stats
    WHERE class_avg = (SELECT MIN(class_avg) FROM class_stats)
),
car_stats AS (
    SELECT c.name            AS car_name,
           c.class           AS car_class,
           AVG(r.position)   AS average_position,
           COUNT(*)          AS race_count
    FROM Cars c
    INNER JOIN Results r ON r.car = c.name
    GROUP BY c.name, c.class
)
SELECT cs.car_name,
       cs.car_class,
       cs.average_position,
       cs.race_count,
       cl.country           AS car_country,
       wc.total_races
FROM car_stats cs
INNER JOIN winning_classes wc ON wc.car_class = cs.car_class
INNER JOIN Classes         cl ON cl.class     = cs.car_class
ORDER BY cs.average_position, cs.car_name;
