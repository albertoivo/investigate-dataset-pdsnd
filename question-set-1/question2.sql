-- Question 2
-- Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the average rental duration(in the number of days) for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into.
-- Check Your Solution
-- The data are not very spread out to create a very fun-looking solution, but if you correctly split your data, you should see something like the following. You should only need the category, film_category, and film tables to answer this and the next questions. 
-- HINT: One way to solve it requires the use of percentiles, Window functions, subqueries, or temporary tables.
SELECT 
    f.title AS title,
    c.name AS category_name,
    f.rental_duration,
    CASE 
        WHEN f.rental_duration <= (SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY rental_duration) FROM film) THEN '1'
        WHEN f.rental_duration <= (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY rental_duration) FROM film) THEN '2'
        WHEN f.rental_duration <= (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY rental_duration) FROM film) THEN '3'
        ELSE '4'
    END AS standard_quartile
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title, c.name, f.rental_duration
ORDER BY standard_quartile, title;

-- Using Window Functions
SELECT 
    f.title AS title,
    c.name AS category_name,
    f.rental_duration,
    NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN inventory i ON f.film_id = i.film_id
LEFT JOIN rental r ON i.inventory_id = r.inventory_id
GROUP BY f.title, c.name, f.rental_duration
ORDER BY standard_quartile, title;