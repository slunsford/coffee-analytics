with

ratings as (
	select * from {{ ref('stg_airtable_coffee__ratings') }}
),

rating_ages as (
	select *,
		   date_diff('day', rated_at, current_date) as rating_age
	  from ratings
),

ratings_with_weights as (
	select *,
		   (2 ** (-rating_age / 365)) as weight
	  from rating_ages
),

weighted_ratings as (
	select *,
		   weight * rating as weighted_rating
	  from ratings_with_weights
)

select * from weighted_ratings
