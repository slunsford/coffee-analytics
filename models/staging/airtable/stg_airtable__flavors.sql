with

source as (
    select * from {{ source('airtable', 'flavors') }}
),

renamed as (
    
     select id as flavor_id,
            flavor,
            coalesce(regexp_extract_all(categories, '"(.+?)"', 1), ['Uncategorized']) as flavor_categories,
            {{ dbt_utils.generate_surrogate_key(['flavor_categories']) }} as flavor_category_group_key,
            -- coffees,
            -- rating,
            -- _coffees,
            -- ratings_from_coffees_,
            _fivetran_synced
            
       from source
       
)

select * from renamed
