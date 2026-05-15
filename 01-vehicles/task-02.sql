-- Задача 2 (3 балла)
-- Объединить в один результат три выборки:
--
-- 1) Cars:        horsepower > 150 AND engine_capacity < 3   AND price < 35000
--    →  maker, model, horsepower, engine_capacity, 'Car'
--
-- 2) Motorcycles: horsepower > 150 AND engine_capacity < 1.5 AND price < 20000
--    →  maker, model, horsepower, engine_capacity, 'Motorcycle'
--
-- 3) Bicycles:    gear_count > 18  AND price < 4000
--    →  maker, model, NULL, NULL, 'Bicycle'
--
-- Сортировать по horsepower DESC, велосипеды (NULL) — внизу.
--
-- Ожидаемый вывод:
--   maker  | model  | horsepower | engine_capacity | vehicle_type
--   -------+--------+------------+-----------------+--------------
--   Toyota | Camry  |        203 |            2.50 | Car
--   Yamaha | YZF-R1 |        200 |            1.00 | Motorcycle
--   Honda  | Civic  |        158 |            2.00 | Car
--   Trek   | Domane |     [NULL] |          [NULL] | Bicycle
--   Giant  | Defy   |     [NULL] |          [NULL] | Bicycle

SELECT v.maker, v.model, c.horsepower, c.engine_capacity, v.type AS vehicle_type
FROM Vehicle v
INNER JOIN Car c ON c.model = v.model
WHERE c.horsepower > 150
  AND c.engine_capacity < 3
  AND c.price < 35000

UNION ALL

SELECT v.maker, v.model, m.horsepower, m.engine_capacity, v.type
FROM Vehicle v
INNER JOIN Motorcycle m ON m.model = v.model
WHERE m.horsepower > 150
  AND m.engine_capacity < 1.5
  AND m.price < 20000

UNION ALL

SELECT v.maker, v.model, NULL::INT, NULL::DECIMAL(4, 2), v.type
FROM Vehicle v
INNER JOIN Bicycle b ON b.model = v.model
WHERE b.gear_count > 18
  AND b.price < 4000

ORDER BY horsepower DESC NULLS LAST;