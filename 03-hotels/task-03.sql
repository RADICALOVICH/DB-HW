WITH
hotel_category AS (
    -- Шаг 1: для каждого отеля считаем среднюю цену, категорию и её числовой ранг.
    -- Ранг (1/2/3) понадобится чтобы потом легко выбрать «приоритетную» категорию через MAX().
    SELECT h.ID_hotel,
           h.name AS hotel_name,
           CASE
               WHEN AVG(r.price) <  175 THEN 'Дешевый'
               WHEN AVG(r.price) <= 300 THEN 'Средний'
               ELSE                          'Дорогой'
           END AS category,
           CASE
               WHEN AVG(r.price) <  175 THEN 1
               WHEN AVG(r.price) <= 300 THEN 2
               ELSE                          3
           END AS category_rank
    FROM Hotel h
    INNER JOIN Room r ON r.ID_hotel = h.ID_hotel
    GROUP BY h.ID_hotel, h.name
),
customer_visits AS (
    -- Шаг 2: для каждой пары (клиент, отель) — категория этого отеля.
    -- DISTINCT убирает дубли когда клиент бронировал один отель несколько раз.
    SELECT DISTINCT
           c.ID_customer,
           c.name           AS customer_name,
           hc.hotel_name,
           hc.category_rank
    FROM Customer c
    INNER JOIN Booking b           ON b.ID_customer = c.ID_customer
    INNER JOIN Room    r           ON r.ID_room     = b.ID_room
    INNER JOIN hotel_category hc   ON hc.ID_hotel   = r.ID_hotel
)
SELECT cv.ID_customer,
       cv.customer_name AS name,
       CASE MAX(cv.category_rank)
           WHEN 1 THEN 'Дешевый'
           WHEN 2 THEN 'Средний'
           WHEN 3 THEN 'Дорогой'
       END AS preferred_hotel_type,
       STRING_AGG(DISTINCT cv.hotel_name, ',' ORDER BY cv.hotel_name) AS visited_hotels
FROM customer_visits cv
GROUP BY cv.ID_customer, cv.customer_name
ORDER BY MAX(cv.category_rank), cv.ID_customer;
