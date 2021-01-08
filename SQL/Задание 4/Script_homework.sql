Основная часть:
Спроектируйте базу данных для следующих сущностей:
-язык (в смысле английский, французский и тп)
-народность (в смысле славяне, англосаксы и тп)
-страны (в смысле Россия, Германия и тп)

Правила следующие:
-на одном языке может говорить несколько народностей
-одна народность может входить в несколько стран
-каждая страна может состоять из нескольких народностей

create schema homework

create table language (
language_id serial primary key,
name varchar (30) unique not null)

insert into "language" ("name")
values 
	('English'),
	('French'),
	('Russian'),
	('German'),
	('Japanese'),
	('Italian')
	
ALTER TABLE "language" ADD last_update timestamp NOT NULL DEFAULT now()
	
select *
from "language" l 

create table nation (
nation_id serial primary key,
name varchar (30) unique not null)

insert into "nation" ("name")
values 
	('Slavs'),
	('Romans'),
	('Germans'),
	('Saxons'),
	('Celts'),
	('Balts'),
	('Iranians'),
	('Illyrians')

ALTER TABLE "nation" ADD last_update timestamp NOT NULL DEFAULT now()
	
select * from nation

create table country (
country_id serial primary key,
name varchar (30) unique not null)

insert into "country" ("name")
values 
	('Austria'),
	('United Kingdom'),
	('Germany'),
	('France'),
	('Russia'),
	('Czech Republic'),
	('Ukraine'),
	('Belorussia'),
	('Finland'),
	('Latvia'),
	('Spain'),
	('Italy'),
	('Portugal'),
	('Serbia'),
	('Greece')

ALTER TABLE "country" ADD last_update timestamp NOT NULL DEFAULT now()
	
select * from country

create table country_nation (
	country_id int NOT NULL,
	nation_id int NOT NULL,
	CONSTRAINT country_nation_pkey PRIMARY KEY (country_id, nation_id),
	CONSTRAINT country_nation_country_id_fkey FOREIGN KEY (country_id) REFERENCES country(country_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT country_nation_nation_id_fkey FOREIGN KEY (nation_id) REFERENCES nation(nation_id) ON UPDATE CASCADE ON DELETE restrict)

select * from country_nation


create table language_nation (
	language_id int2 NOT NULL,
	nation_id int2 NOT NULL,
	CONSTRAINT language_nation_pkey PRIMARY KEY (language_id, nation_id),
	CONSTRAINT language_nation_language_id_fkey FOREIGN KEY (language_id) REFERENCES language(language_id) ON UPDATE CASCADE ON DELETE RESTRICT,
	CONSTRAINT language_nation_nation_id_fkey FOREIGN KEY (nation_id) REFERENCES nation(nation_id) ON UPDATE CASCADE ON DELETE restrict)

select * from language_nation	





create table country_nation ()

drop table country_nation 

alter table country_nation add constraint nation_id foreign key (nation_id) references nation (nation_id)
