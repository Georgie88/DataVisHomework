USE sakila;

-- 1a. Display the first and last names of all actors from the table actor.
SELECT first_name,
last_name
FROM actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name.
SELECT concat(upper(first_name)," " ,upper(last_name)) as Actor_Name
FROM actor;

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." 
-- What is one query would you use to obtain this information?
SELECT actor_id,
first_name,
last_name
FROM actor
WHERE first_name = 'Joe';

-- 2b. Find all actors whose last name contain the letters GEN
SELECT actor_id,
first_name,
last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order
SELECT actor_id,
first_name,
last_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China
SELECT country_id,
country
FROM country
WHERE country IN ('Afghanistan', 'Bangladesh', 'China');

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. Hint: you will need to specify the data type.
ALTER TABLE actor
ADD middle_name VARCHAR(50) AFTER first_name;

SELECT * FROM actor;

-- 3b. You realize that some of these actors have tremendously long last names. Change the data type of the middle_name column to blobs
ALTER TABLE actor
MODIFY middle_name BLOB;

-- 3c. Now delete the middle_name column
ALTER TABLE actor
DROP COLUMN middle_name;

-- 4a. List the last names of actors, as well as how many actors have that last name.
SELECT last_name,
COUNT(DISTINCT actor_id) AS num_of_actors
FROM actor
GROUP BY 1;

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors
SELECT last_name,
COUNT(DISTINCT actor_id) AS num_of_actors
FROM actor
WHERE num_of_actors >= 2
GROUP BY 1;

SELECT *
FROM actor
WHERE first_name = 'GROUCHO';

-- 4c. Oh, no! The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`, 
-- the name of Harpo's second cousin's husband's yoga teacher. Write a query to fix the record.
UPDATE actor SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' AND last_name = 'WILLIAMS';

SELECT *
FROM actor
WHERE last_name = 'WILLIAMS';

-- 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! 
-- In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`. Otherwise, change the first name to `MUCHO GROUCHO`, 
-- as that is exactly what the actor will be with the grievous error. BE CAREFUL NOT TO CHANGE THE FIRST NAME OF EVERY ACTOR TO `MUCHO GROUCHO`, 
-- HOWEVER! (Hint: update the record using a unique identifier.)
UPDATE actor SET first_name = 'GROUCHO'
WHERE actor_id = 172;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
SHOW CREATE TABLE address;

CREATE TABLE address_v2 LIKE address;

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address
SELECT s.first_name,
s.last_name,
a.address
FROM staff s 
JOIN address a
	ON s.address_id = a.address_id;
    
-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment
SELECT s.first_name,
s.last_name,
SUM(p.amount) AS Total_Amount 
FROM staff s
JOIN payment p
	ON s.staff_id = p.staff_id
WHERE p.payment_date BETWEEN TIMESTAMP '2005-01-01 00:00:00.000000' AND TIMESTAMP '2005-12-31 23:59:59.999999' 
GROUP BY 1,2;

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join
SELECT f.title,
COUNT(DISTINCT fa.actor_id) AS Actors_Count
FROM film f
INNER JOIN film_actor fa
	ON f.film_id = fa.film_id
GROUP BY 1;

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
SELECT f.title,
COUNT(i.film_id) AS Copies_Num
FROM film f
JOIN inventory i
	ON f.film_id = i.film_id
WHERE title = 'Hunchback Impossible'
GROUP BY 1;

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name
SELECT c.last_name,
SUM(p.amount) AS Total_Paid
FROM customer c
JOIN payment p
	ON c.customer_id = p.customer_id
GROUP BY 1;

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also 
-- soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
SELECT title
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%'
AND language_id = (
					SELECT language_id
                    FROM language
                    WHERE name = 'English'
				);

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
SELECT first_name,
last_name
FROM actor
WHERE actor_id IN (
					SELECT actor_id
                    FROM film_actor
                    WHERE film_id = (
										SELECT film_id
                                        FROM film
                                        WHERE title = 'Alone Trip'
									)
				);

-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
SELECT c.first_name, 
c.last_name, 
c.email 
FROM customer c
	JOIN address a 
		ON c.address_id = a.address_id
			JOIN city ci 
				ON ci.city_id = a.city_id
					JOIN country co 
						ON ci.country_id = co.country_id
WHERE CO.country = 'Canada';

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion.
-- Identify all movies categorized as famiy films.
SELECT f.title,
c.name
FROM film f
	JOIN film_category fc 
		ON f.film_id = fc.film_id
			JOIN category c
				ON c.category_id = fc.category_id
WHERE c.name = 'Family';

-- 7e. Display the most frequently rented movies in descending order.
SELECT f.title, 
COUNT(r.rental_id) AS rental_count 
FROM film f
	JOIN inventory i
		ON f.film_id = i.film_id
			JOIN rental r
				ON i.inventory_id = r.inventory_id
GROUP BY 1
ORDER BY rental_count DESC;

-- 7f. Write a query to display how much business, in dollars, each store brought in.
SELECT s.store_id, 
COUNT(p.payment_id) payment_count, 
SUM(p.amount) AS total_amount 
FROM store s
	JOIN inventory i
		ON s.store_id = i.store_id
			JOIN rental r
				ON i.inventory_id = r.inventory_id
					JOIN payment p
						ON r.rental_id = p.rental_id
GROUP BY 1;

-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, 
ci.city, 
co.country 
FROM store s
	JOIN address a
		ON a.address_id = s.address_id
			JOIN city ci
				ON ci.city_id = a.city_id
					JOIN country co
						ON co.country_id = ci.country_id;
                        
-- 7h. List the top five genres in gross revenue in descending order. 
SELECT c.name, 
SUM(p.amount) AS Gross_Revenue 
FROM category c
	JOIN film_category fc 
		ON fc.category_id = c.category_id
			JOIN inventory i 
				ON i.film_id = fc.film_id
					JOIN rental r 
						ON r.inventory_id = i.inventory_id
							JOIN payment p 
								ON p.rental_id = r.rental_id
GROUP BY 1
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. 

CREATE VIEW Top_5_Genres AS
SELECT c.name, 
SUM(p.amount) AS Gross_Revenue 
FROM category c
	JOIN film_category fc 
		ON fc.category_id = c.category_id
			JOIN inventory i 
				ON i.film_id = fc.film_id
					JOIN rental r 
						ON r.inventory_id = i.inventory_id
							JOIN payment p 
								ON p.rental_id = r.rental_id
GROUP BY 1
ORDER BY gross_revenue DESC
LIMIT 5;

-- 8b. How would you display the view that you created in 8a?
SELECT * FROM Top_5_Genres;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW IF EXISTS Top_5_Genres;





 

