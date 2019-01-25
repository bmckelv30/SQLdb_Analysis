USE sakila;
# 1a.
SELECT first_name, last_name
FROM actor;
# 1b.
SELECT UPPER(CONCAT(first_name, ' ' ,last_name))
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
SELECT last_name, COUNT(last_name)
 FROM actor
 GROUP BY last_name;
# 4b.
SELECT last_name, lcount FROM (
	SELECT last_name, COUNT(last_name) AS lcount
    FROM actor
	GROUP BY last_name
    ) AS lcount
 WHERE lcount >= 2
 GROUP BY last_name;
# 4c. 
SELECT * FROM actor WHERE last_name = "WILLIAMS";

UPDATE actor
SET first_name = "GROUCHO"
WHERE first_name = "HARPO" AND last_name = "WILLIAMS";
# 4d.
SELECT * FROM actor WHERE last_name = "WILLIAMS";

UPDATE actor
SET first_name = "HARPO"
WHERE first_name = "GROUCHO" AND last_name = "WILLIAMS";
# 5a.
SHOW CREATE TABLE address;

# 6a.
SELECT * FROM address;
	# address_id
SELECT * FROM staff;
	# staff_id, address_id (foreign key)
# Use `JOIN` to display
SELECT staff.first_name, staff.last_name, address.address
 FROM address
 INNER JOIN staff ON staff.address_id=address.address_id;
   
# 6b.
SELECT * FROM payment;
	# payment_id, customer_id, staff_id, amount
# Use `JOIN` to display 
SELECT staff.first_name, staff.last_name, SUM(payment.amount) 
 FROM payment
 INNER JOIN staff ON staff.staff_id=payment.staff_id
 WHERE payment.payment_date >= "2005-08-01 00:00:00" AND payment.payment_date < "2005-09-01 00:00:00"
 GROUP BY payment.staff_id;
 
# 6d.
