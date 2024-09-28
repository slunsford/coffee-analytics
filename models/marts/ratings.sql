with

ratings as (
    select * from {{ ref('stg_airtable__ratings') }}
),

coffees as (
    select * from {{ ref('stg_airtable__coffees') }}
),

get_current_ratings as (
    
    {{ dbt_utils.deduplicate('ratings',
        partition_by = 'coffee_id',
        order_by = 'rated_date desc'
    ) }}
    
),

join_to_current_ratings as (
    
     select ratings.*,
            (get_current_ratings.rating_id is not null) as is_current
            
       from ratings
  left join get_current_ratings
      using (rating_id)
       
),

join_to_coffees as (
    
     select rating_id,
            coffee_id,
            flavor_profile_key,
            brew_method,
            ratings.rated_date,
            ratings.rating,
            is_current
            
       from join_to_current_ratings as ratings
       join coffees
      using (coffee_id)
       
)

select * from join_to_coffees
