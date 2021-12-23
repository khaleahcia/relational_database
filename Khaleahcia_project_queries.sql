/* 
	Question 1
	What are the most popular categories for movies?
*/

SELECT movie_category, movie_count, category_quartile
  FROM (SELECT c.name AS movie_category, 
               COUNT(fc.film_id) AS movie_count, 
               NTILE (4) OVER(ORDER BY COUNT(fc.film_id)) AS category_quartile
          FROM category AS c
          JOIN film_category AS fc
               ON c.category_id = fc.category_id
         GROUP BY c.name) AS t1
 WHERE category_quartile = 4;

/*
	Question 2
	Out of the top ten customers, who spent the most money each month?
*/

  WITH top_customers AS
       (SELECT customer_id, SUM(amount) AS total_amount_spent
          FROM payment
         GROUP BY customer_id
         ORDER BY SUM(amount) DESC
         LIMIT 10)
SELECT CONCAT(c.first_name, ' ', c.last_name) AS full_name,
       DATE_TRUNC('month', p.payment_date) AS month, 
       SUM(p.amount) AS amount_spent
  FROM top_customers AS tc
       JOIN payment AS p
         ON p.customer_id = tc.customer_id

       JOIN customer AS c
         ON p.customer_id = c.customer_id
 GROUP BY DATE_TRUNC('month', p.payment_date),
       CONCAT(c.first_name, ' ', c.last_name)
 ORDER BY DATE_TRUNC('month', p.payment_date),
       CONCAT(c.first_name, ' ', c.last_name);

/*
	Question 3
	Which employee had the best total sales each month?
*/

SELECT CONCAT(s.first_name, ' ', s.last_name) AS full_name,
       DATE_TRUNC('month', p.payment_date) AS month, 
       SUM(p.amount) AS total_sales
  FROM staff AS s
       JOIN payment AS p
         ON p.staff_id = s.staff_id
 GROUP BY CONCAT(s.first_name, ' ', s.last_name), 
       DATE_TRUNC('month', p.payment_date);

/*
	Question 4
	How many times have movies from each category been rented out?
*/

SELECT c.name AS movie_category, 
       COUNT(r.rental_id) AS number_of_times_rented
  FROM rental AS r
       JOIN inventory AS i
         ON r.inventory_id = i.inventory_id

       JOIN film_category AS fc
         ON i.film_id = fc.film_id

       JOIN category AS c
         ON fc.category_id = c.category_id
 GROUP BY c.name
 ORDER BY c.name;