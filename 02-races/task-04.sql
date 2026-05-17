with class_stats as(
	SELECT c.class,
	       AVG(r.position)        AS class_avg_position,
	       COUNT(DISTINCT c.name) AS car_count_in_one_class
	FROM Cars c JOIN Results r ON r.car = c.name
	GROUP BY c.class
),
car_stats AS (
    SELECT c.name              AS car_name,
           c.class             AS car_class,
           AVG(r.position)     AS average_position,
           COUNT(*)            AS race_count
    FROM Cars c
    INNER JOIN Results r ON r.car = c.name
    GROUP BY c.name, c.class
)
SELECT cs.car_name,
       cs.car_class,
       cs.average_position,
       cs.race_count,
       cl.country AS car_country
FROM car_stats cs
INNER JOIN class_stats clss ON clss.class = cs.car_class
INNER JOIN Classes      cl  ON cl.class   = cs.car_class
where clss.car_count_in_one_class >= 2
  and cs.average_position < clss.class_avg_position
order by cs.car_class, cs.average_position;
