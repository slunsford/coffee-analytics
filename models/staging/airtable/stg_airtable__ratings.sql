with

source as (
    select * from {{ source('airtable', 'ratings') }}
),

renamed as (
    
     select id as rating_id,
            {{ extract_id('coffee') }} as coffee_id,
            date as rated_date,
            rating,
            brew_method,
            _fivetran_synced
            
       from source
       
)

select * from renamed
