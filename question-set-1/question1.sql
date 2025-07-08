-- Question 1
-- We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family, and Music.
-- Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.
-- Check Your Solution
-- For this query, you will need 5 tables: Category, Film_Category, Inventory, Rental and Film. Your solution should have three columns: Film title, Category name and Count of Rentals.
-- The following table header provides a preview of what the resulting table should look like if you order by category name followed by the film title.
-- HINT: One way to solve this is to create a count of movies using aggregations, subqueries and Window functions.

SELECT 
    f.title AS film_title,
    c.name AS category_name,
    COUNT(r.rental_id) AS rental_count
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY c.name, f.title
ORDER BY c.name, film_title;


-- Question 1 - Using Window Functions
-- We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family, and Music.
-- Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.

SELECT 
    f.title AS film_title,
    c.name AS category_name,
    COUNT(r.rental_id) AS rental_count,
    RANK() OVER (PARTITION BY c.name ORDER BY COUNT(r.rental_id) DESC) AS rank_in_category,
    COUNT(r.rental_id) - AVG(COUNT(r.rental_id)) OVER (PARTITION BY c.name) AS diff_from_avg
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
GROUP BY c.name, f.title, f.film_id
ORDER BY c.name, rental_count DESC;