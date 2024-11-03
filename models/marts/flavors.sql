with

flavors as (
    from {{ ref('stg_collections__flavors') }}
),

flavor_profiles as (
    from {{ ref('int_flavor_profiles_unnested') }}
),

select_columns as (
  
     select flavor_id,
            flavor,
            flavor_category_group_key,
            flavor_categories,
            flavor_categories_list[1] as primary_flavor_category,
            
       from flavors
      where flavor_id in (select distinct flavor_id from flavor_profiles)
       
)

from select_columns
