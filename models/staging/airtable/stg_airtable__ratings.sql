with

source as (
    select * from {{ source('airtable', 'ratings') }}
),

renamed as (
    
     select id as rating_id,
            date as rated_date,
            regexp_extract(coffee, 'rec\w+') as coffee_id,
            brew_method,
            rating,
            _fivetran_synced
            
       from source
       
)

select * from renamed
