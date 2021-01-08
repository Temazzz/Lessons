Основная часть:

1.Сделайте запрос к таблице rental. Используя оконую функцию добавьте колонку с порядковым номером 
аренды для каждого пользователя (сортировать по rental_date)
    
select r.customer_id, row_number() over (partition by r.customer_id order by r.rental_date asc) as number, rental_date
from rental r  



    
2.Для каждого пользователя подсчитайте сколько он брал в аренду фильмов со специальным атрибутом Behind the Scenes
    -напишите этот запрос
    -создайте материализованное представление с этим запросом
    -обновите материализованное представление
    -напишите три варианта условия для поиска Behind the Scenes

create materialized view customer_sf as
select r.customer_id, concat(c.first_name || ' ' || c.last_name) as customer, count(f.special_features) as sum_sf
from rental r 
left join inventory i on i.inventory_id = r.inventory_id 
left join film f on f.film_id = i.film_id
left join customer c on r.customer_id = c.customer_id
where f.special_features @> array ['Behind the Scenes'] 
group by r.customer_id, c.first_name, c.last_name order by r.customer_id
with no data

refresh materialized view customer_sf

select * from customer_sf

-- варианты условия для поиска 'Behind the Scenes'

where f.special_features @> array ['Behind the Scenes']

where array_position(f.special_features, 'Behind the Scenes') is not null

where 'Behind the Scenes' = all (f.special_features)

explain analyse 
select distinct cu.first_name  || ' ' || cu.last_name as name, 
	count(ren.iid) over (partition by cu.customer_id)
from customer cu
full outer join 
	(select *, r.inventory_id as iid, inv.sf_string as sfs, r.customer_id as cid
	from rental r 
	full outer join 
		(select *, unnest(f.special_features) as sf_string
		from inventory i
		full outer join film f on f.film_id = i.film_id) as inv 
		on r.inventory_id = inv.inventory_id) as ren 
	on ren.cid = cu.customer_id 
where ren.sfs like '%Behind the Scenes%'
order by count desc