SELECT * FROM {{ source('cloud_sql_postgresql', 'product_category_name_translation') }}
WHERE product_category_name IS NOT NULL
  AND product_category_name_english IS NOT NULL