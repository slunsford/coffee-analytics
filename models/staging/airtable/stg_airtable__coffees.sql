with

source as (
    select * from {{ source('airtable', 'coffees') }}
),

renamed as (
    
     select id as coffee_id,
            name as coffee_name,
            {{ extract_id('roaster') }} as roaster_id,
            {{ extract_id('origin') }} as origin_id,
            region as country_region,
            coalesce(available, false) as is_available,
            case when available then 'Available'
                                else 'Unavailable'
                  end as availability,
            coalesce(decaf, false) as is_decaf,
            case when decaf then 'Decaf'
                            else 'Regular'
                  end as caffeine_content,
            coalesce(roast, 'Unknown') as roast_darkness,
            varietal as varietals,
            coalesce(process, 'Unknown') as process,
            coalesce(elevation_min_, elevation_max_)::integer as elevation_min,
            coalesce(elevation_max_, elevation_min_)::integer as elevation_max,
            {{ extract_ids('flavors') }} as flavor_ids,
            {{ dbt_utils.generate_surrogate_key(['flavor_ids']) }} as flavor_profile_key,
            coalesce(favorite, false) as is_favorite,
            -- rating,
            -- rated_date,
            created as added_at,
            _fivetran_synced
            
       from source
       
)

select * from renamed
