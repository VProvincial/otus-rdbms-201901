-- индекс по названию продукта
ALTER TABLE ppi_position_import ADD FULLTEXT INDEX `ix_name` (ppi_name);
-- индекс по названию модели
ALTER TABLE positions_models ADD FULLTEXT INDEX `ix_name` (mod_name);
-- индекс по названию характеристики
ALTER TABLE technical_details_fields ADD FULLTEXT INDEX `ix_name` (tdf_name);