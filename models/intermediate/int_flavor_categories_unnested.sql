with

flavors as (
    from {{ ref('stg_collections__flavors') }}
),

flavor_profiles as (
    from {{ ref('int_flavor_profiles_unnested') }}
),

unnest_categories as (
  
     select distinct flavor_category_group_key,
            unnest(flavor_categories_list) as flavor_category
            
       from flavors
      where flavor_id in (select distinct flavor_id from flavor_profiles)
       
)

from unnest_categories
