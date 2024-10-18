with

flavors as (
    select * from {{ ref('stg_airtable__flavors') }}
),

unnest_categories as (
  
     select distinct flavor_category_group_key,
            unnest(flavor_categories) as flavor_category
            
       from flavors
       
)

select * from unnest_categories
