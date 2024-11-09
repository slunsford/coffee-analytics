{{ config (
    enabled = false
) }}

with

source as (
    from {{ source('airtable', 'origins') }}
),

renamed as (
  
     select id as origin_id,
            name as country_name,
            -- flag,
            region as world_region,
            -- coffees,
            -- rating,
            _fivetran_synced
            
       from source
       
)

from renamed
