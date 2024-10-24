with

coffees as (
    from {{ ref('stg_airtable__coffees') }}
),

flavor_profiles as (
  
     select distinct flavor_profile_key,
            unnest(flavor_ids) as flavor_id
          
       from coffees
      where flavor_ids is not null
   
)

from flavor_profiles
