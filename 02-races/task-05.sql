-- Примечание: использую строгое условие "> 3" из текста задачи. Из-за этого для Sedan
-- low_position_count = 1, а не 2 как в эталонном выводе (там, видимо, имелось в виду ">= 3").
WITH car_stats AS (
    SELECT c.name              AS car_name,
           c.class             AS car_class,
           AVG(r.position)     AS average_position,
           COUNT(*)            AS race_count
    FROM Cars c
    INNER JOIN Results r ON r.car = c.name
    GROUP BY c.name, c.class
),
class_stats AS (
    SELECT cs.car_class,
           SUM(cs.race_count)                                   AS total_races,
           COUNT(*) FILTER (WHERE cs.average_position > 3.0)    AS low_position_count
    FROM car_stats cs
    GROUP BY cs.car_class
)
SELECT cs.car_name,
       cs.car_class,
       cs.average_position,
       cs.race_count,
       cl.country               AS car_country,
       clss.total_races,
       clss.low_position_count
FROM car_stats cs
INNER JOIN class_stats clss ON clss.car_class = cs.car_class
INNER JOIN Classes      cl  ON cl.class       = cs.car_class
WHERE cs.average_position > 3.0
ORDER BY clss.low_position_count DESC, cs.car_name;
