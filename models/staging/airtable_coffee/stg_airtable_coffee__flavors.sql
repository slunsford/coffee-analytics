with source as ( select * from {{ source('airtable_coffee', 'flavors') }} ),

     renamed as (
         select _airtable_id as flavor_id,
                flavor,
                coalesce(category, 'Uncategorized') as flavor_category,
                -- coffees,
                -- rating,
                -- _coffees,
                -- ratings_from_coffees_,
                _airtable_created_time
           from source
     )

select * from renamed
