use sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name, last_name 
FROM actor ;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name.
SELECT CONCAT(first_name, ' ', last_name) AS full_actor_name
FROM actor ;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know 
-- only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'JOE' ;

-- 2b. Find all actors whose last name contain the letters GEN:
SELECT actor_id, first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%' ;

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name 
-- and first name, in that order:
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name ;

-- 2d.  Using IN, display the country_id and country columns of the following countries: Afghanistan,
-- Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China') ;

-- 3a. You want to keep a description of each actor. You don't think you will be performing queries 
-- on a description, so create a column in the table actor named description and use the data type 
-- BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant).
ALTER TABLE actor ADD COLUMN description BLOB AFTER first_name ;

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the description column.
ALTER TABLE actor DROP description ;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name, COUNT(*) AS `Total Count` 
FROM actor 
GROUP BY last_name ;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names 
-- that are shared by at least two actors
SELECT last_name, COUNT(*) AS `Total_Count` 
FROM actor 
GROUP BY last_name 
HAVING COUNT(*) >= 2 ;

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.
UPDATE actor 
SET first_name = 'HARPO' 
WHERE first_name = 'GROUCHO'  
AND last_name = 'WILLIAMS' ;

select * from actor
where last_name = 'WILLIAMS' ;

-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the 
-- correct name after all! In a single query, if the first name of the actor is currently HARPO, 
-- change it to GROUCHO.
UPDATE actor 
SET first_name = case 
	WHEN first_name = 'HARPO' then 'MUCHO GROUCHO'
    WHEN first_name = 'MUCHO GROUCHO' then 'GROUCHO'
    ELSE first_name = 'GROUCHO' 
    END
    WHERE actor_id = 172 ;

select * from actor
where last_name = 'WILLIAMS' ;
-- UPDATE actor 
-- SET first_name = 'GROUCHO' AND last_name = 'WILLIAMS'
-- WHERE actor_id = 172;
    
SELECT actor_id, first_name, last_name
FROM actor
WHERE actor_id = 172 ;

-- 5a.  You cannot locate the schema of the address table. Which query would you use to re-create it? 
CREATE TABLE `address2` (
  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
  `address` varchar(50) NOT NULL,
  `address2` varchar(50) DEFAULT NULL,
  `district` varchar(20) NOT NULL,
  `city_id` smallint(5) unsigned NOT NULL,
  `postal_code` varchar(10) DEFAULT NULL,
  `phone` varchar(20) NOT NULL,
  `location` geometry NOT NULL,
  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`address_id`),
  KEY `idx_fk_city_id` (`city_id`),
  SPATIAL KEY `idx_location` (`location`),
  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
SELECT s.first_name, s.last_name, a.address
FROM staff s
INNER JOIN address a ON s.address_id = a.address_id ;

-- SELECT staff.first_name, staff.last_name, address.address
-- FROM staff
-- INNER JOIN address ON
-- staff.staff_id = address.address_id ;

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
SELECT s.first_name, s.last_name, s.staff_id, SUM(p.amount) 
FROM staff s
INNER JOIN payment p ON s.staff_id = p.staff_id 
WHERE p.payment_date BETWEEN '2005-08-01 00:00:00' AND '2005-08-31 23:59:59' 
GROUP BY s.staff_id ;

-- SELECT staff.first_name, staff.last_name, staff.staff_id, SUM(payment.amount) FROM staff 
-- INNER JOIN payment ON staff.staff_id = payment.staff_id 
-- WHERE payment_date BETWEEN '2005-08-01 00:00:00' AND '2005-08-31 23:59:59' 
-- GROUP BY staff_id ;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and 
-- film. Use inner join.
SELECT f.film_id, f.title, count(a.film_id) 
FROM film f
INNER JOIN film_actor a ON f.film_id = a.film_id
GROUP BY f.film_id ;

-- SELECT film.film_id, film.title, count(film_actor.film_id) 
-- FROM film 
-- INNER JOIN film_actor 
-- ON film.film_id = film_actor.film_id
-- GROUP BY film.film_id ;

