SELECT c.name,
       c.email,
       c.phone,
       COUNT(*) AS booking_per_customer,
       STRING_AGG(DISTINCT h.name, ', ' ORDER BY h.name) AS hotel_list,
       AVG(b.check_out_date - b.check_in_date) AS avg_stay
FROM Customer c
INNER JOIN Booking b ON b.ID_customer = c.ID_customer
INNER JOIN Room  r ON r.ID_room  = b.ID_room
INNER JOIN Hotel h ON h.ID_hotel = r.ID_hotel
GROUP BY c.ID_customer, c.name, c.email, c.phone
HAVING COUNT(*) > 2
   AND COUNT(DISTINCT h.ID_hotel) > 1
ORDER BY booking_per_customer DESC;
