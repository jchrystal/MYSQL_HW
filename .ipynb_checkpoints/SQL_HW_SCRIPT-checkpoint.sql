USE sakila;

-- 1A --
SELECT first_name, last_name FROM actor;

-- 1B --
SELECT CONCAT(first_name, ' ', last_name) AS 'Actor Name' FROM actor;

-- 2A --
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name LIKE'Joe'

-- 2B --
SELECT * FROM actor
WHERE last_name LIKE'%GEN%'

-- 2C --
SELECT * FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name

-- 2D --
SELECT * FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China')

-- 3A --
ALTER TABLE actor
ADD COLUMN middle_name VARCHAR(30) AFTER first_name

-- 3B --
ALTER TABLE actor
MODIFY COLUMN middle_name BLOB

-- 3C --
ALTER TABLE actor
DROP COLUMN middle_name

-- 4A --
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name

-- 4B --
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name
HAVING COUNT(last_name) > 1

-- 4C --
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name = 'Williams'

-- 4D -- 
UPDATE actor
SET first_name = CASE
	WHEN first_name = 'HARPO' and last_name = 'WILLIAMS'
    THEN 'GROUCHO'
    WHEN first_name = 'GROUCHO' and last_name = 'WILLIAMS'
    THEN 'MUCHO GROUCHO'
    ELSE first_name
END; 

-- 5A --
SHOW CREATE TABLE address;

-- 6A --
SELECT staff.address_id, staff.first_name, staff.last_name, address.address 
FROM staff
INNER JOIN address ON
staff.address_id = address.address_id;

-- 6B --
SELECT staff.staff_id, staff.first_name, staff.last_name, SUM(payment.amount)
FROM staff
INNER JOIN payment ON
staff.staff_id = payment.staff_id
GROUP BY payment.staff_id;

-- 6C --
SELECT film.title, COUNT(film_actor.actor_id) AS 'Actor Count'
FROM film
INNER JOIN film_actor ON
film.film_id = film_actor.film_id
GROUP BY film_actor.film_id;

-- 6D --
SELECT film.title, COUNT(inventory.inventory_id) AS 'Inventory Count'
FROM film
INNER JOIN inventory ON
film.film_id = inventory.film_id
GROUP BY inventory.film_id;

-- 6E --
SELECT customer.first_name, customer.last_name, 
SUM(payment.amount) as 'Total Amount Paid'
FROM customer
INNER JOIN payment ON
customer.customer_id = payment.customer_id
GROUP BY payment.customer_id
ORDER BY customer.last_name;

-- 7A --
SELECT * FROM film
WHERE (language_id in (
	SELECT language_id
    FROM language
    WHERE name = 'English'))
AND (title LIKE 'Q%' OR title LIKE 'K%')

-- 7B --
SELECT first_name, last_name 
FROM actor
WHERE actor_id IN ( 
	SELECT actor_id
    FROM film_actor
    WHERE film_id IN (
		SELECT film_id
        FROM film
        WHERE title = 'Alone Trip'
	)
);

-- 7C --
SELECT first_name, last_name, email 
FROM customer
WHERE address_id IN (
	SELECT address_id 
    FROM address
    WHERE city_id IN (
		SELECT city_id
        FROM city
        WHERE country_id IN (
			SELECT country_id
            FROM country
            WHERE country = 'Canada'
            )
		)
	)

-- 7D -- 
SELECT title	
FROM film    
WHERE film_id IN (    
    SELECT film_id
	FROM film_category
	WHERE category_id IN (
			SELECT category_id 
			FROM category
			WHERE name = 'Family'
	)
);

-- 7E --
SELECT film.title, COUNT(rental.rental_id) AS 'Rental Count'
FROM inventory, rental, film 
WHERE rental.inventory_id = inventory.inventory_id AND inventory.film_id = film.film_id
GROUP BY film.title
ORDER BY COUNT(rental.rental_id) DESC;

-- 7F --
SELECT store.store_id, SUM(payment.amount)
FROM store, payment
WHERE store.manager_staff_id = payment.staff_id
GROUP BY store.store_id;

-- 7G --
SELECT store.store_id, city.city, country.country
FROM store, address, city, country
WHERE store.address_id = address.address_id
AND address.city_id = city.city_id
AND city.country_id = country.country_id

-- 7H --
SELECT category.name AS 'Category', SUM(payment.amount) AS 'Gross Revenue'
FROM category, film_category, inventory, payment, rental
WHERE category.category_id = film_category.film_id
AND film_category.film_id = inventory.film_id
AND inventory.inventory_id = rental.inventory_id
AND rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5

-- 8A --
CREATE VIEW top_five_genres AS
SELECT category.name AS 'Category', SUM(payment.amount) AS 'Gross Revenue'
FROM category, film_category, inventory, payment, rental
WHERE category.category_id = film_category.film_id
AND film_category.film_id = inventory.film_id
AND inventory.inventory_id = rental.inventory_id
AND rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5

-- 8B --
SELECT * FROM top_five_genres;

-- 8C --
DROP VIEW top_five_genres;
