with

coffees as (
	select * from {{ ref('stg_airtable_coffee__coffees') }}
),

coffees_with_flavor_profile_key as (
	select *,
		   md5(array_to_string(flavor_ids, '_')) as flavor_profile_key
	  from coffees
)

select * from coffees_with_flavor_profile_key
