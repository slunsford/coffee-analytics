with

flavors as (
    select * from {{ ref('stg_airtable__flavors') }}
),

select_columns as (
  
     select flavor_id,
            flavor,
            flavor_category_group_key,
            flavor_categories[1] as primary_flavor_category,
            list_aggregate(flavor_categories, 'string_agg', ', ') as flavor_categories
            
       from flavors
       
)

select * from select_columns
