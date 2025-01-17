
# Урок 3 -  Транзакции. ACID

## Задача:

Описать логику транзакций.
Описать транзакцию псевдокодом, которая будет включать в себя несколько действий и исключать возможность взаимных блокировок и неоднозначных ситуаций


#### Описание:
Бронирование билета в кинотеатр с внутренненго счета юзера в системе.

#### Особенности:
- Система бронирования должна учитывать офлайн продажи в кинотеатре. 
Да, такой кейс маловероятен, добавил специально, чтобы для усложнить пример.
- При любых проблемах с бронью клиент должен иметь возможность отменить ее и вернуть деньги обратно на баланс в системе

#### Этапы:
- Создать бронь на клиента со статусом "new"=1
- Списание средств с внутреннего счета клиента
- Перевод брони в статус "payed"=2 // оплачен но не забронирован в кинотеатре
- Через внешний API(звонок) подтвердить факт бронирования билета в кинотеатре
- Если ошибок нет, то переводим бронь в статус "completed"=0 //завершен
- Если есть ошибки, например место было забронировано ранее в офлайне или сеанс был отменен именно в момент продажи, 
то возвращаем деньги обратно на баланс и переводим бронь в статус "cancel:system"=3//отменен системой бронирования 

#### SQL:
    SET autocommit = 0 //т.к. если автокоммит будет включен, то лок строки автоматом будет снят после ее обновления
    INSERT INTO booking(id_seans, insert_at, id_status, ticket, id_client) SET VALUES(@SEANS_ID, NOW(), 1, @TICKET, @CLIENT_ID);
    start transaction;
    SELECT balance FROM client WHERE id = @CLIENT_ID FOR UPDATE;
    UPDATE client SET balance=@NEW_BALANCE WHERE id=@CLIENT_ID;
    UPDATE booking SET id_status=2 where id=@BOOKING_ID;
    commit;//сняли с юзера деньги и сменили статус на "Оплачен", но по факту еще не забронировали место за ним 
    
    /* процесс подтверждения брони приложением/менеджером и тп */
    
    UPDATE booking SET id_status=0 where id=@BOOKING_ID;//бронь успешно заверешена

#### PS:
Обновленная модель данных с клиентами и статусами брони - /lesson_3/model_with_client_v2006.pdf
Новый бэкап БД - /docker/mysql/backup/backup_06_20.sql 
