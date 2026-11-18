with

notes as (
    from {{ ref('int_tasting_notes_resolved') }}
),

note_flavors as (
    from {{ ref('stg_bean_counter__tasting_note_flavors') }}
),

flavor_nodes as (
    from {{ ref('flavor_nodes') }}
),

-- A coffee can name the same flavor more than once (e.g. Cherry and Cherry Liqueur), so collapse to one row per bean and flavor
final as (

     select bean_id,
            flavor_slug,
            flavor_name,
            flavor_category,
            flavor_subcategory,
            flavor_path,
            count(distinct note_id) as notes,
            list_sort(list_distinct(list(note_source))) as note_sources

       from notes
       join note_flavors
      using (note_id)
       join flavor_nodes
      using (flavor_slug)
   group by all

)

from final
