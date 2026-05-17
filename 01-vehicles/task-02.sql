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