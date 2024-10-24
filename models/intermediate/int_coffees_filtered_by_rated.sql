with

coffees as (
    from {{ ref('stg_airtable__coffees') }}
),

ratings as (
    from {{ ref('stg_airtable__ratings') }}
),

filtered as (
  
    from coffees
   where coffee_id in (select distinct coffee_id from ratings)

)

from filtered
