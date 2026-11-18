with

source as (
    from {{ source('bean_counter', 'tasting_note_flavors') }}
),

renamed as (

     select note_id,
            flavor_slug

       from source

)

from renamed
