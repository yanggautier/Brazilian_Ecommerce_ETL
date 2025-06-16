SELECT * FROM {{ source('cloud_sql_postgresql', 'products') }}
WHERE product_category_name IS NOT NULL
  AND product_id IS NOT NULL