with

source as (
    from {{ source('collections', 'roasters') }}
),

renamed as (

     select roaster_id,
            name as roaster_name,
            website,
            modified_date as modified_at

       from source

)

from renamed