-- 6d. List each film and the number of actors who are listed for that film. Use tables film_actor and 
-- film. Use inner join.
SELECT COUNT(inventory_id) AS 'Total Inventory'
FROM inventory 
WHERE film_id = 439 ; 

-- There are six copies of Hunchback Impossible.

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
SELECT c.last_name, c.first_name, SUM(p.amount)
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY c.last_name;

-- SELECT customer.last_name, customer.first_name, SUM(payment.amount)
-- FROM payment 
-- JOIN customer ON customer.customer_id = payment.customer_id
-- GROUP BY payment.customer_id
-- ORDER BY customer.last_name;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended 
-- consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries 
-- to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title 
FROM film 
WHERE (title LIKE 'K%' OR 'Q%') 
AND language_id IN (
	SELECT language_id 
    FROM language 
    WHERE name = 'English') ;

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name, last_name  
FROM actor 
WHERE actor_id IN (
	SELECT actor_id 
	FROM film_actor 
	WHERE film_id = 17) ;

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and 
-- email addresses of all Canadian customers. Use joins to retrieve this information.
SELECT c.first_name, c.last_name, c.email 
FROM customer c
	JOIN address a ON c.address_id = a.address_id
	JOIN city ci ON a.city_id = ci.city_id
	JOIN country co ON co.country_id = co.country_id 
    WHERE co.country = 'Canada';

SELECT customer.first_name, customer.last_name, customer.email 
FROM customer 
	JOIN address ON customer.address_id = address.address_id
	JOIN city ON address.city_id = city.city_id
	JOIN country ON country.country_id = city.country_id 
    WHERE country.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a 
-- promotion. Identify all movies categorized as family films.
SELECT film.title, film.film_id, category.name 
FROM film 
	JOIN film_category ON film.film_id = film_category.film_id
	JOIN category ON category.category_id = film_category.category_id
WHERE category.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT inventory.inventory_id, film.title, COUNT(rental.inventory_id) AS 'Rental Count' 
FROM rental 
	JOIN inventory ON inventory.inventory_id = rental.inventory_id
	JOIN film ON inventory.film_id = film.film_id
GROUP BY inventory.inventory_id
ORDER BY `Rental Count` DESC ;

-- 7f Write a query to display how much business, in dollars, each store brought in.
SELECT inventory.store_id, SUM(payment.amount) 
FROM payment
JOIN inventory ON payment.rental_id = inventory.inventory_id
GROUP BY store_id ;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT store.store_id, city.city, country.country 
FROM store
	JOIN address ON address.address_id = store.address_id
	JOIN city ON city.city_id =  address.city_id
	JOIN country ON country.country_id = city.country_id ;
    
-- SELECT store.store_id, address.address, city.city, country.country 
-- FROM store
-- JOIN address ON address.address_id = store.address_id
-- JOIN city ON city.city_id =  address.city_id
-- JOIN country ON country.country_id = city.country_id ;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following 
-- tables: category, film_category, inventory, payment, and rental.)
SELECT category.name, SUM(payment.amount) as 'Total Revenue' 
FROM payment
	JOIN rental on rental.rental_id = payment.rental_id
	JOIN inventory on inventory.inventory_id = rental.inventory_id
	JOIN film_category on film_category.film_id = inventory.film_id
	JOIN category on category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC LIMIT 5 ;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five 
-- genres by gross revenue. Use the solution from the problem above to create a view. If you haven't 
-- solved 7h, you can substitute another query to create a view.
CREATE VIEW top_5_categories AS 
SELECT category.name, SUM(payment.amount) AS 'Total Revenue' 
FROM payment
	JOIN rental ON rental.rental_id = payment.rental_id
	JOIN inventory ON inventory.inventory_id = rental.inventory_id
	JOIN film_category ON film_category.film_id = inventory.film_id
	JOIN category ON category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY sum(payment.amount) DESC LIMIT 5 ;

-- 8a. How would you display the view that you created in 8a?
SELECT * FROM top_5_categories ;

-- 8b. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_5_categories ;



