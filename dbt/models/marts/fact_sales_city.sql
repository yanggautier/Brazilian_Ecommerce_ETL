SELECT
    oi.order_item_id,
    oi.product_id,
    s.seller_id,
    s.seller_city,
    s.seller_state,
    oi.price,
    oi.freight_value
FROM {{ ref('stg_order_items') }} oi
JOIN {{ ref('dim_sellers') }} s
    ON oi.seller_id = s.seller_id
