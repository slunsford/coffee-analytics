with source as ( select * from {{ source('coffee', 'ratings') }} ),

     renamed as (
         select _airtable_id as rating_id,
                regexp_extract(coffee, 'rec\w+') as coffee_id,
                date as rating_date,
                rating,
                -- date_override as rating_date_override,
                _airtable_created_time
           from source
     )

select * from renamed
