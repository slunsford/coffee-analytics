with

coffees as (
    from {{ ref('stg_collections__coffees') }}
),

roasters as (
    from {{ ref('stg_collections__roasters') }}
),

origins as (
    from {{ ref('stg_collections__origins') }}
),

join_to_roasters_and_origins as (
  
     select coffees.*,
            roaster_id,
            origin_id,
            world_region
            
       from coffees
  left join roasters
         on coffees.roaster = roasters.roaster_name
  left join origins
      using (country)
      
)

from join_to_roasters_and_origins
