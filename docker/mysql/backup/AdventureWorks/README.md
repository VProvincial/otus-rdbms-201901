# Бэкап БД AdventureWorks от Microsoft для mysql    

#### Документация к БД AdventureWorks

Ссылка на документацию и схему данных к БД

        https://docs.microsoft.com/ru-ru/previous-versions/sql/sql-server-2008/ms124670%28v%3dsql.100%29
        https://moidulhassan.files.wordpress.com/2014/07/adventureworks2008_schema.gif

БД можно скачать отсюда 

        https://github.com/tapsey/AdventureWorksMYSQL
        https://github.com/microsoft/sql-server-samples/releases/tag/adventureworks
        
#### Как запускать

Добавим символическую ссылку на бэкап, либо загрузим файл AdventureWorks.sql в папку lesson_12/entrypoint_sql/

         ln -s ../../docker/mysql/backup/AdventureWorks/AdventureWorks.sql 
Запустим докер

         docker-compose up
         docker exec -it aw_mysql bash
         mysql -p          //qwer