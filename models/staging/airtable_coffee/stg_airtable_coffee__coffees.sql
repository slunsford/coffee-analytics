with source as ( select * from {{ source('airtable_coffee', 'coffees') }} ),

     renamed as (
         select _airtable_id as coffee_id,
                name as coffee_name,
                roaster,
                origin[1] as origin_id,
                -- country,
                region as country_region,
                varietal,
                case
                    when decaf then 'Decaf'
                    else 'Regular'
                    end as caffeine_content,
                roast as roast_darkness,
                process,
                cast(elevation__min_ as integer) as elevation_min,
                cast(elevation__max_ as integer) as elevation_max,
                -- flag,
                flavors as flavor_ids,
                md5(array_to_string(flavors, '_')) as flavor_profile_key,
                -- flavor_categories,
                -- rating,
                -- numeric_rating,
                -- rating_date,
                -- star_rating,
                -- rating_date_star_,
                -- average_rating,
                -- ratings,
                created.member0 as date_added,
                _airtable_created_time
           from source
     )

select * from renamed
