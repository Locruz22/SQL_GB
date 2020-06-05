# 1. Проанализировать какие запросы могут выполняться наиболее часто в процессе работы приложения и добавить необходимые индексы.


SELECT * FROM likes;

# сколько лайков у пользователя 
SELECT target_id FROM likes WHERE target_type_id = 2 AND target_id = 100; 				    -- пример

CREATE INDEX likes_user_id_to_target_id_idx ON likes(user_id, target_type_id, target_id);


# сколько лайков поставил пользователь
# сколько лайков поставили сущности
SELECT user_id, target_id FROM likes WHERE user_id = 22; 									-- пример

CREATE INDEX likes_user_id_idx ON likes(user_id);
CREATE INDEX likes_target_id_idx ON likes(target_id);

-- -----------------------------------------------------------------------------------------

SELECT user_id, community_id FROM posts WHERE community_id = 2;

# нужно посмотреть в каких комьюнити какие юзеры

CREATE INDEX posts_community_id_user_id_idx ON posts(community_id, user_id);

# можно так же использовать этот индекс, если нужно посмотреть в каких комьюнити состоит юзер. 
$ Но в этом случае, кажется, поиску будет медленнее


-- -----------------------------------------------------------------------------------------
SELECT * FROM users;
# нужно найи пользователя по имени и фамилии

# кажется, стоит сделать составной индекс фамилия + имя. Фамилия идет первой потому что не повторяется

CREATE INDEX users_last_name_first_name_idx ON users (last_name, first_name);

-- -----------------------------------------------------------------------------------------
SELECT * FROM profiles;

# найти пользователей в городе и стране
SELECT user_id, city, country FROM profiles WHERE country = 'SWEDEN';

CREATE INDEX profiles_country_city_user_id_idx FROM profiles;


--- ----------------------------------------------------------------------------------------




/* 2. Задание на оконные функции

Построить запрос, который будет выводить следующие столбцы:
- имя группы
- среднее количество пользователей в группах
- самый молодой пользователь в группе
- самый старший пользователь в группе
- общее количество пользователей в группе
- всего пользователей в системе
- отношение в процентах (общее количество пользователей в группе / всего пользователей в системе) * 100
*/



SELECT DISTINCT
  communities.name,
  COUNT(communities_users.user_id) OVER () / 10 AS 'average_users',
  MAX(profiles.birthday) OVER(PARTITION BY communities.name) AS 'youngest',
  MIN(profiles.birthday) OVER(PARTITION BY communities.name) AS 'oldest',
  COUNT(communities_users.user_id) OVER (PARTITION BY communities.name) AS 'amount_users',
  COUNT(profiles.user_id) OVER() AS 'users_in_system',
  COUNT(communities_users.user_id) OVER (PARTITION BY communities.name) / COUNT(profiles.user_id) OVER() AS '%%'
    FROM communities
      JOIN communities_users
        ON communities.id = communities_users.community_id
      RIGHT JOIN profiles
        ON communities_users.user_id = profiles.user_id;

       
SELECT * FROM profiles;   
SELECT * FROM communities_users;
SELECT * FROM communities;


