# Урок 12 - DML: вложенные запросы и представления    

## Задача:

1. Реализовать по страничную выдачу каталога товаров.
2. Перестроить демонстрацию иерархии категорий с помощью рекурсивного CTE

Критерии оценки:   
4 - сделано только представление с запросом из предыдущего ДЗ  
5 - решена задача с предоставлением ограниченного доступа 

#### Решения:      
      
1. Реализовать по страничную выдачу каталога товаров по 10 товаров

        SELECT P.ProductID                                                 as id,
               P.Name                                                      AS Product,
               PM.Name                                                     AS Model,
               (select PLP.ListPrice
                from productlistpricehistory PLP
                  where P.ProductID = PLP.ProductID
                       and PLP.ListPrice IS NOT NULL
                       and PLP.StartDate <= '2003-01-30 00:00:00'
                       and PLP.EndDate >= '2003-01-30 00:00:00')           as Price,
               (select CONCAT(PC.Name, '/', PSC.Name)
                FROM productsubcategory AS PSC
                       JOIN productcategory AS PC ON PC.ProductCategoryID = PSC.ProductCategoryID
                  where PSC.ProductSubcategoryID = P.ProductSubcategoryID) as Category
        FROM product AS P
               LEFT JOIN productmodel AS PM ON PM.ProductModelID = P.ProductModelID
          HAVING Category IS NOT NULL and Price IS NOT NULL
          ORDER BY P.ProductID
          LIMIT 10
          OFFSET 10;

2. Перестроить демонстрацию иерархии категорий с помощью рекурсивного CTE

        with recursive cte_BOM (ProductID, Name, Quantity, ProductLevel, ProductAssemblyID, Sort)  
        AS (SELECT P.ProductID, P.Name, 1, 1, 0, P.Name  
             FROM product AS P  
                    INNER JOIN  
                  billofmaterials AS BOM  
                  ON BOM.ComponentID = P.ProductID  
                    AND BOM.ProductAssemblyID IS NULL  
                    AND (BOM.EndDate IS NULL  
                      OR BOM.EndDate > current_date)
             UNION ALL
             SELECT
                  P.ProductID,
                  if (cte_BOM.ProductLevel > 0, concat(repeat('|---', cte_BOM.ProductLevel), P.Name),P.Name),
                  BOM.PerAssemblyQty,
                  cte_BOM.ProductLevel + 1,
                  cte_BOM.ProductID,
                  CONCAT (cte_BOM.Sort,'/',P.ProductID)
             FROM
                  cte_BOM
                    INNER JOIN billofmaterials AS BOM
                               ON BOM.ProductAssemblyID = cte_BOM.ProductID
                    INNER JOIN product AS P
                               ON BOM.ComponentID = P.ProductID
                                 AND (BOM.EndDate IS NULL
                                   OR BOM.EndDate > current_date)
        )
        SELECT ProductID,
               Name,
               Quantity,
               ProductLevel,
               ProductAssemblyID
        FROM cte_BOM
          ORDER BY Sort;   
    
    
#### Документация к БД AdventureWorks

Ссылка на документацию и схему данных к БД

        https://docs.microsoft.com/ru-ru/previous-versions/sql/sql-server-2008/ms124670%28v%3dsql.100%29
        https://moidulhassan.files.wordpress.com/2014/07/adventureworks2008_schema.gif

БД можно скачать отсюда 

        https://github.com/tapsey/AdventureWorksMYSQL
        https://github.com/microsoft/sql-server-samples/releases/tag/adventureworks
#### Как запускать

         docker-compose up
         docker exec -it lesson_12_mysql bash
         mysql -p          //qwer