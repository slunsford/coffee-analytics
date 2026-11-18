with

source as (
    from {{ source('bean_counter', 'roasters') }}
),

renamed as (

     select roaster_id,
            name       as roaster_name,
            website,
            location,
            notes,
            created_at as added_at

       from source

)

from renamed
