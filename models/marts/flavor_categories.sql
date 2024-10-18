with

categories as (
    select * from {{ ref('int_flavor_categories_unnested') }}
),

select_columns as (
  
     select flavor_category_group_key,
            flavor_category
            
       from categories
       
)

select * from select_columns
