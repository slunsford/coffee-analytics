with

flavors as (
    select * from {{ ref('stg_airtable__flavors') }}
),

flavors_with_ratings as (
  
     select flavor_id,
            flavor,
            -- flavor_category_group_key,
            list_aggregate(flavor_categories, 'string_agg', ', ') as flavor_categories
            
       from flavors
       
)

select * from flavors_with_ratings
