SELECT ROUND(SUM(payment_value), 2) AS total_revenue
FROM master_ecommerce;

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM master_ecommerce;

SELECT COUNT(DISTINCT customer_unique_id) AS total_customers
FROM master_ecommerce;

SELECT ROUND(SUM(payment_value) / COUNT(DISTINCT order_id), 2) AS average_order_value
FROM master_ecommerce;

SELECT ROUND(SUM(payment_value) / COUNT(DISTINCT customer_unique_id), 2) AS revenue_per_customer
FROM master_ecommerce;

SELECT DATE_TRUNC('month', order_purchase_timestamp) AS month, ROUND(SUM(payment_value), 2) AS revenue
FROM master_ecommerce
GROUP BY MONTH
ORDER BY month;

SELECT DATE_TRUNC('month', order_purchase_timestamp) AS month, COUNT(DISTINCT order_id) AS orders
FROM master_ecommerce
GROUP BY MONTH
ORDER BY month;

SELECT DATE_TRUNC('month', order_purchase_timestamp) AS month, COUNT(DISTINCT customer_unique_id) AS customers
FROM master_ecommerce
GROUP BY MONTH
ORDER BY month;

SELECT customer_state, ROUND(SUM(payment_value), 2) AS revenue
FROM master_ecommerce
GROUP BY customer_state
ORDER BY revenue DESC
LIMIT 10;

SELECT
    customer_city,
    ROUND(SUM(payment_value), 2) AS revenue
FROM master_ecommerce
GROUP BY customer_city
ORDER BY revenue DESC
LIMIT 10;


SELECT
    product_category_name,
    COUNT(DISTINCT order_id) AS orders
FROM master_ecommerce
GROUP BY product_category_name
ORDER BY orders DESC
LIMIT 10;


SELECT
    product_category_name,
    ROUND(SUM(payment_value), 2) AS revenue
FROM master_ecommerce
GROUP BY product_category_name
ORDER BY revenue DESC
LIMIT 10;

WITH customer_orders AS (
    SELECT
        customer_unique_id,
        COUNT(DISTINCT order_id) AS total_orders
    FROM master_ecommerce
    GROUP BY customer_unique_id
)

SELECT
    ROUND(
        (
            COUNT(
                CASE
                    WHEN total_orders > 1 THEN 1
                END
            )::NUMERIC
            /
            COUNT(*)
        ) * 100,
        2
    ) AS repeat_customer_rate
FROM customer_orders;

SELECT
    customer_unique_id,
    COUNT(DISTINCT order_id) AS total_orders,
    ROUND(SUM(payment_value), 2) AS revenue
FROM master_ecommerce
GROUP BY customer_unique_id
ORDER BY revenue DESC
LIMIT 20;


SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    EXTRACT(QUARTER FROM order_purchase_timestamp) AS quarter,
    ROUND(SUM(payment_value), 2) AS revenue
FROM master_ecommerce
GROUP BY year, quarter
ORDER BY year, quarter;


WITH monthly_revenue AS (
    SELECT
        DATE_TRUNC('month', order_purchase_timestamp) AS month,
        SUM(payment_value) AS revenue
    FROM master_ecommerce
    GROUP BY month
)

SELECT
    month,
    ROUND(revenue, 2) AS revenue,
    ROUND(
        (
            revenue -
            LAG(revenue) OVER(ORDER BY month)
        )
        /
        LAG(revenue) OVER(ORDER BY month)
        * 100,
        2
    ) AS growth_percentage
FROM monthly_revenue;

SELECT
    customer_state,
    ROUND(
        SUM(payment_value)
        /
        COUNT(DISTINCT order_id),
        2
    ) AS average_order_value
FROM master_ecommerce
GROUP BY customer_state
ORDER BY average_order_value DESC;


SELECT
    ROUND(
        AVG(
            EXTRACT(
                EPOCH FROM
                (
                    order_delivered_customer_date -
                    order_purchase_timestamp
                )
            ) / 86400
        ),
        2
    ) AS avg_delivery_days
FROM master_ecommerce
WHERE order_delivered_customer_date IS NOT NULL;


SELECT
    customer_state,
    ROUND(
        (
            SUM(payment_value)
            /
            SUM(SUM(payment_value)) OVER()
        ) * 100,
        2
    ) AS revenue_share_percentage
FROM master_ecommerce
GROUP BY customer_state
ORDER BY revenue_share_percentage DESC;


SELECT
    customer_unique_id,
    ROUND(SUM(payment_value), 2) AS revenue,
    RANK() OVER(
        ORDER BY SUM(payment_value) DESC
    ) AS customer_rank
FROM master_ecommerce
GROUP BY customer_unique_id
ORDER BY customer_rank
LIMIT 10;


SELECT
    payment_type,
    COUNT(*) AS transactions,
    ROUND(SUM(payment_value), 2) AS revenue
FROM master_ecommerce
GROUP BY payment_type
ORDER BY revenue DESC;

SELECT
    order_status,
    COUNT(*) AS total_orders
FROM master_ecommerce
GROUP BY order_status
ORDER BY total_orders DESC;

SELECT
    seller_id,
    ROUND(SUM(payment_value), 2) AS revenue
FROM master_ecommerce
GROUP BY seller_id
ORDER BY revenue DESC
LIMIT 10;

SELECT
    ROUND(AVG(freight_value), 2) AS avg_freight_cost
FROM master_ecommerce;

SELECT
    EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
    ROUND(SUM(payment_value), 2) AS revenue
FROM master_ecommerce
GROUP BY year
ORDER BY year;


Revenue analysis revealed strong business expansion between 2017 and 2018. Total revenue increased from 8.73 million to 10.74 million, representing approximately 23% year-over-year growth. The results indicate successful customer acquisition, increased marketplace adoption, and sustained business momentum. Due to limited transaction volume in 2016, subsequent years provide a more representative view of business performance.



