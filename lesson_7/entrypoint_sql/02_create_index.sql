CREATE INDEX filter_ix ON booking (id_status, id_seans, id_client, insert_at) COMMENT "Различные варианты поиск купленных билетов в зависимости от статуса брони, id сеанса, id клиента";
CREATE UNIQUE INDEX seans_ix ON seans (id_film, id_hall, start_at) COMMENT "Уникальный естественный ключ сеанса кино";
