with

beans as (
    from {{ ref('stg_bean_counter__beans') }}
),

origins as (
    from {{ ref('stg_bean_counter__origins') }}
),

aggregated as (

     select bean_id,
            count(*) as origin_count,
            list_sort(list_distinct(list(country) filter (where country is not null))) as countries,
            list_sort(list_distinct(list({{ humanize('process') }}) filter (where process is not null))) as processes,
            min(coalesce(elevation_min_m, elevation_max_m)) as elevation_min_m,
            max(coalesce(elevation_max_m, elevation_min_m)) as elevation_max_m

       from origins
   group by bean_id

),

final as (

     select bean_id,
            coalesce(origin_count, 0) as origin_count,
            coalesce(countries, []) as countries,
            case when is_blend then '[Blend]'
                 when len(countries) = 1 then countries[1]
                 when len(countries) > 1 then '[Multiple]'
                 else '[Unknown]'
             end as country,
            coalesce(array_to_string(countries, ', '), '[Unknown]') as countries_list,
            case when len(processes) = 1 then processes[1]
                 when len(processes) > 1 then '[Multiple]'
                 else '[Unknown]'
             end as process,
            elevation_min_m,
            elevation_max_m,
            case when elevation_max_m > elevation_min_m then elevation_min_m || '–' || elevation_max_m || 'm'
                 when elevation_min_m is not null then elevation_min_m || 'm'
             end as elevation

       from beans
  left join aggregated
      using (bean_id)

)

from final
