with

ratings as (
    select * from {{ ref('int_weighted_ratings') }}
),

final as (
     select rating_id,
            coffee_id,
            rated_at,
            rating,
            rating_age,
            weight,
            weighted_rating
       from ratings
)

select * from final
