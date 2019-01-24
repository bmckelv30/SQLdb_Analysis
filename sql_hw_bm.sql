USE sakila;
# 1a.
SELECT first_name, last_name
FROM actor;
# 1b.
SELECT CONCAT(first_name, ' ' ,last_name) 
 AS `Actor Name`
 FROM actor;
# 2a.
SELECT actor_id, first_name, last_name
 FROM actor
 WHERE first_name="Joe";
# 2b.
 SELECT actor_id, first_name, last_name
 FROM actor
 WHERE last_name LIKE "%GEN%";
# 2c.
SELECT last_name, first_name
 FROM actor
 WHERE last_name LIKE "%LI%";
# 2d.
SELECT country_id, country
 FROM country
 WHERE country IN ("Afghanistan", "Bangladesh", "China");
# 3a.
ALTER TABLE actor 
 ADD COLUMN description BLOB;

SELECT * FROM actor;
# 3b.
ALTER TABLE actor 
 DROP COLUMN description;

SELECT * FROM actor;
# 4a.