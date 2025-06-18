SELECT 
    order_id,
    SUM(payment_value) AS total_payment_value,
    COUNT(DISTINCT(payment_type)) AS total_payment_types,
FROM {{ ref('stg_payments') }}
GROUP BY order_id