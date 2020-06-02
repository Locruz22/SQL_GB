#Практическое задание по теме “Транзакции, переменные, представления”

# 1. В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. Переместите запись id = 1 
# из таблицы shop.users в таблицу sample.users. Используйте транзакции.

START TRANSACTION;
  INSERT INTO sample.users SELECT * FROM shop.users WHERE id = 1;
  DELETE FROM shop.users WHERE id = 1 LIMIT 1;
COMMIT;


# 2. Создайте представление, которое выводит название name товарной позиции из таблицы products и соответствующее название каталога name из таблицы catalogs.

CREATE OR REPLACE VIEW show_product_name (prod_name, cat_name) AS 
  SELECT 
    products.name, catalogs.name 
  FROM 
    products, catalogs;

SELECT * FROM show_product_name;

----------------------------------------------------------------------------------------------------------------------------------------


# Практическое задание по теме “Администрирование MySQL” (эта тема изучается по вашему желанию)

# 1. Создайте двух пользователей которые имеют доступ к базе данных shop. Первому пользователю shop_read должны быть доступны 
# только запросы на чтение данных, второму пользователю shop — любые операции в пределах базы данных shop.

CREATE USER 'shop_read'@'localhost';
GRANT SELECT, SHOW VIEW ON *.* TO 'shop_read'@'localhost'; 				-- только запросы на чтение данных
FLUSH PRIVILEGES;

CREATE USER 'shop'@'localhost';
GRANT ALL ON shop.* TO 'shop'@'localhost';					  			-- любые операции в пределах базы данных shop.
FLUSH PRIVILEGES;



# 2. (по желанию) Пусть имеется таблица accounts содержащая три столбца id, name, password, содержащие первичный ключ, имя 
# пользователя и его пароль. Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name. 
# Создайте пользователя user_read, который бы не имел доступа к таблице accounts, однако, мог бы извлекать записи из представления username.

CREATE TABLE accounts (
  id INT UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(250) NOT NULL,
  `password` VARCHAR(40) NOT NULL
);

INSERT INTO accounts (name, `password`) VALUES
  ('Banny', 'dfddf44442'),
  ('Ivan', '4949ffs349'),
  ('Nick', 'A381co54M2'),
  ('Nancy', 'Nodod3340O'),
  ('Stive', 'qwerty6543'),
  ('Mikki', '65447dse44'),
  ('Sonya', '987654HO3d');
  
SELECT * FROM accounts;

CREATE VIEW username AS SELECT id, name FROM accounts;

SELECT * FROM username;

CREATE USER 'user_read'@'localhost';
GRANT SELECT (id,name) ON shop.username TO 'user_read'@'localhost';
FLUSH PRIVILEGES;


----------------------------------------------------------------------------------------------------------------------------------------

#Практическое задание по теме “Хранимые процедуры и функции, триггеры"


# 1 - Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
# С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
# с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".


DROP FUNCTION IF EXISTS hello;

DELIMITER //

CREATE FUNCTION hello()
RETURNS VARCHAR(255) NO SQL
BEGIN
	DECLARE hour INT;
    SET hour = HOUR(NOW());
    CASE
      WHEN hour BETWEEN 0 AND 5
        RETURN 'Доброй ночи!';
      WHEN hour BETWEEN 6 AND 11
        RETURN 'Доброе утро!';
      WHEN hour BETWEEN 12 AND 17
        RETURN 'Добрый день!';
      WHEN hour BETWEEN 18 AND 23
        RETURN 'Добрый вечер!';
    END CASE; 
END//

SELECT HOUR(NOW());
SELECT hello();


# 2 - В таблице products есть два текстовых поля: name с названием товара и description с его описанием. 
# Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема. 
# Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. При попытке присвоить полям NULL-значение 
# необходимо отменить операцию.


SELECT * FROM products;

DELIMITER //

CREATE TRIGGER name_description_notnull_trigger_add 
BEFORE INSERT ON products
FOR EACH ROW 
BEGIN
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
    SIGNAL SQLSTATE '2222 Error'
    SET MESSAGE_TEXT = 'Оба значения NULL';
  END IF;
END//

CREATE TRIGGER name_description_notnull_trigger_update  
BEFORE UPDATE ON products
FOR EACH ROW
  IF NEW.name IS NULL AND NEW.description IS NULL THEN
    SIGNAL SQLSTATE '333 Error'
    SET MESSAGE_TEXT = 'Оба значения NULL';
  END IF;
END//


INSERT INTO products (name, description, product_catalog_id, total)
VALUES
  (NULL, NULL, 1, 19),
  ('ASUS VA24EHE 23.8','D-SUB (VGA), DVI, HDMI', 7, 3)//





