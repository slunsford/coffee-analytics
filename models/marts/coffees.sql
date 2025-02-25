with

coffees as (
    from {{ ref('stg_collections__coffees') }}
),

origins as (
    from {{ ref('stg_collections__origins') }}
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

final as (

     select coffee_id,
            coffee_name,
            origin_id,
            coalesce(country, '[Blend]') as country,
            coalesce(world_region, '[Blend]') as world_region,
            country_region,
            roaster_id,
            roaster,
            is_available,
            case when is_available then 'Available'
                                   else 'Unavailable'
                  end as availability,
            rating,
            rating_value,
            rating_value = 1 as is_liked,
            rating_value = -1 as is_disliked,
            rated_date,
            is_decaf,
            case when is_decaf then 'Decaf'
                               else 'Regular'
                  end as caffeine_content,
            case when is_decaf then '😴' else '😵‍💫' end as caffeine_emoji,
            roast_darkness,
            varietals,
            coalesce(process, '[Unknown]') as process,
            elevation_min,
            elevation_max,
            elevation,
            flavor_profile_key,
            added_at,
            join_to_elevations.modified_at

       from join_to_elevations
  left join origins
      using (origin_id)

)

from final
