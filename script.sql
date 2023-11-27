-- удаляем лишние столбцы
ALTER TABLE test_db.vacancies 
  DROP COLUMN Professional_roles, 
  DROP COLUMN Specializations, 
  DROP COLUMN Profarea_names;

-- Разбиваем таблицу с кучей вакансий на нескольких витрин по местоположению, чтобы не нагружать одну таблицу. 
-- Внимательно выбирайте и обосновывайте выбор движка.
select distinct(Area) from test_db.vacancies;
-- видим всего два города: Мск и Питер
-- создадим соответствующие витрины
-- материализованную вьюху создать не удалось, поэтому создал обычную и вопрос в движке отпал.
create view test_db.msc_view
as select * from test_db.vacancies
Where Area = 'Москва'

create view test_db.spb_view
as select * from test_db.vacancies
Where Area = 'Санкт-Петербург'


-- удаляем вакансии, где не указана ЗП
alter table test_db.vacancies delete
where Salary = False

-- Напишите код для извлечения информации о средней заработной плате вакансий и местоположении, где вакансии наиболее распространены. Выведите это все в один отчет
Select Area, AVG((From + To)/2) as avarage_salary, avg(From) as avarage_from, AVG(To) as avarage_to, count(*) as count_vacancies
from test_db.vacancies
group by Area

-- еще можно по самим вакансиям глянуть
Select Area, Name, AVG((From + To)/2) as avarage_salary, avg(From) as avarage_from, AVG(To) as avarage_to, count(*) as count_vacancies
from test_db.vacancies
group by Area, Name
order by avarage_to desc