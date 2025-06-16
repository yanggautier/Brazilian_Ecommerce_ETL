SELECT * FROM {{ source('cloud_sql_postgresql', 'reviews') }}
WHERE 
    review_id IS NOT NULL
    AND order_id IS NOT NULL
    AND review_id IS NOT NULL