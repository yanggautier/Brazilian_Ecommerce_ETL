SELECT
  product_id,
  product_category_name,
  product_height_cm,
  product_length_cm,
  product_width_cm,
  product_weight_g,
  product_photos_qty,
  product_name_lenght,
  product_description_lenght
FROM {{ source('raw_data', 'products') }}
WHERE product_category_name IS NOT NULL
  AND product_id IS NOT NULL