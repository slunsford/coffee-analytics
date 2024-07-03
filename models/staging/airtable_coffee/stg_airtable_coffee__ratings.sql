with source as ( select * from {{ source('airtable_coffee', 'ratings') }} ),

     renamed as (
         select id as rating_id,
                date.member0 as rated_date,
                coffee[1] as coffee_id,
                rating,
                _fivetran_synced
           from source
     )

select * from renamed
