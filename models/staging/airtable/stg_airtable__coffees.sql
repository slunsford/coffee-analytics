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
            available as is_available,
            case when available then 'Available'
                                else 'Unavailable'
                  end as availability,
            decaf as is_decaf,
            case when decaf then 'Decaf'
                            else 'Regular'
                  end as caffeine_content,
            roast as roast_darkness,
            varietal as varietals,
            process,
            cast(coalesce(elevation_min_, elevation_max_) as integer) as elevation_min,
            cast(coalesce(elevation_max_, elevation_min_) as integer) as elevation_max,
            {{ extract_ids('flavors') }} as flavor_ids,
            {{ dbt_utils.generate_surrogate_key(['flavor_ids']) }} as flavor_profile_key,
            -- rating,
            -- rated_date,
            created as added_at,
            _fivetran_synced
            
       from source
       
)

select * from renamed
