-- Question 3
-- Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.
-- Check your solution:
-- The customer Eleanor Hunt paid the maximum difference of $64.87 during March 2007 from $22.95 in February of 2007.
-- HINT: You can build on the previous questions query to add Window functions and aggregations to get the solution.

WITH top_10_customers AS (
    SELECT 
        c.customer_id,
        CONCAT(c.first_name, ' ', c.last_name) AS customer_name,
        SUM(p.amount) AS total_spent
    FROM payment p
    JOIN customer c ON p.customer_id = c.customer_id
    WHERE p.payment_date >= '2007-01-01' AND p.payment_date < '2008-01-01'
    GROUP BY c.customer_id, c.first_name, c.last_name
    ORDER BY total_spent DESC
    LIMIT 10
),
monthly_payments AS (
    SELECT 
        tc.customer_id,
        tc.customer_name,
        EXTRACT(YEAR FROM p.payment_date) AS payment_year,
        EXTRACT(MONTH FROM p.payment_date) AS payment_month,
        SUM(p.amount) AS total_payment
    FROM top_10_customers tc
    JOIN payment p ON tc.customer_id = p.customer_id
    WHERE p.payment_date >= '2007-01-01' AND p.payment_date < '2008-01-01'
    GROUP BY tc.customer_id, tc.customer_name, payment_year, payment_month
),
payment_differences AS (
    SELECT 
        customer_name,
        payment_year,
        payment_month,
        total_payment,
        LAG(total_payment) OVER (PARTITION BY customer_id ORDER BY payment_year, payment_month) AS previous_month_payment,
        total_payment - LAG(total_payment) OVER (PARTITION BY customer_id ORDER BY payment_year, payment_month) AS payment_difference
    FROM monthly_payments
)
SELECT 
    customer_name,
    payment_year,
    payment_month,
    total_payment,
    previous_month_payment,
    payment_difference
FROM payment_differences
ORDER BY ABS(payment_difference) DESC NULLS LAST, customer_name, payment_year, payment_month;