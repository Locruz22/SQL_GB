# 1. Создать все необходимые внешние ключи и диаграмму отношений.


SHOW TABLES;

# ------------------------------ status_id ------------------------------------------

DESC users;
-- Добавим внешний ключ на столбец status_id
ALTER TABLE users 
  ADD CONSTRAINT users_status_id_fk
  FOREIGN KEY (status_id) REFERENCES user_statuses(id)
    ON DELETE SET NULL;

-- Нужно поправить свойства солбца, сделать допустимым NULL значение    
ALTER TABLE users MODIFY COLUMN status_id INT UNSIGNED;

# ------------------------------ profiles ------------------------------------------

DESC profiles;

ALTER TABLE profiles
  ADD CONSTRAINT profiles_user_id_fk 
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,
  ADD CONSTRAINT profiles_photo_id_fk
    FOREIGN KEY (photo_id) REFERENCES media(id)
      ON DELETE SET NULL;
      
ALTER TABLE profiles DROP FOREIGN KEY profiles_user_id_fk;
ALTER TABLE profiles MODIFY COLUMN photo_id INT(10) UNSIGNED;

# ------------------------------ FRIENDSHIP ------------------------------------------

DESC friendship;
SELECT * FROM friendship;
-- status_id
-- user_id
-- friend_id


