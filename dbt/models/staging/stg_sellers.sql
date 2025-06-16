SELECT * FROM {{ source('cloud_sql_postgresql', 'sellers') }}
WHERE 
    seller_id IS NOT NULL
    AND seller_zip_code_prefix IS NOT NULL