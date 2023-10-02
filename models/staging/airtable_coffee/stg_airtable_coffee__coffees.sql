with source as ( select * from {{ source('airtable_coffee', 'coffees') }} ),

     renamed as (
         select _airtable_id as coffee_id,
                name as coffee_name,
                roaster,
                origin[1] as origin_id,
                region as country_region,
                varietal,
                case
                    when decaf then 'Decaf'
                    else 'Regular'
                    end as caffeine_content,
                roast as roast_darkness,
                process,
                cast(coalesce(elevation__min_, elevation__max_) as integer) as elevation_min,
                cast(coalesce(elevation__max_, elevation__min_) as integer) as elevation_max,
                flavors as flavor_ids,
                md5(array_to_string(flavors, '_')) as flavor_profile_key,
                created.member0 as added_at,
                _airtable_created_time
           from source
     )

select * from renamed
