with

beans as (
    from {{ ref('stg_bean_counter__beans') }}
),

roasters as (
    from {{ ref('stg_bean_counter__roasters') }}
),

origins as (
    from {{ ref('int_beans_origins_summarized') }}
),

cups as (
    from {{ ref('stg_bean_counter__cups') }}
),

notes as (
    from {{ ref('stg_bean_counter__tasting_notes') }}
    where note_source = 'roaster'
),

cup_totals as (

     select bean_id,
            count(*) as cups,
            count(verdict) as rated_cups,
            count_if(verdict_value = 1) as liked_cups,
            count_if(verdict_value = -1) as disliked_cups,
            coalesce(sum(verdict_value), 0) as net_score,
            min(brewed_date) as first_brewed_date,
            max(brewed_date) as last_brewed_date,
            arg_max(verdict, brewed_at) filter (where verdict is not null) as latest_verdict

       from cups
   group by bean_id

),

note_totals as (

     select bean_id,
            string_agg(verbatim, ', ' order by note_position) as roaster_notes

       from notes
   group by bean_id

),

final as (

     select bean_id,
            legacy_coffee_id,
            bean_name,
            roaster_id,
            coalesce(roaster_name, '[Unknown]') as roaster_name,
            is_blend,
            origins.origin_count,
            origins.country,
            origins.countries_list as countries,
            origins.process,
            origins.elevation,
            {{ humanize('roast_level') }} as roast_level,
            is_decaf,
            case when is_decaf then 'Decaf' else 'Regular' end as caffeine_content,
            {{ humanize('decaf_method') }} as decaf_method,
            purchased_date,
            note_totals.roaster_notes,
            coalesce(cup_totals.cups, 0) as cups,
            coalesce(cup_totals.rated_cups, 0) as rated_cups,
            coalesce(cup_totals.liked_cups, 0) as liked_cups,
            coalesce(cup_totals.disliked_cups, 0) as disliked_cups,
            coalesce(cup_totals.net_score, 0) as net_score,
            cup_totals.first_brewed_date,
            cup_totals.last_brewed_date,
            {{ humanize('cup_totals.latest_verdict') }} as latest_verdict,
            beans.comment

       from beans
  left join roasters
      using (roaster_id)
  left join origins
      using (bean_id)
  left join cup_totals
      using (bean_id)
  left join note_totals
      using (bean_id)

)

from final
