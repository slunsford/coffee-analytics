with

collections_coffees as (
    from {{ ref('int_coffees_filtered_to_current') }}
),

airtable_coffees as (
    from {{ ref('stg_airtable__coffees') }}
),

airtable_roasters as (
    from {{ ref('stg_airtable__roasters') }}
),

airtable_ratings as (
    from {{ ref('stg_airtable__ratings') }}
),

join_airtable_models as (
  
     select coffee_name,
            roaster_name as roaster,
            airtable_ratings.*
            
       from airtable_ratings
       join airtable_coffees
      using (coffee_id)
       join airtable_roasters
      using (roaster_id)
      
),

join_airtable_to_coffee_id as (
    
     select distinct coffees.coffee_id,
            coffees.flavor_profile_key,
            ratings.rated_date,
            ratings.rating,
            ratings._fivetran_synced as modified_at
            
       from join_airtable_models as ratings
       join collections_coffees as coffees
      using (coffee_name, roaster)
      
),

dedupe_ratings as (
    
    {{ dbt_utils.deduplicate(
        relation = 'join_airtable_to_coffee_id',
        partition_by = 'coffee_id, rated_date',
        order_by = 'modified_at desc'
    ) }}
)

from dedupe_ratings
