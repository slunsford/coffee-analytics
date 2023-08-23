with

bridge as (
	select * from {{ ref('flavor_profiles') }}
),

coffees as (
	select * from {{ ref('int_coffees_with_flavor_profile_key') }}
),

ratings as (
	select * from {{ ref('int_weighted_ratings') }}
),

flavor_ratings as (
	select ratings.rating_id,
		   bridge.flavor_id,
		   ratings.rating,
		   ratings.rating_date,
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