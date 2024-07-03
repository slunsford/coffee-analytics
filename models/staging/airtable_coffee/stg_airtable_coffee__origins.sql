with source as ( select * from {{ source('airtable_coffee', 'origins') }} ),

     renamed as (
         select id as origin_id,
                name as country_name,
                -- flag,
                region as world_region,
                -- coffees,
                -- rating,
                _fivetran_synced
           from source
     )

select * from renamed
