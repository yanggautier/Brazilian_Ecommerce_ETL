SELECT * FROM {{ source('cloud_sql_postgresql', 'order_items') }}
WHERE order_id IS NOT NULL
  AND order_item_id IS NOT NULL
  AND product_id IS NOT NULL
  AND seller_id IS NOT NULL