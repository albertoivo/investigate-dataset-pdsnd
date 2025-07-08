-- Question 3
-- Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. The resulting table should have three columns:
-- Category
-- Rental length category
-- Count
-- Check Your Solution
-- The following table header provides a preview of what your table should look like. The Count column should be sorted first by Category and then by Rental Duration category.
-- HINT: One way to solve this question requires the use of Percentiles, Window functions and Case statements.

WITH family_friendly_films AS (
    -- Subquery to select only family-friendly film categories
    SELECT 
        f.film_id,
        f.rental_duration,
        c.name AS category_name
    FROM film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music')
)
-- Main query that operates on the result of the subquery
SELECT 
    fff.category_name,
    CASE 
        WHEN fff.rental_duration <= (SELECT PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY rental_duration) FROM film) THEN '1'
        WHEN fff.rental_duration <= (SELECT PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY rental_duration) FROM film) THEN '2'
        WHEN fff.rental_duration <= (SELECT PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY rental_duration) FROM film) THEN '3'
        ELSE '4'
    END AS standard_quartile,
    COUNT(fff.film_id) AS film_count
FROM family_friendly_films fff
GROUP BY fff.category_name, standard_quartile
ORDER BY fff.category_name, standard_quartile;