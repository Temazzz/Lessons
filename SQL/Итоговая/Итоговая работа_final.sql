1. � ����� ������� ������ ������ ���������?

select a.city 
from airports a
group by a.city
having count(a.city) > 1

-- � ������ ������� �������������� ������� airports, �.�. � ��� ������� ��� ����������, ������� ��� ����������. 
-- ����������� ����������� ������� � ������� �� ����������� � ��������� ��������� � ��������, ��� ����� 1 ���������.

2. � ����� ���������� ���� �����, ����������� ��������� � ������������ ���������� ��������?

select a.airport_name
from airports a
left join flights f on f.arrival_airport = a.airport_code 
left join aircrafts a2 on a2.aircraft_code = f.aircraft_code
where a2.aircraft_code in (select a.aircraft_code from aircrafts a
where a."range" = (
   select max(a."range")
   from aircrafts a))
group by a.airport_name

-- ��� �� ������ - ������� ������ ��������� � �������� �������� � ����. ���������� ������, �������� ��� ������������ (������� ������ ����).
-- ����� �� ������ ���� ������� � �����������, ������ ����� ���� ������ ������ ����� join � ������ ��� �������� ����� ���������, ������������ ��� ��������� ����������
   
select * from aircrafts a
where a."range" = (
   select max(a."range")
   from aircrafts a)

3. ������� 10 ������ � ������������ �������� �������� ������ ('limit')

select f.flight_no, max(f.actual_departure - f.scheduled_departure ) as time
from flights f 
where f.actual_departure is not null
group by f.flight_no
order by time desc
limit 10

-- �� ������ ���� ������� flights, ����� ����������� ���� ����� �������� ���������������� � ������������ ������� � ������� �� � ���������� �� ��������
-- ����� ����������� ����������� ��� ������ ������� � ������� �����. ��������� ������� ������ 10 ������ �� ����� ������.
-- ����� ������, ��� � ������� actual_departure ���� ����� ������� ������� � ����� ������� ����� ���������� ����������� where -> is not null

4. ���� �� �����, �� ������� �� ���� �������� ���������� ������?

select b.book_ref 
from bookings b
left join tickets t on b.book_ref = t.book_ref 
left join boarding_passes bp on bp.ticket_no = t.ticket_no 
where bp.boarding_no is null 

5.������� ��������� ����� ��� ������� �����, �� % ��������� � ������ ���������� ���� � ��������.
�������� ������� � ������������� ������ - ��������� ���������� ���������� ���������� �� ��������� �� ����.

SELECT 
	f.flight_no, 
	f.aircraft_code,
	ac.seats_count - COUNT(f.aircraft_code) free_places, 
	round(((ac.seats_count - COUNT(f.aircraft_code))/ ac.seats_count::numeric) * 100, 2) percentage,
	SUM(COUNT (f.flight_id)) OVER(PARTITION BY f.departure_airport, f.actual_departure
			ORDER BY f.actual_departure 
			ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) sum_1
FROM flights f
LEFT JOIN ticket_flights tf USING(flight_id)
LEFT JOIN boarding_passes bp USING(ticket_no,flight_id)
LEFT JOIN (SELECT s.aircraft_code, COUNT(s.aircraft_code) seats_count FROM seats s GROUP BY aircraft_code) ac USING(aircraft_code)
GROUP BY 
	f.aircraft_code, 
	f.flight_no, 
	f.flight_id, 
	ac.seats_count
HAVING (ac.seats_count - COUNT (f.aircraft_code)) > 0 AND f.actual_departure IS NOT NULL 
ORDER BY free_places DESC

6. ������� ���������� ����������� ��������� �� ����� ��������� �� ������ ����������.

select f.aircraft_code, a.model, ROUND(100.0 * COUNT(f.flight_id) / (SELECT COUNT(f.flight_id) FROM flights f), 2) percentage
from flights f
left join aircrafts a using (aircraft_code)
group by f.aircraft_code, a.model
	
7. ���� �� ������, � ������� ����� ��������� ������ - ������� �������, ��� ������-������� � ������ ��������?

with prices as (
select
	f.flight_id,
	tf.fare_conditions,
	tf.amount
from flights f
left join ticket_flights tf using(flight_id)
group by
	f.flight_id,
	tf.fare_conditions,
	tf.amount
having
	tf.fare_conditions != 'Comfort')
SELECT
	b.flight_id,
	b.amount AS business_price,
	e.amount AS economy_price
FROM (SELECT * FROM prices WHERE fare_conditions = 'Business') b
LEFT JOIN (SELECT * FROM prices WHERE fare_conditions = 'Economy') e USING(flight_id)
WHERE b.amount < e.amount

8. ����� ������ �������� ��� ������ ������?

CREATE VIEW departure_city AS (
	SELECT DISTINCT city departure_city
	FROM flights f
	LEFT JOIN airports a ON f.departure_airport = a.airport_code);

CREATE VIEW arrival_city AS (
	SELECT DISTINCT city arrival_city
	FROM flights f
	LEFT JOIN airports a ON f.arrival_airport = a.airport_code);

WITH not_direct_flights AS (
	SELECT CONCAT(departure_city, '-', arrival_city) AS possible_flights
	FROM (
		SELECT * FROM departure_city dc, arrival_city arc
		WHERE dc.departure_city != arc.arrival_city) all_possible_flights
	EXCEPT
	SELECT CONCAT (departure_city, '-', arrival_city) AS existing_flights
FROM (
	SELECT DISTINCT
		dep_a.city departure_city,
		arr_a.city arrival_city
	FROM flights f
	LEFT JOIN airports dep_a ON f.departure_airport = dep_a.airport_code
	LEFT JOIN airports arr_a ON f.arrival_airport = arr_a.airport_code
	ORDER BY dep_a.city) existing_flights)
SELECT * FROM not_direct_flights
ORDER BY possible_flights;

9. ��������� ���������� ����� �����������, ���������� ������� �������, 
�������� � ���������� ������������ ���������� ��������� � ���������, ������������� ��� �����

WITH distance AS (
WITH coordinates AS (
SELECT
	dep_air,
	dep_name,
	arr_air,
	arr_name,
	air_cod,
	lat_a,
	long_a,
	latitude lat_b,
	longitude long_b
FROM
	(
	SELECT
		r.departure_airport dep_air,
		r.departure_airport_name dep_name,
		r.arrival_airport arr_air,
		r.arrival_airport_name arr_name,
		r.aircraft_code air_cod,
		a.latitude lat_a,
		a.longitude long_a
	FROM
		routes r
	LEFT JOIN bookings.airports a ON r.departure_airport = a.airport_code) coor
LEFT JOIN airports a2 ON coor.arr_air = a2.airport_code)
SELECT 
	dep_air,
	dep_name,
	arr_air,
	arr_name,
	model,  
	ROUND((acos(sin(radians(lat_a))*sin(radians(lat_b))+cos(radians(lat_a))*cos(radians(lat_b))*cos(radians(long_b - long_a))) * 6371)::numeric, 1) distance_km,
	"range"
FROM coordinates
LEFT JOIN aircrafts ac ON coordinates.air_cod = ac.aircraft_code)
SELECT *,
	(CASE 
		WHEN "range" - distance_km > 100 THEN 'Enough'
		WHEN "range" - distance_km <= 100 AND "range" - distance_km > 0 THEN 'Almost enough'
		WHEN "range" - distance_km <= 0 THEN 'Not Enough'
	END) coverage
FROM distance
ORDER BY distance_km DESC