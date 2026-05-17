SELECT c.name           AS car_name,
       c.class          AS car_class,
       AVG(r.position)  AS average_position,
       COUNT(*)         AS race_count,
       cl.country       AS car_country
FROM Cars c
INNER JOIN Results r  ON r.car = c.name
INNER JOIN Classes cl ON cl.class = c.class
GROUP BY c.name, c.class, cl.country
ORDER BY average_position, car_name
LIMIT 1;
