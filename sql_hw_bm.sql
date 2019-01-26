USE sakila;
# 1a.
SELECT first_name,
		last_name
FROM actor;

# 1b.
SELECT UPPER(CONCAT(first_name, ' ' ,last_name))
	AS `Actor Name`
	FROM actor;
# 2a.
SELECT actor_id, 
		first_name, 
        last_name
	FROM actor
    WHERE first_name="Joe";
# 2b.
 SELECT actor_id, 
		first_name, 
        last_name
	FROM actor
	WHERE last_name LIKE "%GEN%";
# 2c.
SELECT last_name, 
		first_name
	FROM actor
	WHERE last_name LIKE "%LI%";
# 2d.
SELECT country_id, 
		country
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
SELECT last_name, 
		COUNT(last_name)
	FROM actor
	GROUP BY last_name;
# 4b.
SELECT last_name, 
		lcount FROM (
					SELECT last_name, 
							COUNT(last_name) AS lcount
					FROM actor
					GROUP BY last_name
					) 
				AS lcount
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
# Reference: Reverse Engineer option, view diagram of `address` table
SHOW CREATE TABLE address;
# 6a.
SELECT * FROM address;	# address_id
SELECT * FROM staff;	# staff_id, address_id (foreign key)
# Use `JOIN` to display
SELECT s.first_name, 
		s.last_name, 
        a.address
	FROM address a
    JOIN staff s 
    USING (address_id);
# 6b.
SELECT * FROM payment; 	# payment_id, customer_id, staff_id, amount
# Use `JOIN` to display 
SELECT s.first_name, 
		s.last_name, 
        SUM(p.amount) 
	FROM payment p
    JOIN staff s 
    USING (staff_id)
    WHERE p.payment_date LIKE "2005-08%"
    GROUP BY p.staff_id;
# 6c.
SELECT * FROM film; # film_id, title
SELECT * FROM film_actor; # actor_id (for count), film_id (for join)
# Use `JOIN` to display 
SELECT f.title, 
		COUNT(fa.actor_id)
	FROM film f
    JOIN film_actor fa
    USING (film_id)
    GROUP BY fa.actor_id
; 
# 6d. 
SELECT * FROM film; # film_id, title
SELECT * FROM inventory; # inventory_id, film_id (for count), film_id (for join)
# Use `JOIN` to display 
SELECT f.title, 
		COUNT(i.film_id)
	FROM film f
    JOIN inventory i
    USING (film_id)
    WHERE f.title = "Hunchback Impossible"
    GROUP BY i.film_id
;
# 6e.
SELECT * FROM payment; # customer_id, amount
SELECT * FROM customer; # customer_id, first_name, last_name
SELECT first_name, 
		last_name, `Total Amount Paid` FROM (
										SELECT customer_id, 
												SUM(amount) AS `Total Amount Paid`
										FROM payment
										GROUP BY customer_id
                                        ) AS `Total Amount Paid`
    JOIN customer
    USING (customer_id)
    ;

# 7a.
SELECT * FROM film; # film_id, title
SELECT * FROM language; 
# Use `JOIN` to display 
SELECT title, 
		name
	FROM film f
    JOIN language l
    USING (language_id)
    WHERE f.language_id=1 AND 
			f.title LIKE "Q%" OR
            f.title LIKE "K%"
;
       
# 7b.
SELECT first_name, 
		last_name
	FROM actor
    JOIN film_actor
    USING (actor_id)
    WHERE film_id = (SELECT film_id 
						FROM film
						WHERE title="Alone Trip")
;

# 7c.
SELECT first_name, 
		last_name, 
        email
	FROM customer c
    JOIN address a
    USING (address_id)
    WHERE a.city_id IN (SELECT city_id
						 FROM country co
						 JOIN city ct 
						 USING (country_id)
						 WHERE co.country = "Canada")
;
 
# 7d. 
SELECT title
	FROM film f
	JOIN film_category fc
	USING (film_id)
	WHERE f.film_id IN (SELECT film_id
						 FROM film_category fc
						 JOIN category ct 
						 USING (category_id)
						 WHERE ct.name = "Family")
 ;
# 7e. NEEDS MORE WORK!!
SELECT * FROM rental;
# Test - Query to obtain most frequently rented movies in desc order
SELECT rental_id, 
		SUM(inventory_id) AS frequency
	FROM rental
    GROUP BY inventory_id
    ORDER BY frequency DESC;
# Test - Query to obtain film title
SELECT * FROM inventory;
SELECT title, 
		film_id, 
        inventory_id
	FROM inventory
    JOIN film
    USING (film_id);
# FIX - How to dedupe? Seems to be subsetting store_id
SELECT * FROM film;
SELECT f.title,
		SUM(r.inventory_id) AS frequency
	FROM inventory i
    RIGHT OUTER JOIN film f ON f.film_id=i.film_id
    INNER JOIN rental r ON r.inventory_id=i.inventory_id
    GROUP BY r.inventory_id
    ORDER BY frequency DESC
;