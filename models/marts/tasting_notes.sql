with

notes as (
    from {{ ref('int_tasting_notes_resolved') }}
),

flavor_counts as (

     select note_id,
            count(*) as flavors

       from {{ ref('stg_bean_counter__tasting_note_flavors') }}
   group by note_id

),

final as (

     select note_id,
            bean_id,
            cup_id,
            case note_source when 'roaster' then 'Roaster'
                             when 'me' then 'Me'
             end as note_source,
            note_position,
            verbatim,
            normalized,
            facets,
            is_confirmed,
            resolution_confidence,
            coalesce(flavors, 0) as flavors,
            coalesce(flavors, 0) > 0 as is_mapped

       from notes
  left join flavor_counts
      using (note_id)

)

from final
