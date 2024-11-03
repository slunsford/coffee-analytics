{{ config(
    enabled = false
) }}

with

ratings as (
    from {{ ref('stg_airtable__ratings') }}
),

coffees as (
    from {{ ref('stg_airtable__coffees') }}
),

join_to_coffees as (
    
     select rating_id,
            coffee_id,
            flavor_profile_key,
            brew_method,
            rated_date,
            rating,
            is_liked,
            case when is_liked then '👍🏻' else '👎🏻' end as rating_emoji,
            case when is_liked then 1 else -1 end as rating_value,
            row_number() over (partition by coffee_id order by rated_date desc) = 1 as is_current
            
       from ratings
       join coffees
      using (coffee_id)
       
)

from join_to_coffees
