SELECT * FROM {{ source('cloud_sql_postgresql', 'payments') }}
WHERE payment_sequential IS NOT NULL
  AND payment_type IS NOT NULL
  AND payment_installments IS NOT NULL
  AND payment_value IS NOT NULL
  AND order_id IS NOT NULL