with

source as (
    from {{ source('collections', 'coffees') }}
),

renamed as (
    
     select coffee_id,
            name as coffee_name,
            origin_id,
            region as country_region,
            roaster_id,
            roaster,
            available = 'Yes' as is_available,
            case when available then 'Available'
                                else 'Unavailable'
                  end as availability,
            favorite = 'Yes' as is_favorite,
            rating,
            rating = 'Liked' as is_liked,
            case when rating is not null then coalesce(rated_date, modified_date::date) end as rated_date,
            decaf = 'Yes' as is_decaf,
            case when decaf then 'Decaf'
                            else 'Regular'
                  end as caffeine_content,
            roast as roast_darkness,
            varietals,
            process,
            coalesce(elevation_min, elevation_max) as elevation_min,
            coalesce(elevation_max, elevation_min) as elevation_max,
            case when flavors is not null then {{ dbt_utils.generate_surrogate_key(['flavors']) }} end as flavor_profile_key,
            string_split(flavors, '; ') as flavors,
            coalesce(created, creation_date) as added_at,
            modified_date as modified_at
            
       from source
      where rating is not null
       
)

from renamed
