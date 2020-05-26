
# 1. Составьте список пользователей users, которые осущиствили хотя бы один заказ orders в интернет-магазине

-- уже имеются таблицы orders, catalogs, users, products. Все таблицы кроме orders заполненны данными.

SELECT * FROM orders;			# id, product_id, buyer_id, count
SELECT * FROM catalogs;			# id, name, value
SELECT * FROM users;  			# id, name, birthday
SELECT * FROM products;			# id, name, product_id, total

-- Заполним таблицу orders тестовыми данными

INSERT INTO orders (product_id, buyer_id, amount)
VALUES 
  ((SELECT id FROM products WHERE name = 'Intel Core i5 / i7 H Series'),
   (SELECT id FROM users WHERE name = 'Nico'),
   2),
  ((SELECT id FROM products WHERE name = 'Anker Soundcore Liberty Air'),
   (SELECT id FROM users WHERE name = 'Nessy'),
   2),
  ((SELECT id FROM products WHERE name = 'Logitech K780'),
   (SELECT id FROM users WHERE name = 'Jassy'),
   2),  
   ((SELECT id FROM products WHERE name = 'Acer Predator XB271HU'),
   (SELECT id FROM users WHERE name = 'Leam'),
   2);
 

-- покупатели
  
SELECT * FROM users;
  
SELECT u.id, u.name, u.birthday 
FROM users AS u
JOIN
orders AS o WHERE o.id = u.id;     # можно ON





# 2. Выведите список товаров products и разделов catalogs, который соотвествует товару

SELECT products.id, products.name, catalogs.name 
FROM catalogs AS catalogs
JOIN
products AS products
ON catalogs.id = products.product_catalog_id;


