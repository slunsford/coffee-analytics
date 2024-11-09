with

coffees as (
    from {{ ref('int_coffees_filtered_to_current') }}
),

flavors as (
    from {{ ref('stg_collections__flavors') }}
),

unnest_flavors as (
  
     select distinct flavor_profile_key,
            unnest(flavors) as flavor
          
       from coffees
      where flavors is not null
   
),

join_to_flavor_ids as (
  
     select flavor_profile_key,
            flavor_id
          
       from unnest_flavors
       join flavors
      using (flavor)
      
)

from join_to_flavor_ids
