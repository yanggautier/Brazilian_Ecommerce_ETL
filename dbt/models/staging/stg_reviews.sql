SELECT 
    review_id,
    review_creation_date,
    review_score,
    review_comment_title,
    review_answer_timestamp,
    order_id,
    review_comment_message
FROM {{ source('raw_data', 'reviews') }}
WHERE 
    review_id IS NOT NULL
    AND order_id IS NOT NULL
    AND review_id IS NOT NULL