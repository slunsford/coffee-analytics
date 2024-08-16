with

source as (
    select * from {{ source('airtable', 'ratings') }}
),

renamed as (
    
     select id as rating_id,
            date as rated_date,
            coffee[1] as coffee_id,
            brew_method,
            rating,
            _fivetran_synced
            
       from source
       
)

select * from renamed
