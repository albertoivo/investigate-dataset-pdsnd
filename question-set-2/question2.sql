-- We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007, and what was the amount of the monthly payments. Can you write a query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers?
-- Check your Solution:
-- The following table header provides a preview of what your table should look like. The results are sorted first by customer name and then for each month. As you can see, total amounts per month are listed for each customer.
-- HINT: One way to solve is to use a subquery, limit within the subquery, and use concatenation to generate the customer name.
SELECT 
    EXTRACT(MONTH FROM p.payment_date) AS pay_mon,
    CONCAT(c.first_name, ' ', c.last_name) AS fullname,
    EXTRACT(YEAR FROM p.payment_date) AS pay_counterpermon,
    SUM(p.amount) AS total_payment
FROM payment p
JOIN customer c ON p.customer_id = c.customer_id
WHERE p.payment_date >= '2007-01-01' AND p.payment_date < '2008-01-01'
GROUP BY c.customer_id, fullname, pay_mon, pay_counterpermon
ORDER BY fullname, pay_counterpermon, pay_mon
LIMIT 10;
