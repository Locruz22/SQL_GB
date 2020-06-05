# 1. Подсчитать общее количество лайков десяти самым молодым пользователям.


SELECT * FROM profiles;
SELECT * FROM likes;
     
SELECT SUM(got_likes) AS total_likes_for_youngest
  FROM (   
    SELECT COUNT(DISTINCT likes.id) AS got_likes 
      FROM profiles
        LEFT JOIN likes
          ON likes.target_id = profiles.user_id
            AND target_type_id = 2
      GROUP BY profiles.user_id
      ORDER BY profiles.birthday DESC
      LIMIT 10
) AS youngest; 


SELECT 
  COUNT(likes.id) AS users_likes,
  profiles.birthday AS age,
  profiles.user_id
  FROM likes
    JOIN target_types
      ON likes.target_type_id = target_types.id
        AND target_types.name = 'users' 
    RIGHT JOIN profiles
      ON profiles.user_id = likes.target_id
  GROUP BY profiles.user_id
  ORDER BY age DESC
  LIMIT 10;   

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
  COUNT(DISTINCT posts.user_id) +
  COUNT(DISTINCT media.user_id) +
  COUNT(DISTINCT likes.user_id) AS activity
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


   
   
   