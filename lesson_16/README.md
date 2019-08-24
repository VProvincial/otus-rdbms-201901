# Урок 16 -  Индексы     

## Задача:

Сделать полнотекстовый индекс, который ищет по свойствам, названию товара и названию модели

## Решение:      

Добавим индексы (есть в файле entrypoint_sql/02_add_fulltext.sql)

        -- индекс по названию продукта
        ALTER TABLE ppi_position_import ADD FULLTEXT INDEX `ix_name` (ppi_name);
        -- индекс по названию модели
        ALTER TABLE positions_models ADD FULLTEXT INDEX `ix_name` (mod_name);
        -- индекс по названию характеристики
        ALTER TABLE technical_details_fields ADD FULLTEXT INDEX `ix_name` (tdf_name);

Запишем в системную переменную текст запроса

        -- ppi_name & mod_name
        set @sSearch = 'опрыскиватель challenger буран'; 
        -- ppi_name
        -- set @sSearch = 'опрыскиватель';
        -- tdf_name
        -- set @sSearch = 'ширина';
        -- ppi_name
        -- set @sSearch = 'Щелерез';
        
Запрос с учетом fulltext 
        
        select pm.mod_id,
               pm.mod_name,
               ppi.ppi_name,
               ppi.ppi_description,
               tdf.tdf_name
        from positions_models pm,
             ppi_position_import ppi,
             technical_details td,
             technical_details_fields tdf
        where pm.mod_ppi_id = ppi.ppi_id
          and tdf.tdf_id = td.tch_property_id
          and td.tch_mod_id = pm.mod_id
          and match(pm.mod_name) AGAINST(@sSearch) + match(ppi.ppi_name) AGAINST(@sSearch) + match(tdf.tdf_name) AGAINST(@sSearch);

#### Как запускать

         docker-compose up
         docker exec -it lesson_16_mysql bash
         mysql -p          //qwer