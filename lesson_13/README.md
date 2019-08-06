# Урок 13 -  DML: аналитические функции     

## Задачи:

1. Посчитайте по таблице фильмов, в вывод также должен попасть ид фильма, название, описание и год выпуска
    - пронумеруйте записи по названию фильма, так чтобы при изменении буквы алфавита нумерация начиналась заново
    - посчитайте общее количество фильмов и выведете полем в этом же запросе
    - посчитайте общее количество фильмов в зависимости от буквы начала называния фильма
    - следующий ид фильма на следующей строки
    - предыдущий ид фильма
    - названия фильма 2 строки назад
Для этой задачи не обязательно писать аналог без функций

2. Вахтер Василий очень любит кино и свою работу, а тут у него оказался под рукой ваш прокат (ну представим что действие разворачивается лет 15-20 назад)
Василий хочет посмотреть у вас все все фильмы при этом он хочет начать с самых коротких и потом уже смотреть более длинные
сделайте группы фильмов для Василия чтобы в каждой группе были разные жанры и фильмы сначала короткие, а потом более длинные
В результатах должен быть номер группы, ид фильма, название, и ид категории (жанра), продолжительность фильма.

3. По каждому работнику проката выведете последнего клиента, которому сотрудник сдал что-то в прокат
В результатах должны быть ид и фамилия сотрудника, ид и фамилия клиента, дата аренды
Для этого задания нужно написать 2 варианта получения таких данных - с аналитической функцией и без нее.

4. Нужно выбрать последний просмотренный фильм по каждому актеру 
В результатах должно быть ид актера, его имя и фамилия, ид фильма, название и дата последней аренды.
Для этого задания нужно написать 2 варианта получения таких данных - с аналитической функцией и без нее.
Данные в обоих запросах (с оконными функциями и без) должны совпадать.  

#### Решения:      
Запросы реализованы на БД Sakila - dvdrental

1. Введение в функции

        select film_id,
               title,
               LEFT(title, 1)                                   as FirstTitle,
               #пронумеруйте записи по названию фильма, так чтобы при изменении буквы алфавита нумерация начиналась заново
               ROW_NUMBER() OVER()                              as RowNumber,
               #общее количество фильмов и выведете полем в этом же запросе
               COUNT(film_id) OVER()                            as Count,
               #общее количество фильмов в зависимости от буквы начала называния фильма
               COUNT(film_id) OVER(PARTITION BY LEFT(title, 1)) as CountByTitle,
               #следующий ид фильма
               LEAD(film_id, 1) OVER()                          as FollowId,
               #предыдущий ид фильма
               LAG(film_id, 1) OVER()                           as PreviousId,
               #названия фильма 2 строки назад
               LAG(title, 2) OVER()                             as Previous2Title,
               description,
               release_year
        from film
      having FirstTitle = 'B'
      order by title
      limit 100;

2. Кинчики для Василия

        select dense_rank() over(order by c.category_id) as numberGroup,
               #fc.category_id                          as category_id,
               c.name                                    as category_name,
               f.length                                  as length,
               f.title,
               f.film_id
        from film f
               join film_category fc on f.film_id = fc.film_id
               join category c on fc.category_id = c.category_id
          order by
             c.category_id,
             length;
             
3. http://prntscr.com/oo92ms т.к. последние фильмы были выдата в одни и тоже время, 
невозможно предоставить уникальное значение по дате, 
поэтому была добавлена сортировка по id,что позволит максимально снизить шанс ошибки

    3.1. Вариант без аналитических функций
  
        with cte_staff_rental_id as (
          select s.staff_id
               , s.first_name
               , (select rental_id
                  from rental where
                       staff_id=s.staff_id
                    order by
                       rental_date desc,
                       rental_id desc
                    limit
                       1) as max_rental_id
          from staff s
        )
        select sr.first_name, r.customer_id, r.rental_date
        from cte_staff_rental_id sr
               left join rental r on r.rental_id = sr.max_rental_id;
               
    3.2. Вариант с аналитическими функций

        with cte_staff_rental as (
          select r.staff_id
               , s.first_name
               , r.rental_date
               , r.rental_id
               , r.customer_id
          from rental r
                 left join staff s on r.staff_id = s.staff_id
            order by r.rental_date desc
        )
        select distinct
            any_value(sr.first_name)                                                                as first_name
          , first_value(sr.rental_date) over(partition by sr.staff_id order by sr.rental_date desc) as max_rental_date
          , first_value(sr.customer_id) over(partition by sr.staff_id order by sr.rental_date desc,sr.rental_id desc) as custumer_id
        from cte_staff_rental sr;    
    
    4.1 Без аналитических функций

        select concat('[', a.actor_id, ']', a.last_name, ' ', left(a.first_name, 1), '.') as actor
             , concat('[', f.film_id, '] ', f.title)                                      as film
             , r.rental_date
        from film f
               left join film_actor fa on f.film_id = fa.film_id
               left join actor a on fa.actor_id = a.actor_id
               join (select i.film_id, max(r.rental_date) as rental_date
                     from rental r,
                          inventory i
                     where r.inventory_id = i.inventory_id
                     group by i.film_id) r on r.film_id = f.film_id;
          
    4.2 С аналитическими функций

        with cte_actor_rental as (
          select f.film_id
               , fa.actor_id
               , r.inventory_id
               , r.rental_date
               , r.rental_id
               , f.title
          from rental r
                 left join inventory i on i.inventory_id = r.inventory_id
                 left join film f on i.film_id = f.film_id
                 left join film_actor fa on f.film_id = fa.film_id
          order by r.rental_date desc
        )
        select distinct concat('[', a.actor_id, ']', a.last_name, ' ', left(a.first_name, 1), '.') as actor
                      , concat('[', ar.film_id, '] ', ar.title)
                      , first_value(ar.rental_date) over(partition by ar.actor_id
                                    order by ar.rental_date desc)                                  as max_rental_date
        from cte_actor_rental ar
               left join actor a on a.actor_id = ar.actor_id;
               
#### Как запускать

         docker-compose up
         docker exec -it lesson_13_mysql bash
         mysql -p          //qwer