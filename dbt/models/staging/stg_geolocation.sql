SELECT * FROM {{ source('cloud_sql_postgresql', 'geolocation') }}
WHERE geolocation_zip_code_prefix IS NOT NULL