with

flavors as (
	  select * from {{ ref('stg_airtable__flavors') }}
),

ratings as (
	  select * from {{ ref('int_ratings_by_flavor') }}
),

flavor_ratings as (
  
	    select flavor_id,
		         avg(rating) as average_rating,
		         sum(weighted_rating) / sum(weight) as weighted_avg_rating,
		         min(rated_date) as first_rated_date,
		         max(rated_date) as last_rated_date,
		         count(rating_id) as number_of_ratings
           
	      from ratings
       group by 1
  
),

flavors_with_ratings as (
  
	    select flavors.flavor_id,
		         flavors.flavor,
		         flavors.flavor_category,
		         flavor_ratings.average_rating,
		         flavor_ratings.first_rated_date,
		         flavor_ratings.last_rated_date,
		         flavor_ratings.weighted_avg_rating,
		         coalesce(flavor_ratings.number_of_ratings, 0) as number_of_ratings
             
	      from flavors
     left join flavor_ratings
	     using (flavor_id)
       
)

select * from flavors_with_ratings
