with

source as (
    from {{ source('bean_counter', 'cups') }}
),

renamed as (

     select cup_id,
            external_ref     as legacy_cup_ref,
            bean_id,
            brewed_at,
            brewed_at::date  as brewed_date,
            method           as brew_method,
            verdict,
            verdict_value,
            dose_g,
            yield_g,
            water_temp_c,
            brew_time_s,
            grind_setting,
            grinder,
            acidity_score,
            body_score,
            sweetness_score,
            bitterness_score,
            comment,
            created_at       as added_at,
            modified_at

       from source

)

from renamed
