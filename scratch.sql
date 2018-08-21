use sakila;

1A.  SELECT first_name, last_name FROM actor;
1B.  SELECT CONCAT(first_name, ' ', last_name) FROM actor as `Actor Name`;
2A. SELECT actor_id, first_name, last_name FROM actor WHERE first_name = 'JOE';
2B. SELECT actor_id, first_name, last_name FROM actor WHERE last_name LIKE '%GEN%';
2C. SELECT last_name, first_name FROM actor WHERE last_name LIKE '%LI%';
2D. SELECT country_id, country FROM country WHERE country IN ('Afghanistan', 'Bangladesh', 'China');
3A. ALTER TABLE actor ADD COLUMN middle_name VARCHAR(30) AFTER first_name;
3B. ALTER TABLE actor MODIFY middle_name BLOB;
3C. ALTER TABLE actor DROP middle_name;
4A. SELECT last_name, COUNT(*) AS `Number With This Name` FROM actor GROUP BY last_name;
4B. SELECT last_name, COUNT(*) AS `Number With This Name` FROM actor GROUP BY last_name HAVING COUNT(*) >= 2;
4C. UPDATE actor SET first_name = 'HARPO' WHERE first_name = 'groucho'  AND last_name = 'williams';
4D. update actor 
set first_name = case 
	when first_name = 'HARPO' then 'GROUCHO'
    when first_name = 'GROUCHO' then 'MUCHO GROUCHO'
    end
    where actor_id = 172;
select actor_id, first_name from actor where actor_id = 172;
5A.
 'address', 'CREATE TABLE `address` (\n  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,\n  `address` varchar(50) NOT NULL,\n  `address2` varchar(50) DEFAULT NULL,\n  `district` varchar(20) NOT NULL,\n  `city_id` smallint(5) unsigned NOT NULL,\n  `postal_code` varchar(10) DEFAULT NULL,\n  `phone` varchar(20) NOT NULL,\n  `location` geometry NOT NULL,\n  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\n  PRIMARY KEY (`address_id`),\n  KEY `idx_fk_city_id` (`city_id`),\n  SPATIAL KEY `idx_location` (`location`),\n  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE\n) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8'

6A. SELECT staff.first_name, staff.last_name, address.address
FROM staff
INNER JOIN address ON
staff.staff_id = address.address_id;
6B. SELECT staff.first_name, staff.last_name, staff.staff_id, SUM(payment.amount) FROM staff 
INNER JOIN payment ON staff.staff_id = payment.staff_id 
WHERE payment_date BETWEEN '2005-08-01 00:00:00' AND '2005-08-31 23:59:59' GROUP BY staff_id;
6C. SELECT film.film_id, film.title, count(film_actor.film_id) 
FROM film 
INNER JOIN film_actor 
ON film.film_id = film_actor.film_id
GROUP BY film.film_id;

6D. SELECT count(inventory_id) FROM inventory WHERE film_id = 439; There are six copies of Hunchback Impossible.
6E. SELECT customer.last_name, customer.first_name, SUM(payment.amount)
FROM payment 
JOIN customer
ON customer.customer_id = payment.customer_id
GROUP BY payment.customer_id
ORDER BY customer.last_name;

7A. SELECT title FROM film WHERE (title LIKE 'K%' OR 'Q%') AND language_id IN (SELECT language_id FROM language WHERE name = 'English');

7B. SELECT first_name, last_name FROM actor WHERE actor_id IN (SELECT actor_id FROM film_actor WHERE film_id = 17);

7C. SELECT customer.first_name, customer.last_name, customer.email FROM customer 
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
JOIN country ON country.country_id = city.country_id WHERE country.country = 'Canada';

7D. 
select film.title, film.film_id, category.name from film 
join film_category on film.film_id = film_category.film_id
join category on category.category_id = film_category.category_id
where category.name = 'Family';

7E. 
SELECT inventory.inventory_id, film.title, count(rental.inventory_id) AS 'Rental Count' FROM rental 
JOIN inventory on inventory.inventory_id = rental.inventory_id
JOIN film on inventory.film_id = film.film_id
GROUP BY inventory.inventory_id
order by `Rental Count` DESC;

7F. select inventory.store_id, sum(payment.amount) from payment
join inventory on payment.rental_id = inventory.inventory_id
group by store_id;

7G. select store.store_id, address.address, city.city, country.country from store
join address on address.address_id = store.address_id
join city on city.city_id =  address.city_id
join country on country.country_id = city.country_id;

7H SELECT category.name, SUM(payment.amount) as 'Total Revenue' FROM payment
JOIN rental on rental.rental_id = payment.rental_id
JOIN inventory on inventory.inventory_id = rental.inventory_id
JOIN film_category on film_category.film_id = inventory.film_id
JOIN category on category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY sum(payment.amount) DESC LIMIT 5;

8A: CREATE VIEW top_5_categories as 
SELECT category.name, SUM(payment.amount) as 'Total Revenue' FROM payment
JOIN rental on rental.rental_id = payment.rental_id
JOIN inventory on inventory.inventory_id = rental.inventory_id
JOIN film_category on film_category.film_id = inventory.film_id
JOIN category on category.category_id = film_category.category_id
GROUP BY category.name
ORDER BY sum(payment.amount) DESC LIMIT 5;

8B. select * from top_5_categories;

8C. drop view top_5_categories;