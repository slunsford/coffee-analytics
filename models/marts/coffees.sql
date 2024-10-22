with

coffees as (
    select * from {{ ref('stg_airtable__coffees') }}
),

origins as (
    select * from {{ ref('stg_airtable__origins') }}
),

roasters as (
    select * from {{ ref('stg_airtable__roasters') }}
),

elevations as (
  
     select coffee_id,
            case when elevation_max > elevation_min then elevation_min || '–' || elevation_max || 'm'
                 else elevation_min || 'm'
             end as elevation
             
       from coffees
      
),

join_to_elevations as (
  
     select * replace(coalesce(elevation, 'Unknown') as elevation)
     
       from coffees
  left join elevations
      using (coffee_id)
      
),

join_to_origins_and_roasters as (
  
    select coffee_id,
           coffee_name,
           roaster_id,
           roaster_name as roaster,
           origin_id,
           coalesce(country_name, '[Blend]') as country,
           coalesce(world_region, '[Blend]') as world_region,
           country_region,
           is_available,
           availability,
           is_decaf,
           caffeine_content,
           case when is_decaf then '😴' else '😵‍💫' end as caffeine_emoji,
           roast_darkness,
           varietals,
           process,
           elevation_min,
           elevation_max,
           elevation,
           flavor_profile_key,
           is_favorite,
           case when is_favorite then '⭐️' else '' end as favorite_emoji,
           added_at,
           
      from join_to_elevations
 left join origins
     using (origin_id)
 left join roasters
     using (roaster_id)
        
)

select * from join_to_origins_and_roasters
