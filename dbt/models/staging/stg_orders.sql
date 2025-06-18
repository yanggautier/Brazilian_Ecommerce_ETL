SELECT 
  order_status,
  order_id,
  order_purchase_timestamp AS purchased_at,
  order_delivered_customer_date AS customer_delivered_at,
  order_estimated_delivery_date AS estimated_delivery_at,
  customer_id,
  order_delivered_carrier_date AS carrier_delivered_at,
  order_approved_at AS approved_at
FROM  {{ source('raw_data', 'orders') }}
WHERE order_id IS NOT NULL
  AND customer_id IS NOT NULL
  AND order_status IN ('delivered', 'shipped', 'invoiced', 'processing', 'approved') 
