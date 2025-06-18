{{
  config(
    materialized = 'table',
    )
}}
SELECT
    s.seller_id,
    s.seller_zip_code_prefix,
    s.seller_city,
    s.seller_state,
    g.geolocation_lat AS seller_latitude, 
    g.geolocation_lng AS seller_longitude
FROM {{ ref('stg_sellers') }} s
LEFT JOIN {{ ref('stg_geolocation') }} g ON s.seller_zip_code_prefix = g.geolocation_zip_code_prefix
WHERE g.geolocation_city = s.seller_city AND g.geolocation_state = s.seller_state