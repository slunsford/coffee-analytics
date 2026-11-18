with

cup_log as (
    from {{ ref('stg_bean_counter__cups') }}
),

beans as (
    from {{ ref('beans') }}
),

final as (

     select cup_id,
            bean_id,
            bean_name,
            roaster_id,
            roaster_name,
            country,
            process,
            is_decaf,
            caffeine_content,
            brewed_date,
            brew_method,
            coalesce({{ humanize('verdict') }}, 'Unrated') as verdict,
            verdict_value,
            verdict is not null as is_rated,
            verdict_value = 1 as is_liked,
            verdict_value = -1 as is_disliked,
            dose_g,
            yield_g,
            round(yield_g / nullif(dose_g, 0), 2) as brew_ratio,
            water_temp_c,
            brew_time_s,
            grinder,
            grind_setting,
            acidity_score,
            body_score,
            sweetness_score,
            bitterness_score,
            cup_log.comment

       from cup_log
       join beans
      using (bean_id)

)

from final
