with

notes as (
    from {{ ref('stg_bean_counter__tasting_notes') }}
),

cups as (
    from {{ ref('stg_bean_counter__cups') }}
),

-- Roaster notes carry bean_id; notes tasted in a cup carry only cup_id, so look up the bean through the cup
final as (

     select notes.* replace (coalesce(notes.bean_id, cups.bean_id) as bean_id)

       from notes
  left join cups
      using (cup_id)

)

from final
