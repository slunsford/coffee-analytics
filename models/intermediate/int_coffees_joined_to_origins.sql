with

coffees as (
	select * from {{ ref('stg_airtable_coffee__coffees') }}
),

origins as (
	select * from {{ ref('stg_airtable_coffee__origins') }}
),

coffees_and_origins_joined as (
	select coffees.*,
		   coalesce(origins.country_name, 'Blend') as country,
		   coalesce(origins.world_region, 'Blend') as world_region
	  from coffees
 left join origins
		on coffees.origin_id = origins.origin_id
)

select * from coffees_and_origins_joined
