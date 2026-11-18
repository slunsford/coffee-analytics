with

source as (
    from {{ source('bean_counter', 'beans') }}
),

renamed as (

     select bean_id,
            external_ref         as legacy_coffee_id,
            name                 as bean_name,
            roaster_id,
            is_blend,
            roast_level,
            is_decaf,
            decaf_method,
            purchased_at,
            purchased_at::date   as purchased_date,
            comment,
            added_at,
            modified_at

       from source

)

from renamed
