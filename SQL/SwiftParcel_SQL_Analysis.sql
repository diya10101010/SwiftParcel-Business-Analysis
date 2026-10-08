-- 1. Total orders
SELECT 
    COUNT(*) AS total_orders
FROM Orders_Raw;


-- 2. Total revenue
SELECT 
    SUM("order_value") AS total_revenue
FROM Orders_Raw;


-- 3. Average order value
SELECT 
    AVG("order_value") AS average_order_value
FROM Orders_Raw;


-- 4. Key Business KPIs
SELECT
    COUNT(*) AS total_orders,
    SUM(order_value) AS total_revenue,
    AVG(order_value) AS average_order_value
FROM Orders_Raw;


-- 5. Revenue and orders by region
SELECT
    region,
    COUNT(*) AS total_orders,
    SUM(order_value) AS total_revenue,
    AVG(order_value) AS average_order_value
FROM Orders_Raw
GROUP BY region
ORDER BY total_revenue DESC;


-- 6. Check warehouse table columns
PRAGMA table_info(Warehouses);


-- 7. Warehouse performance
SELECT
    w.warehouse_name,
    w.region,
    COUNT(o.warehouse_id) AS total_orders,
    SUM(o.order_value) AS total_revenue,
    AVG(o.order_value) AS average_order_value
FROM Orders_Raw o
JOIN Warehouses w
    ON o.warehouse_id = w.warehouse_id
GROUP BY
    w.warehouse_name,
    w.region
ORDER BY total_revenue DESC;


-- 8. Check customer table columns
PRAGMA table_info(Customers);


-- 9. Customer type performance
SELECT
    c.customer_type,
    COUNT(o.customer_id) AS total_orders,
    SUM(o.order_value) AS total_revenue,
    AVG(o.order_value) AS average_order_value
FROM Orders_Raw o
JOIN Customers c
    ON o.customer_id = c.customer_id
GROUP BY c.customer_type
ORDER BY total_revenue DESC;


-- 10. Check delivery delay column
PRAGMA table_info(Orders_Raw);


-- 11. Overall delivery delay rate
SELECT
    COUNT(*) AS total_orders,
    SUM(delayed_flag) AS delayed_orders,
    ROUND(100.0 * SUM(delayed_flag) / COUNT(*), 2) AS delay_rate_percent,
    ROUND(AVG(delay_days), 2) AS average_delay_days
FROM Orders_Raw;


-- 12. Delivery delay by customer type
SELECT
    customer_type,
    COUNT(*) AS total_orders,
    SUM(delayed_flag) AS delayed_orders,
    ROUND(100.0 * SUM(delayed_flag) / COUNT(*), 2) AS delay_rate_percent
FROM Orders_Raw
GROUP BY customer_type
ORDER BY delay_rate_percent DESC;


-- 13. Customer satisfaction metrics
SELECT
    ROUND(AVG(customer_rating), 2) AS average_customer_rating,
    SUM(complaint_flag) AS total_complaints,
    ROUND(100.0 * SUM(complaint_flag) / COUNT(*), 2) AS complaint_rate_percent
FROM Orders_Raw;


-- 14. Customer satisfaction by customer type
SELECT
    customer_type,
    ROUND(AVG(customer_rating), 2) AS average_rating,
    SUM(complaint_flag) AS total_complaints,
    ROUND(100.0 * SUM(complaint_flag) / COUNT(*), 2) AS complaint_rate_percent
FROM Orders_Raw
GROUP BY customer_type
ORDER BY complaint_rate_percent DESC;


-- 15. Delivery method performance
SELECT
    delivery_method,
    COUNT(*) AS total_orders,
    SUM(order_value) AS total_revenue,
    ROUND(AVG(order_value), 2) AS average_order_value,
    ROUND(100.0 * SUM(delayed_flag) / COUNT(*), 2) AS delay_rate_percent
