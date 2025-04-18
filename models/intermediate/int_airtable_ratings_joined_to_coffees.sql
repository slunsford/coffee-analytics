with

collections_coffees as (
    from {{ ref('stg_collections__coffees') }}
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

calculate_rating_value as (

     select *,
            {{ rating_value('rating') }} as rating_value,

       from join_airtable_to_coffee_id

),

dedupe_ratings as (

    {{ dedupe (
        relation = 'calculate_rating_value',
        partition_by = 'coffee_id, rated_date',
        order_by = 'modified_at desc'
    ) }}
)

from dedupe_ratings
