# 1.Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем

CREATE DATABASE topic_5_table;
USE topic_5_table;

DROP TABLE users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100),
  created_at DATETIME,  
  updated_at DATETIME
 );

SELECT * FROM users;

INSERT INTO users (
  created_at, 
  updated_at
)
VALUES(
  NOW(),
  NOW()
);



# 2.Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR 
# и в них долгое время помещались значения в формате "20.10.2017 8:10". Необходимо преобразовать поля к типу 
# DATETIME, сохранив введеные ранее значения.


DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(150) COMMENT 'MyName',
  created_at VARCHAR(150),  
  updated_at VARCHAR(150)
 );

SELECT * FROM users;


INSERT INTO 
  users (created_at, updated_at)
VALUES
  ('01.02.2015 5:10', '21.10.2020 21:01'),
  ('01.02.2016 12:11', '21.10.2020 21:03');


UPDATE users SET 
  created_at = STR_TO_DATE(created_at,'%d.%m.%Y %k:%i'), 
  updated_at = STR_TO_DATE(updated_at,'%d.%m.%Y %k:%i');

ALTER TABLE users CHANGE created_at created_at DATETIME DEFAULT CURRENT_TIMESTAMP;
ALTER TABLE users CHANGE updated_at updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP;

DESCRIBE users;



# 3. В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 
# 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким 
# образом, чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться 
# в конце, после всех записей.


DROP TABLE IF EXISTS storehouses_products ;
CREATE TABLE storehouses_products (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(250) NOT NULL,
  value INT
);


SELECT * FROM storehouses_products;

INSERT INTO storehouses_products (name, value) VALUES
  ('processor', '0'),
  ('isolation', '2500'),
  ('cooler', '0'),
  ('videocard', '30'),
  ('headphone', '500'),
  ('keyboard', '1');
 
 SELECT value FROM storehouses_products ORDER BY value=0, value;
  

# 4. Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае. 
# Месяцы заданы в виде списка английских названий ('may', 'august')


DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100) NOT NULL,
  birthday VARCHAR(100),
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,  
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

SELECT * FROM users;

INSERT INTO users (name, birthday) VALUES
  ('Ivan', 'August'),
  ('Nico', 'April'),
  ('Poul', 'April'),
  ('Jassy', 'Augist'),
  ('Cannahan', 'May'),
  ('Maria', 'January'),
  ('Jack', 'December'),
  ('Leam', '2500'),
  ('Sopia', 'July'),
  ('Nessy', 'October'),
  ('Mannie', 'May'),
  ('Sonie', 'March');

SELECT * FROM `users` WHERE `birthday` = 'may' OR `birthday` = 'august';



# 5. Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2); 
# Отсортируйте записи в порядке, заданном в списке IN.

DROP TABLE IF EXISTS catalogs ;
CREATE TABLE catalogs ( 
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100) NOT NULL
);

INSERT INTO catalogs (name) VALUES
  ('processor'),
  ('isolation'),
  ('cooler'),
  ('videocard'),
  ('headphone'),
  ('keyboard'),
  ('monitor'),
  ('keys'),
  ('wires'),
  ('safe_system'),
  ('blocks');


SELECT * FROM catalogs;
SELECT * FROM catalogs WHERE id IN (5, 1, 2) ORDER BY FIELD(5,1,2);



# Практическое задание теме “Агрегация данных”
# 1.	Подсчитайте средний возраст пользователей в таблице users

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100) NOT NULL,
  birthday DATE
);

INSERT INTO users (name, birthday) VALUES
  ('Ivan', '1994-02-04'),
  ('Nico', '1995-02-11.'),
  ('Poul', '1965-12-12'),
  ('Jassy', '2001-01-02.'),
  ('Cannahan', '2002-05-12'),
  ('Maria', '2014-08-07'),
  ('Jack', '1999-05-04'),
  ('Leam', '1997-10-16'),
  ('Sopia', '1995-04-11'),
  ('Nessy', '2015-10-18'),
  ('Mannie', '2001-01-17'),
  ('Sonie', '1994-03-05');


SELECT * FROM users;

SELECT AVG (TIMESTAMPDIFF(YEAR, birthday, NOW())) AS average_age FROM users;

 

# 2.Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
#Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT 
  DATE_FORMAT(DATE(CONCAT_WS('-', YEAR (NOW()), MONTH(birthday), DAY(birthday))), '%W') 
  COUNT(*) AS total 
FROM
  users
GROUP BY 
  day 
ORDER BY 
  total DESC;


# 3.(по желанию) Подсчитайте произведение чисел в столбце таблицы
 

DROP TABLE IF EXISTS catalogs ;
CREATE TABLE catalogs ( 
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  name VARCHAR(100) NOT NULL,
  value INT UNSIGNED
);
INSERT INTO catalogs (name, value) VALUES
  ('processor', '12'),
  ('isolation', '21'),
  ('cooler', '1'),
  ('videocard', '5'),
  ('headphone', '75'),
  ('keyboard', '85'),
  ('monitor', '96'),
  ('keys', '7'),
  ('wires', '8'),
  ('safe_system', '2'),
  ('blocks', '8');
 
SELECT * FROM catalogs;

SELECT ROUND(EXP(SUM(LN(value)))) FROM catalogs;
