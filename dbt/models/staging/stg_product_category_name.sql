SELECT
  product_category_name,
  product_category_name_english
FROM {{ source('raw_data', 'product_category_name_translation') }}
WHERE product_category_name IS NOT NULL
  AND product_category_name_english IS NOT NULL