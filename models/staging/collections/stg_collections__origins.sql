with

source as (
    from {{ source('collections', 'origins') }}
),

renamed as (
  
     select short_id as origin_id,
            country,
            -- flag,
            region as world_region,
            modified_date as modified_at
            
       from source
       
)

from renamed