with

source as (
    from {{ source('collections', 'coffees') }}
),

renamed as (
    
     select short_id as coffee_id,
            name as coffee_name,
            origin,
            region as country_region,
            roaster,
            available = 'Yes' as is_available,
            case when available then 'Available'
                                else 'Unavailable'
                  end as availability,
            favorite = 'Yes' as is_favorite,
            rating,
            rated_date,
            decaf = 'Yes' as is_decaf,
            case when decaf then 'Decaf'
                            else 'Regular'
                  end as caffeine_content,
            coalesce(roast, 'Unknown') as roast_darkness,
            varietals,
            coalesce(process, 'Unknown') as process,
            coalesce(elevation_min, elevation_max) as elevation_min,
            coalesce(elevation_max, elevation_min) as elevation_max,
            case when flavors is not null then {{ dbt_utils.generate_surrogate_key(['flavors']) }} end as flavor_profile_key,
            string_split(flavors, ';') as flavors,
            coalesce(created, creation_date) as added_at,
            modified_date as modified_at
            
       from source
      where rating is not null
       
)

from renamed
