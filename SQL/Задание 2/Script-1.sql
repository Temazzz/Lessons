select *
from customer
	where active = 1 

select
	f.title,
	f.release_year 
from film f 
	where release_year = '2006'

select 
	f.film_id, f.title, f.rental_duration / f.rental_rate as cost_per_day
from film f
order by cost_per_day desc 

select p.payment_id, p.rental_id, p.payment_date, p.amount 
from payment p 
order by p.payment_date desc 
limit 10





















select *
from information_schema.table_constraints tc


















