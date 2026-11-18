with

origins as (
    from {{ ref('stg_bean_counter__origins') }}
),

beans as (
    from {{ ref('stg_bean_counter__beans') }}
),

final as (

     select origin_id,
            bean_id,
            bean_name,
            origin_position,
            country,
            region,
            farm,
            producer,
            elevation_min_m,
            elevation_max_m,
            varietals,
            {{ humanize('process') }} as process,
            list_transform(fermentation_modifiers, m -> {{ humanize('m') }}) as fermentation_modifiers,
            process_note,
            proportion

       from origins
       join beans
      using (bean_id)

)

from final
