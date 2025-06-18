-- Because this is not a true dataset, we will not use to build a table, order_id in 
SELECT
    o.order_id,
    o.purchased_at,
    SUM(oi.price) AS order_products_price,
    SUM(oi.freight_value) AS order_freight_value,
    COUNT(oi.order_item_id) AS total_items_in_order
FROM {{ ref('stg_orders') }} o
JOIN {{ ref('stg_order_items') }} oi
    ON o.order_id = oi.order_id
GROUP BY
    o.order_id,
    o.purchased_at