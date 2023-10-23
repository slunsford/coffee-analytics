with source as ( select * from {{ source('fivetran_coffee', 'flavors') }} ),

     renamed as (
         select id as flavor_id,
                flavor,
                coalesce(category, 'Uncategorized') as flavor_category,
                -- coffees,
                -- rating,
                -- _coffees,
                -- ratings_from_coffees_,
                _fivetran_synced
           from source
     )

select * from renamed