FROM Orders_Raw
GROUP BY delivery_method
ORDER BY total_orders DESC;


-- 16. Product category performance
SELECT
    product_category,
    COUNT(*) AS total_orders,
    SUM(order_value) AS total_revenue,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM Orders_Raw
GROUP BY product_category
ORDER BY total_revenue DESC;


-- 17. Monthly revenue performance
SELECT
    strftime('%Y-%m', order_date) AS month,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM Orders_Raw
GROUP BY strftime('%Y-%m', order_date)
ORDER BY month;


-- 18. Top 10 customers by revenue
SELECT
    customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM Orders_Raw
GROUP BY customer_id
ORDER BY total_revenue DESC
LIMIT 10;


-- 19. Top 10 customers by order frequency
SELECT
    customer_id,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM Orders_Raw
GROUP BY customer_id
ORDER BY total_orders DESC, total_revenue DESC
LIMIT 10;


-- 20. Revenue by region and product category
SELECT
    region,
    product_category,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM Orders_Raw
GROUP BY
    region,
    product_category
ORDER BY
    region,
    total_revenue DESC;
    
    
-- 21. Delivery performance by warehouse
SELECT
    w.warehouse_name,
    w.region,
    COUNT(o.order_id) AS total_orders,
    SUM(o.delayed_flag) AS delayed_orders,
    ROUND(100.0 * SUM(o.delayed_flag) / COUNT(*), 2) AS delay_rate_percent,
    ROUND(AVG(o.delay_days), 2) AS average_delay_days
FROM Orders_Raw o
JOIN Warehouses w
    ON o.warehouse_id = w.warehouse_id
GROUP BY
    w.warehouse_name,
    w.region
ORDER BY delay_rate_percent DESC;


-- 22. Customer performance by age group
SELECT
    c.age_group,
    COUNT(o.order_id) AS total_orders,
    ROUND(SUM(o.order_value), 2) AS total_revenue,
    ROUND(AVG(o.order_value), 2) AS average_order_value
FROM Orders_Raw o
JOIN Customers c
    ON o.customer_id = c.customer_id
GROUP BY c.age_group
ORDER BY total_revenue DESC;


-- 23. Order status performance
SELECT
    order_status,
    COUNT(*) AS total_orders,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM Orders_Raw), 2) AS percentage_of_orders,
    ROUND(SUM(order_value), 2) AS total_revenue
FROM Orders_Raw
GROUP BY order_status
ORDER BY total_orders DESC;


-- 24. Revenue contribution by delivery method
SELECT
    delivery_method,
    COUNT(*) AS total_orders,
    ROUND(100.0 * COUNT(*) / (SELECT COUNT(*) FROM Orders_Raw), 2) AS order_share_percent,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(100.0 * SUM(order_value) / (SELECT SUM(order_value) FROM Orders_Raw), 2) AS revenue_share_percent
FROM Orders_Raw
GROUP BY delivery_method
ORDER BY total_revenue DESC;


-- 25. Customer type by delivery method
SELECT
    customer_type,
    delivery_method,
    COUNT(*) AS total_orders,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(AVG(order_value), 2) AS average_order_value
FROM Orders_Raw
GROUP BY
    customer_type,
    delivery_method
ORDER BY
    customer_type,
    total_orders DESC;
    
    
    -- 26. Executive KPI summary
SELECT
    COUNT(*) AS total_orders,
    ROUND(SUM(order_value), 2) AS total_revenue,
    ROUND(AVG(order_value), 2) AS average_order_value,
    SUM(delayed_flag) AS delayed_orders,
    ROUND(100.0 * SUM(delayed_flag) / COUNT(*), 2) AS delay_rate_percent,
    ROUND(AVG(customer_rating), 2) AS average_customer_rating,
    SUM(complaint_flag) AS total_complaints,
    ROUND(100.0 * SUM(complaint_flag) / COUNT(*), 2) AS complaint_rate_percent
FROM Orders_Raw;