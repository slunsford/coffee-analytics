with source as ( select * from {{ source('coffee', 'coffees') }} ),

     renamed as (
         select _airtable_id as coffee_id,
                name,
                roaster,
                regexp_extract(origin, 'rec\w+') as origin_id,
                -- country,
                region as country_region,
                varietal,
                case
                    when decaf then 'Decaf'
                    else 'Regular'
                    end as caffeine_content,
                roast as roast_darkness,
                process,
                elevation__min_ as elevation_min,
                elevation__max_ as elevation_max,
                -- flag,
                flavors as flavor_ids,
                -- flavor_categories,
                -- rating,
                -- numeric_rating,
                -- rating_date,
                -- star_rating,
                -- rating_date_star_,
                -- average_rating,
                -- ratings,
                created as date_added,
                _airtable_created_time
           from source
     )

select * from renamed
