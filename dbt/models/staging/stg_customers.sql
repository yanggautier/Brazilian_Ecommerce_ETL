SELECT * FROM {{ source('cloud_sql_postgresql', 'customers') }}
WHERE 
    customer_id IS NOT NULL
    AND customer_unique_id IS NOT NULL
    AND customer_zip_code_prefix IS NOT NULL