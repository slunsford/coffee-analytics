with

flavor_profiles as (
	select * from {{ ref('coffee_flavor_profiles_bridge') }}
),

coffees as (
	select * from {{ ref('int_coffees_with_flavor_profile_key') }}
),

ratings as (
	select * from {{ ref('int_weighted_ratings') }}
),

flavor_ratings as (
	select ratings.rating_id,
		   flavor_profiles.flavor_id,
		   ratings.rating,
		   ratings.rating_date,
		   ratings.rating_age,
		   ratings.weight,
		   ratings.weighted_rating
	  from flavor_profiles
	  join coffees
	 using (flavor_profile_key)
	  join ratings
	 using (coffee_id)
)

select * from flavor_ratings
