with

source as (
    from {{ source('bean_counter', 'tasting_notes') }}
),

renamed as (

     select note_id,
            bean_id,
            cup_id,
            source     as note_source,
            position   as note_position,
            verbatim,
            normalized,
            facets,
            is_confirmed,
            resolution_confidence,
            created_at as added_at

       from source

)

from renamed
