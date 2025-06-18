SELECT 
  order_id,
  payment_type,
  payment_value,
  payment_installments,
  payment_sequential
FROM {{ source('raw_data', 'payments') }}
WHERE payment_sequential IS NOT NULL
  AND payment_type IS NOT NULL
  AND payment_installments IS NOT NULL
  AND payment_value IS NOT NULL
  AND order_id IS NOT NULL