ALTER TABLE friendship 
  ADD CONSTRAINT friendship_status_id_fk
    FOREIGN KEY (status_id) REFERENCES friendship_statuses(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT friendship_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE CASCADE,    
  ADD CONSTRAINT friendship_friend_id_fk
    FOREIGN KEY (friend_id) REFERENCES users(id)
      ON DELETE CASCADE;

 
ALTER TABLE friendship MODIFY COLUMN (
  status_id INT UNSIGNED, 
  user_id INT UNSIGNED, 
  friend_id INT UNSIGNED
);


# ------------------------------ MEDIA ------------------------------------------


DESC media_types;
DESC media;
-- user_id
-- media_types

ALTER TABLE media
  ADD CONSTRAINT media_types_id_fk
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT media_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE SET NULL;



# ------------------------------ POSTS ------------------------------------------

DESC posts;
SELECT * FROM posts;
-- user_id
-- media_id
-- community_id


ALTER TABLE posts
  ADD CONSTRAINT post_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE SET NULL,   
  ADD CONSTRAINT post_media_id_fk
    FOREIGN KEY (media_id) REFERENCES media(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT post_community_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(id)
      ON DELETE SET NULL;

     
# ------------------------------ LIKES ------------------------------------------

SELECT * FROM likes;
DESC likes;
-- user_id
-- target_id
-- target_type_id


ALTER TABLE likes
  ADD CONSTRAINT likes_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT likes_target_id_fk
    FOREIGN KEY (target_id) REFERENCES users(id)
      ON DELETE SET NULL,
  ADD CONSTRAINT likes_target_type_id_fk
    FOREIGN KEY (target_type_id) REFERENCES target_types(id);

# ------------------------------ MESSAGES ------------------------------------------

DESC messages;
-- from_user_id
-- to_user_id

ALTER TABLE messages
  ADD CONSTRAINT messages_from_user_id_fk
    FOREIGN KEY (from_user_id) REFERENCES users(id),
  ADD CONSTRAINT messages_to_user_id_fk
    FOREIGN KEY (to_user_id) REFERENCES users(id);
   

# ------------------------------ COMMUNITIES ------------------------------------------

DESC communities_users;
DESC communities;

-- community_id
-- user_id

ALTER TABLE communities_users
  ADD CONSTRAINT communities_users_communities_id_fk
    FOREIGN KEY (community_id) REFERENCES communities(id), 
  ADD CONSTRAINT communities_users_user_id_fk
    FOREIGN KEY (user_id) REFERENCES users(id);




   
# 2. Создать и заполнить таблицы лайков и постов

SELECT * FROM posts;
SELECT * FROM likes;

-- Таблица лайков
DROP TABLE IF EXISTS likes;
CREATE TABLE likes (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  target_id INT UNSIGNED NOT NULL,
  target_type_id INT UNSIGNED NOT NULL,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Таблица типов лайков
DROP TABLE IF EXISTS target_types;
CREATE TABLE target_types (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(255) NOT NULL UNIQUE,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO target_types (name) VALUES 
  ('messages'),
  ('users'),
  ('media'),
  ('posts');

-- Заполняем лайки
INSERT INTO likes 
  SELECT 
    id, 
    FLOOR(1 + (RAND() * 1000)), 
    FLOOR(1 + (RAND() * 1000)),
    FLOOR(1 + (RAND() * 4)),
    CURRENT_TIMESTAMP 
  FROM users;


-- Создадим таблицу постов
CREATE TABLE posts (
  id INT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
  user_id INT UNSIGNED NOT NULL,
  community_id INT UNSIGNED,
  head VARCHAR(255),
  body TEXT NOT NULL,
  media_id INT UNSIGNED,
  is_public BOOLEAN DEFAULT TRUE,
  is_archived BOOLEAN DEFAULT FALSE,
  views_counter INT UNSIGNED DEFAULT 0,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Заполняем таблицу постов

FLOOR(10 + (RAND() * 90))
 
INSERT INTO posts 
  SELECT 
    id,
    FLOOR(1 + (RAND() * 1000)), 
    FLOOR(1 + (RAND() * 20)),
    CHAR( FLOOR(65 + (RAND() * 25))),
    CHAR( FLOOR(65 + (RAND() * 25))),
    FLOOR(1 + (RAND() * 1000)),
    FLOOR(RAND() * 2),
    FLOOR(RAND() * 2),
    FLOOR(1 + (RAND() * 99999)),
    CURRENT_TIMESTAMP,
    CURRENT_TIMESTAMP
  FROM users;

UPDATE posts SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;
UPDATE posts SET body = (SELECT body FROM messages ORDER BY RAND() LIMIT 1);
UPDATE posts SET head = (SELECT SUBSTRING(body, 1,10) FROM messages ORDER BY RAND() LIMIT 1);

SELECT * FROM posts;




# 3. Подсчитать общее количество лайков десяти самым молодым пользователям.
 
SELECT * FROM likes;

# лайки пользователям
SELECT target_id FROM likes WHERE target_type_id = (SELECT id FROM target_types WHERE name = 'users');

# 10 самых молодых
SELECT (SELECT CONCAT(first_name, ' ', last_name) FROM users u WHERE u.id = p.user_id) AS name
  FROM profiles p ORDER BY birthday DESC LIMIT 10;


SELECT COUNT(*) FROM 
  likes WHERE target_type_id = (SELECT id FROM target_types WHERE name = 'users') AND 
  target_id IN (SELECT * FROM 
    (SELECT user_id FROM profiles ORDER BY birthday DESC LIMIT 10) AS sorted_profiles 
  );
 

 
# 4. Определить кто больше поставил лайков (всего) - мужчины или женщины?
 
SELECT * FROM profiles;
SELECT * FROM likes;

SELECT
  (SELECT gender FROM profiles WHERE user_id = likes.user_id) AS gender,
  COUNT(*) AS total
    FROM likes 
    GROUP BY gender ORDER BY total DESC LIMIT 1;
 
   
   
   
   
   
# 5. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной 
-- сети.     

# не смог решить это задание самостоятельно, поэтому решил разобрать и немного дополнить.

 
SELECT
  CONCAT(first_name, ' ', last_name) AS user,
  (SELECT COUNT(*) FROM posts p WHERE p.user_id = users.id) +
  (SELECT COUNT(*) FROM likes l WHERE l.user_id = users.id) +
  (SELECT COUNT(*) FROM media m WHERE m.user_id = users.id) +
  (SELECT COUNT(*) FROM friendship f WHERE f.user_id = users.id) AS activity,
  (SELECT name FROM user_statuses u WHERE u.id = users.status_id) AS status
  FROM users
  ORDER BY activity
  LIMIT 10;