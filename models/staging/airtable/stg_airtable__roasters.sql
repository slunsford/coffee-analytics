with

source as (
    select * from {{ source('airtable', 'roasters') }}
),

renamed as (

     select id as roaster_id,
            name as roaster_name,
            website,
            -- logo,
            -- coffees,
            _fivetran_synced

       from source

)

select * from renamed
