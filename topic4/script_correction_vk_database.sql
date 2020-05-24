USE vk;
SHOW TABLES;

-- user TABLE CORRECTION

SELECT * FROM users;
UPDATE users SET updated_at = CURRENT_TIMESTAMP WHERE created_at > updated_at;
UPDATE users SET status_id = FLOOR(1 + RAND() * 3);


-- profiles TABLE CORRECTION

SELECT * FROM profiles;
UPDATE profiles SET photo_id = FLOOR(1 + RAND() * 100);
UPDATE profiles SET gender = (SELECT name FROM genders ORDER BY RAND() LIMIT 1);
-- Можно создать отдельную таблицу на is_privete. Где true = 1, а false = 0


-- messages TABLE CORRECTION

SELECT * FROM messages;
UPDATE messages SET from_user_id = FLOOR(1 + RAND() * 100),
                    to_user_id = FLOOR(1 + RAND() * 100);
      

-- media TABLE CORRECTION

SELECT * FROM media;
UPDATE media SET user_id = FLOOR(1 + RAND() * 1000);

CREATE TEMPORARY TABLE extensions (name VARCHAR(10));
INSERT INTO extensions VALUES ('jpeg'), ('avi'), ('mpeg'), ('png');
SELECT * FROM extensions;

UPDATE media SET filename = CONCAT('https://dropbox/vk/',
  filename,
  '.',
  (SELECT name FROM extensions ORDER BY RAND() LIMIT 1)
);


UPDATE media SET size = FLOOR(100000 + RAND() * 100000000) WHERE size < 1000;
UPDATE media SET metadata = CONCAT('{"owner":"', 
  (SELECT CONCAT(first_name, ' ', last_name) FROM users WHERE id = user_id),
  '"}');

 ALTER TABLE media MODIFY COLUMN metadata JSON;

-- mediatypes TABLE CORRECTION

SELECT * FROM media_types;
INSERT INTO media_types (name) VALUES
  ('photo'),
  ('video'),
  ('audio')
;

UPDATE media SET media_type_id = FLOOR(1 + RAND() * 3);



-- friendship TABLE CORRECTION

SELECT * FROM friendship;

UPDATE friendship SET 
  user_id = FLOOR(1 + RAND() * 100),
  friend_id = FLOOR(1 + RAND() * 100);

 
SELECT * FROM friendship_statuses;
TRUNCATE friendship_statuses;

INSERT INTO friendship_statuses (name) VALUES
  ('Requested'),
  ('Confirmed'),
  ('Rejected');

UPDATE friendship SET status_id = FLOOR(1 + RAND() * 3);



-- communities TABLE CORRECTION

SELECT * FROM communities;
DELETE FROM communities WHERE id > 20;

SELECT * FROM communities_users;

UPDATE communities_users SET community_id = FLOOR(1 + RAND() * 20);
                   