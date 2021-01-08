выведите магазины, имеющие больше 300-от покупателей


select store_id, count (c.customer_id) as customer_sum 
from customer c
group by store_id
having count (c.customer_id) > 300


выведите ‘»ќ сотрудников и города магазинов, 
имеющих больше 300-от покупателей

select 
	s.store_id, c.city, concat (s2.first_name, ' ' ,s2.last_name) as name_staff
from store s 
left join address a on a.address_id = s.address_id 
left join city c on c.city_id = a.city_id 
left join staff s2 on s2.staff_id = s.manager_staff_id
left join customer c2 on c2.address_id = a.address_id 
where s.store_id in (select store_id 
from customer c
group by store_id
having count (c.customer_id) > 300)
 

выведите у каждого покупател€ город в котором он живет

select concat(c.first_name, ' ' , c.last_name) as "CustomerName", c2.city as "City" 
from customer c 
left join address a on a.address_id = c.address_id 
left join city c2 on c2.city_id = a.city_id 

выведите количество актеров, снимавшихс€ в фильмах, которые сдаютс€ в аренду за 2,99

select title, concat(a2.first_name, ' ' , a2.last_name) as actor
from film f 
left join film_actor fa on fa.film_id = f.film_id 
left join actor a2 on a2.actor_id = fa.actor_id 
where f.rental_rate = 2.99
order by f.title asc 
	
	
select 
	count(fa.actor_id ) as "SumActor" 
from film_actor fa 
	left join film f on f.film_id =fa.film_id 
	left join actor a2 on a2.actor_id = fa.actor_id 
group by f.rental_rate
having f.rental_rate = 2.99