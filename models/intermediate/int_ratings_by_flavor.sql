with

bridge as (
	select * from {{ ref('flavor_profiles') }}
),

coffees as (
	select * from {{ ref('stg_airtable_coffee__coffees') }}
),

ratings as (
	select * from {{ ref('int_weighted_ratings') }}
),

flavor_ratings as (
	select ratings.rating_id,
		   bridge.flavor_id,
		   ratings.rating,
		   ratings.rated_date,
		   ratings.rating_age,
		   ratings.weight,
		   ratings.weighted_rating
	  from bridge
	  join coffees
	 using (flavor_profile_key)
	  join ratings
	 using (coffee_id)
)

select * from flavor_ratings
