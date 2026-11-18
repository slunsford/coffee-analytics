with

source as (
    from {{ source('bean_counter', 'flavor_nodes') }}
),

renamed as (

     select slug        as flavor_slug,
            name        as flavor_name,
            parent_slug as parent_flavor_slug,
            root_slug   as root_flavor_slug,
            depth       as flavor_depth,
            path        as flavor_path,
            node_origin,
            aliases,
            created_at  as added_at

       from source

)

from renamed
