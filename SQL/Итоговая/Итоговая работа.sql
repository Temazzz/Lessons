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

-- � ����� ������� �������� ��������, �.�. �� ���� ����� �������� ������������ ������� �� ������ �����.
-- + ���� SQL ������������ � ������ Python � ����� ��������� � ��-�� ���������� ������������ ���-�� ������� ��-�� ����� ������ ���� ������ � �� ��������� �� ������ �����.
-- �����, ��� � ������� � SQL � ���������� ��������� �������, �� ��� ����� �����. �����? ������� �� ����.



