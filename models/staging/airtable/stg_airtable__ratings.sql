with

source as (
    from {{ source('airtable', 'ratings') }}
),

renamed as (
    
     select id as rating_id,
            {{ extract_id('coffee') }} as coffee_id,
            date as rated_date,
            rating,
            rating = 'Liked' as is_liked,
            brew_method,
            _fivetran_synced
            
       from source
       
)

from renamed
