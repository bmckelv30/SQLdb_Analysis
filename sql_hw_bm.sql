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
SHOW CREATE TABLE address;
# 6a.
	# Use `JOIN` to display
SELECT s.first_name, 
		s.last_name, 
        a.address
	FROM address a
    JOIN staff s 
    USING (address_id);
# 6b.
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
	# Use `JOIN` to display 
SELECT f.title, 
		COUNT(fa.actor_id)
	FROM film f
    JOIN film_actor fa
    USING (film_id)
    GROUP BY fa.actor_id
; 
# 6d. 
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
# 7e. 
SELECT f.title,
		SUM(r.inventory_id) AS frequency
	FROM inventory i
    RIGHT OUTER JOIN film f ON f.film_id=i.film_id
    INNER JOIN rental r ON r.inventory_id=i.inventory_id
    GROUP BY f.film_id
    ORDER BY frequency DESC
;
# 7f.
SELECT * FROM payment;
	# amount
SELECT SUM(amount) AS total
	FROM payment
    GROUP BY staff_id;
SELECT * FROM store;
	# store_id, manager_staff_id
SELECT * FROM staff;
SELECT s.store_id,
		FORMAT(SUM(p.amount), 'C', 'en-US') AS total_business
	FROM payment p
    JOIN store s ON p.staff_id=s.manager_staff_id
    GROUP BY s.store_id
    ORDER BY s.store_id
;
# 7g.
SELECT s.store_id,
		ct.city,
		co.country
	FROM store s
    JOIN address a
		USING (address_id)
	JOIN city ct
		USING (city_id)
    JOIN country co
		USING (country_id)
;
# 7h.
SELECT c.name,
		SUM(p.amount) AS revenue
	FROM category c 
    JOIN film_category fc
		USING (category_id)
	JOIN inventory i
		USING(film_id)
	JOIN rental r
		USING (inventory_id)
	JOIN payment p
		USING (rental_id)
	GROUP BY name
    ORDER BY revenue DESC
    LIMIT 5
;
# 8a.
CREATE VIEW top_five_genres AS
	SELECT c.name,
			SUM(p.amount) AS revenue
		FROM category c 
		JOIN film_category fc
			USING (category_id)
		JOIN inventory i
			USING(film_id)
		JOIN rental r
			USING (inventory_id)
		JOIN payment p
			USING (rental_id)
		GROUP BY name
		ORDER BY revenue DESC
		LIMIT 5
;
# 8b.
SELECT * FROM top_five_genres;
# 8c.
DROP VIEW top_five_genres;
