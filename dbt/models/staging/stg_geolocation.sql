SELECT 
    geolocation_zip_code_prefix,
    geolocation_state,
    geolocation_lat,
    geolocation_lng,
    geolocation_city
FROM {{ source('raw_data', 'geolocation') }}
WHERE geolocation_zip_code_prefix IS NOT NULL