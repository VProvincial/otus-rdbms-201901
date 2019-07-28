# Урок 10 - DML: выборка данных   

## Задача:

Отрисовка списка продуктов с указанием всех уровней категории (например Бытовая техника/холодильники)
и списком параметров в JSON или XML по определенным условием ( например все двухкамерные холодильники)

Запрос должен. включать в себя 1 или несколько JOIN и условия WHERE

#### Решение:
Запросы реализованы на основе БД AdventureWorks2008

    -- Вывод продукта, его модели и структура раздела/подраздела(одноуровневая), для продукта Hitch Rack - 4-Bike модель=null
    SELECT P.Name                         AS Product,
         PM.Name                        AS Model,
         CONCAT(PC.Name, '/', PSC.Name) as Category
    FROM product AS P
         LEFT JOIN productmodel AS PM ON PM.ProductModelID = P.ProductModelID
         LEFT JOIN productsubcategory AS PSC ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
         JOIN productcategory AS PC ON PC.ProductCategoryID = PSC.ProductCategoryID
    ORDER BY PC.Name, PSC.Name;
  
    -- Собрать все подкатегории корневого раздела через запятую
    SELECT PC.Name                              AS Category,
         GROUP_CONCAT(PSC.Name SEPARATOR '/') as AllSubCategories
    FROM productcategory AS PC
         INNER JOIN productsubcategory AS PSC ON PSC.ProductCategoryID = PC.ProductCategoryID
    GROUP BY PSC.ProductCategoryID;
  
    -- Собрать продукты без категории
    SELECT P.Name   AS Product,
         PSC.Name as SubCategory
    FROM product AS P
         LEFT JOIN productsubcategory AS PSC ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
    WHERE P.ProductSubcategoryID is null;
      
    -- Собрать продукты нужной категории
    SELECT P.Name   AS Product,
         PSC.Name as SubCategory
    FROM product AS P
         LEFT JOIN productsubcategory AS PSC ON PSC.ProductSubcategoryID = P.ProductSubcategoryID
         JOIN productcategory AS PC ON PC.ProductCategoryID = PSC.ProductCategoryID
    WHERE PC.Name = 'Clothing'
    
    -- Актульные цена товара на 2003-01-30 00:00:00 
    select P.ProductID, P.Name, PLP.ListPrice
    from product P
           left join productlistpricehistory PLP on
      (P.ProductID = PLP.ProductID and PLP.StartDate <= '2003-01-30 00:00:00' and PLP.EndDate >= '2003-01-30 00:00:00');

#### Документация к БД AdventureWorks

Ссылка на документацию и схему данных к БД

        https://docs.microsoft.com/ru-ru/previous-versions/sql/sql-server-2008/ms124670%28v%3dsql.100%29
        https://moidulhassan.files.wordpress.com/2014/07/adventureworks2008_schema.gif

БД можно скачать отсюда 

        https://github.com/tapsey/AdventureWorksMYSQL - бэкап
        https://github.com/microsoft/sql-server-samples/releases/tag/adventureworks - скрипт для установки AdventureWorks-oltp-install-script.zip 20мб
         
#### Как запускать
В папку lesson_10/entrypoint_sql/ положить sql скрипт с бэкапом

         docker-compose up
         docker exec -it lesson_10_mysql bash
         mysql -p          //qwer