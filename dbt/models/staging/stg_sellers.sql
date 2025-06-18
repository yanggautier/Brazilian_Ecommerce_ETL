SELECT
    seller_id,
    seller_zip_code_prefix,
    seller_city,
    seller_state
FROM {{ source('raw_data', 'sellers') }}
WHERE 
    seller_id IS NOT NULL
    AND seller_zip_code_prefix IS NOT NULL