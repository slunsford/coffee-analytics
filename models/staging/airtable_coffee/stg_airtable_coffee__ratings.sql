with source as ( select * from {{ source('airtable_coffee', 'ratings') }} ),

     renamed as (
         select _airtable_id as rating_id,
                date.member0 as rated_date,
                coffee[1] as coffee_id,
                brew_method,
                rating,
                _airtable_created_time
           from source
     )

select * from renamed
