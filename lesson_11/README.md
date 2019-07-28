# Урок 11 - DML: агрегация и сортировка    

## Задача:

Создаем отчетную выборку.  
Построить статистический запрос и показать группировку по странам (по каждому коду необходимо вычислить страну и сгруппировать по стране)
- по суммарному времени
- по кол-ву звонков
- по кол-ву нулевых звонков

Должны быть представлены 3 SQL  
\* Использовать RollUP для развернутого отчета по странам и направлений внутри стран

- можно использовать свою БД и предоставить следующий результат
- база с данными в докере
- группировки с ипользованием CASE, HAVING, ROLLUP, GROUPING SET
например для магазина к предыдущему списку продуктов добавить максимальную и минимальную цену и кол-во предложений
также сделать выборку показывающую самый дорогой и самый дешевый товар в каждой категории
сделать rollup для оценки продаж по категориям товаров

#### Решения:  
Кол-во товара без цены на 2003-01-30 00:00:00 для каждого подраздела
  
    select PSC.Name           as Category
         , count(P.ProductID) as CountNullPrice
    from product P
           left join productlistpricehistory PLP on
      -- фильтр п дате сразу даст акутальную позицию с ценей если есть, не передавая этот фильтр для цены в wherr
      (P.ProductID = PLP.ProductID and PLP.StartDate <= '2003-01-30 00:00:00' and PLP.EndDate >= '2003-01-30 00:00:00')
      -- inner join даст только те товары которые привязаны к разделам
           join productsubcategory PSC on
      P.ProductSubcategoryID = PSC.ProductSubcategoryID
    where PLP.ListPrice is null
    GROUP BY PSC.ProductSubcategoryID;
    
      
Кол-во товаров в подразделе и подразделах

    select ifnull(PC.Name, 'AllCategory')     as Category
         , ifnull(PSC.Name, 'AllSubCategory') as SubCategory
         #           , CASE GROUPING(PC.Name) when 1 then 'AllCategory' else PSC.Name end as SubCategory
         #           , max(PLP.ListPrice) as MaxPrice
         , count(P.ProductID)                 as CountProduct
    from productcategory PC
           join productsubcategory PSC
                on PC.ProductCategoryID = PSC.ProductCategoryID
           join product P on P.ProductSubcategoryID = PSC.ProductSubcategoryID
         # where PLP.ListPrice is null
    GROUP BY PC.Name, PSC.Name
    WITH ROLLUP;   
    
Самый дорогой и самый дешевый товар в подкатегории

    -- Как вывести именно товар а не макс/мин цена из группировки? реально ли так сделать?
    select PSC.Name           as SubCategory
         , max(PLP.ListPrice) as MaxPrice
         , min(PLP.ListPrice) as MinPrice
    from productsubcategory PSC
           join product P on P.ProductSubcategoryID = PSC.ProductSubcategoryID
           join productlistpricehistory PLP on P.ProductID = PLP.ProductID
    GROUP BY PSC.Name;
    
#### Документация к БД AdventureWorks

Ссылка на документацию и схему данных к БД

        https://docs.microsoft.com/ru-ru/previous-versions/sql/sql-server-2008/ms124670%28v%3dsql.100%29
        https://moidulhassan.files.wordpress.com/2014/07/adventureworks2008_schema.gif

БД можно скачать отсюда 

        https://github.com/tapsey/AdventureWorksMYSQL
        https://github.com/microsoft/sql-server-samples/releases/tag/adventureworks
#### Как запускать
В папку lesson_11/entrypoint_sql/ положить sql скрипт с бэкапом

         docker-compose up
         docker exec -it lesson_11_mysql bash
         mysql -p          //qwer