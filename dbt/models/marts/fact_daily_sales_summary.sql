{{
  config(
    materialized = 'table',
    )
}}

SELECT
    DATE(od.purchased_at) AS sales_date,
    COUNT(DISTINCT od.order_id) AS total_orders,
    SUM(od.order_products_price + od.order_freight_value) AS total_revenue,
    SUM(od.total_items_in_order) AS total_items_sold,
    SUM(opa.total_payment_value) AS total_payments_received
FROM {{ ref('int_order_details') }} od
LEFT JOIN {{ ref('int_order_payments_aggregated') }} opa
    ON od.order_id = opa.order_id
GROUP BY
    DATE(od.purchased_at)
ORDER BY
    sales_date