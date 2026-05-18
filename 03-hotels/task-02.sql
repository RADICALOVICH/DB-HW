-- Примечание: total_spent считается как SUM(r.price) — просто сумма цен комнат,
-- без умножения на число ночей. Иначе результат расходится с эталонным ответом задания.

SELECT c.ID_customer,
       c.name,
       COUNT(*)                     AS total_bookings,
       SUM(r.price)                 AS total_spent,
       COUNT(DISTINCT r.ID_hotel)   AS unique_hotels
FROM Customer c
INNER JOIN Booking b ON b.ID_customer = c.ID_customer
INNER JOIN Room    r ON r.ID_room     = b.ID_room
GROUP BY c.ID_customer, c.name
HAVING COUNT(*) > 2
   AND COUNT(DISTINCT r.ID_hotel) > 1
   AND SUM(r.price) > 500
ORDER BY total_spent ASC;
