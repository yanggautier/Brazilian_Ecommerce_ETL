SELECT 
    customer_id,
    customer_unique_id,
    customer_zip_code_prefix,
    customer_city,
    customer_state
FROM {{ source('raw_data', 'customers') }}
WHERE 
    customer_id IS NOT NULL
    AND customer_unique_id IS NOT NULL
    AND customer_zip_code_prefix IS NOT NULL