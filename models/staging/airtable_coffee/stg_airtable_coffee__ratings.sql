with source as ( select * from {{ source('airtable_coffee', 'ratings') }} ),

     renamed as (
         select _airtable_id as rating_id,
                coffee[1] as coffee_id,
                date[1].member0 as rating_date,
                rating,
                -- date_override as rating_date_override,
                _airtable_created_time
           from source
     )

select * from renamed
