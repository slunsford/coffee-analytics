with source as ( select * from {{ source('coffee', 'origins') }} ),

     renamed as (
         select _airtable_id as origin_id,
                name as country_name,
                -- flag,
                region as world_region,
                -- coffees,
                -- rating,
                _airtable_created_time
           from source
     )

select * from renamed
