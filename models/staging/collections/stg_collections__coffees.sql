{{ config(
    materialized = 'ephemeral'
) }}

with

source as (
    from {{ source('collections', 'coffees') }}
),

parse_timestamps as (

     select * replace (
        {%- set comma = joiner(",") %}
        {%- for ts in ('created', 'creation_date', 'modified_date') %}{{ comma() }}
            strptime(
                replace({{ ts }}, ' ', ' '), -- Replace weird whitespace character
                '%m/%-d/%Y %-I:%M %p'
            ) as {{ ts }}
        {%- endfor %}
            )

       from source
),

renamed as (

     select coffee_id,
            name as coffee_name,
            origin_id,
            region as country_region,
            roaster_id,
            roaster,
            available = 'Yes' as is_available,
            rating,
            case rating when 'Great' then 1
                        when 'Fine' then 0
                        when 'Bad' then -1
                        end as rating_value,
            case when rating is not null then coalesce(rated_date, modified_date::date) end as rated_date,
            decaf = 'Yes' as is_decaf,
            roast as roast_darkness,
            string_split(varietals, ', ') as varietals,
            process,
            coalesce(elevation_min, elevation_max) as elevation_min,
            coalesce(elevation_max, elevation_min) as elevation_max,
            case when flavors is not null then {{ dbt_utils.generate_surrogate_key(['flavors']) }} end as flavor_profile_key,
            string_split(flavors, '; ') as flavors,
            coalesce(created, creation_date) as added_at,
            modified_date as modified_at

       from parse_timestamps
      where rating is not null

)

from renamed
