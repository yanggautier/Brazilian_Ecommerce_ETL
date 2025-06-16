SELECT * FROM  {{ source('cloud_sql_postgresql', 'orders') }}
WHERE order_id IS NOT NULL
  AND customer_id IS NOT NULL
