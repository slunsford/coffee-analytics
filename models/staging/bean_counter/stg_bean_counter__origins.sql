with

source as (
    from {{ source('bean_counter', 'origins') }}
),

renamed as (

     select origin_id,
            bean_id,
            position as origin_position,
            country,
            region,
            farm,
            producer,
            elevation_min_m,
            elevation_max_m,
            varietals,
            process,
            fermentation_modifiers,
            process_note,
            proportion

       from source

)

from renamed
