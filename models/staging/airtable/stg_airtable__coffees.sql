with

source as (
    select * from {{ source('airtable', 'coffees') }}
),

renamed as (
    
     select id as coffee_id,
            name as coffee_name,
            roaster,
            regexp_extract(origin, 'rec\w+') as origin_id,
            region as country_region,
            case when available then 'Available'
                                else 'Unavailable'
                  end as availability,
            case when decaf then 'Decaf'
                            else 'Regular'
                  end as caffeine_content,
            roast as roast_darkness,
            regexp_extract_all(varietal, '\w+') as varietals,
            process,
            cast(coalesce(elevation_min_, elevation_max_) as integer) as elevation_min,
            cast(coalesce(elevation_max_, elevation_min_) as integer) as elevation_max,
            regexp_extract_all(flavors, 'rec\w+') as flavor_ids,
            {{ dbt_utils.generate_surrogate_key(['flavor_ids']) }} as flavor_profile_key,
            created as added_at,
            _fivetran_synced
            
       from source
       
)

select * from renamed
