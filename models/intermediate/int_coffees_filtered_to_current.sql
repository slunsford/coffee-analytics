with

coffees as (
    from {{ ref('coffees_ratings_snapshot') }}
),

filter_current_snapshot as (
    
     select *
       from coffees
      where dbt_valid_to is null
      
)

from filter_current_snapshot
