use afisha;

-- SET NAMES 'utf8';
-- SET CHARACTER SET utf8;
-- SET character_set_client = 'utf8';
-- ----------------------------------------------
-- 1. Запросы на вставку данных INSERT VALUES
-- ----------------------------------------------
INSERT INTO client (balance, name) VALUES (0,'Ivan');
INSERT INTO client (balance, name) VALUES (0,'Sasha');
INSERT INTO client (balance, name) VALUES
(100,'Вася'),
(1000,'Alexandr'),
(10000,'Pavel');

INSERT INTO booking_status (name, description,sort) VALUES
('new','',1),
('payed','',2),
('cancel','',3),
('completed','',4);

INSERT INTO company (active, name) VALUES
(1,'Pioner'),
(1,'Smena'),
(1,'Glodus');

INSERT INTO film (name, year) VALUES
('Spider-Man: Far From Home', 2019),
('Avengers: Endgame', 2019);

INSERT INTO hall (id_company, name) VALUES
(1, 'main'),
(2, 'main'),
(3, 'main'),
(3, '3D small hall');

INSERT INTO seans (id_film, id_hall, start_at, price) VALUES
(1, 1, '2019-07-10 10:00', 500),
(1, 2, '2019-07-10 12:00', 700);

INSERT INTO booking (id_client, id_seans, id_status, insert_at, ticket, price) VALUES
(1, 1,1, '2019-07-9 10:00','tcsdbmsw', 500),
(2, 2,3, '2019-07-8 12:00','treqe09w', 700);
-- SELECT cl.id, sn.id, 1, '2019-07-9 10:00', 'tcsdbmsw', sn.price
-- FROM client cl, seans sn WHERE sn.id = 1 AND cl.id = 1;




-- ----------------------------------------------
-- 2. Запросы на insert с использованием Select
-- ----------------------------------------------
DROP TABLE IF EXISTS client_with_money;
CREATE TEMPORARY TABLE client_with_money LIKE client;
INSERT INTO client_with_money (balance, name) SELECT balance, name FROM client WHERE balance > 0;

-- ----------------------------------------------
-- 3. Изменение данных UPDATE, UPDATE с использованием JOIN
-- ----------------------------------------------
UPDATE client SET balance = balance + 100 WHERE balance <= 0;

-- ----------------------------------------------
-- 4. Delete
-- ----------------------------------------------
DELETE booking
FROM booking
INNER JOIN booking_status ON booking_status.id = booking.id_status
WHERE booking_status.name = 'cancel';

-- ----------------------------------------------
-- 5. Процедура со вставкой и обновлением блока
-- ----------------------------------------------
CREATE PROCEDURE upsert()
INSERT INTO seans (id_film, id_hall, start_at, price) VALUES
(1, 1, '2019-07-10 10:00', 500)
-- обновим ценик, вместо добавления нового записи дубликата
ON DUPLICATE KEY UPDATE price=500;

-- ----------------------------------------------
-- 6. Merge – потренироваться и прочувствовать
-- ----------------------------------------------
call upsert();