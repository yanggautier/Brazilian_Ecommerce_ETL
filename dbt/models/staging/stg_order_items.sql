SELECT
    order_item_id,
    price,
    product_id,
    order_id,
    freight_value,
    seller_id,
    shipping_limit_date
FROM {{ source('raw_data', 'order_items') }}
WHERE order_id IS NOT NULL
  AND order_item_id IS NOT NULL
  AND product_id IS NOT NULL
  AND seller_id IS NOT NULL