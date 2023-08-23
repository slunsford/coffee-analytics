with

flavors as (
	select * from {{ ref('stg_airtable_coffee__flavors') }}
),

ratings as (
	select * from {{ ref('int_ratings_by_flavor') }}
),

flavor_ratings as (
	select flavor_id,
		   avg(rating) as average_rating,
		   sum(weighted_rating) / sum(weight) as weighted_avg_rating,
		   min(rating_date) as first_rating_date,
		   max(rating_date) as most_recent_rating_date,
		   count(rating_id) as number_of_ratings
	  from ratings
  group by 1
),

flavors_with_ratings as (
	select flavors.flavor_id,
		   flavors.flavor,
		   flavors.flavor_category,
		   flavor_ratings.average_rating,
		   flavor_ratings.first_rating_date,
		   flavor_ratings.most_recent_rating_date,
		   flavor_ratings.weighted_avg_rating,
		   coalesce(flavor_ratings.number_of_ratings, 0) as number_of_ratings
	  from flavors
 left join flavor_ratings
	 using (flavor_id)
)

select * from flavors_with_ratings
