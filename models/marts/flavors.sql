with

flavors as (
    from {{ ref('stg_airtable__flavors') }}
),

flavor_profiles as (
    from {{ ref('int_flavor_profiles_unnested') }}
),

select_columns as (
  
     select flavor_id,
            flavor,
            flavor_category_group_key,
            flavor_categories[1] as primary_flavor_category,
            list_aggregate(flavor_categories, 'string_agg', ', ') as flavor_categories
            
       from flavors
      where flavor_id in (select distinct flavor_id from flavor_profiles)
       
)

select * from select_columns
