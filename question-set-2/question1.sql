-- Question 1:
-- We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. ** **
-- Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.
-- Check Your Solution
-- The following table header provides a preview of what your table should look like. The count of rental orders is sorted in descending order.
-- HINT: One way to solve this query is the use of aggregations.

WITH store_rentals AS (
    -- Subquery para juntar as tabelas e obter os dados brutos de aluguel por loja
    SELECT 
        r.rental_date,
        i.store_id,
        r.rental_id
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
)
-- Consulta principal que agrega os dados da subquery
SELECT 
    TRIM(TO_CHAR(sr.rental_date, 'Month')) AS rental_month, -- Usa TO_CHAR para o nome do mês e TRIM para remover espaços
    EXTRACT(YEAR FROM sr.rental_date) AS rental_year,
    sr.store_id,
    COUNT(sr.rental_id) AS count_rentals
FROM store_rentals sr
GROUP BY rental_year, rental_month, EXTRACT(MONTH FROM sr.rental_date), sr.store_id -- Agrupa pelo nome e número do mês
ORDER BY rental_year, EXTRACT(MONTH FROM sr.rental_date), count_rentals DESC; -- Ordena pelo número do mês