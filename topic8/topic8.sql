# 1. Подсчитать общее количество лайков десяти самым молодым пользователям.


SELECT * FROM profiles;
-- user_id, birthday
SELECT * FROM likes;
-- id, target_id, taraget_type_id (2)

# Этот запрос выдает 10 ячеек (самых молодых пользователей) в которых находится определенное количество лайков,
# но не понял как это все сложить в одну ячейку (SUM выдает что-то странное)

SELECT profiles.user_id, profiles.birthday, COUNT(likes.target_id) AS user_likes
  FROM likes
    JOIN profiles
      ON profiles.user_id = likes.target_id AND likes.target_type_id = 2
      GROUP BY likes.target_id
      ORDER BY profiles.birthday DESC LIMIT 10;




# 2. Определить кто больше поставил лайков (всего) - мужчины или женщины?
    
     
SELECT profiles.gender, COUNT(profiles.gender) AS total
  FROM likes
    JOIN profiles
      ON profiles.user_id = likes.user_id
    GROUP BY gender;


# 3. Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети (критерии активности необходимо определить самостоятельно).

SELECT * FROM posts;
SELECT * FROM likes;
SELECT * FROM media;
SELECT * FROM friendship;

   
SELECT 
  CONCAT(users.first_name, ' ', users.last_name) AS name, 
  COUNT(posts.user_id) +
  COUNT(media.user_id) +
  COUNT(likes.user_id) AS activity
  FROM users
   LEFT JOIN posts
      ON posts.user_id = users.id
   LEFT JOIN likes
      ON likes.user_id = users.id
   LEFT JOIN media
      ON media.user_id = users.id
  GROUP BY users.id
  ORDER BY activity
  LIMIT 10;
   
   
   
   
   
   
   
   
   
   