with

nodes as (
    from {{ ref('stg_bean_counter__flavor_nodes') }}
),

roots as (
    from nodes
),

final as (

     select nodes.flavor_slug,
            nodes.flavor_name,
            nodes.parent_flavor_slug,
            nodes.root_flavor_slug,
            roots.flavor_name as flavor_category,
            -- Path is the current location; slugs can look stale after a re-parent
            nodes.flavor_path,
            string_split(nodes.flavor_path, ' → ')[2] as flavor_subcategory,
            nodes.flavor_depth,
            nodes.node_origin,
            nodes.aliases

       from nodes
       join roots
         on nodes.root_flavor_slug = roots.flavor_slug

)

from final
