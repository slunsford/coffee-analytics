with

coffees as (
    select * from {{ ref('int_coffees_joined_to_origins') }}
),

ratings as (
    select * from {{ ref('int_weighted_ratings') }}
),

elevations as (
    select coffee_id,
           case when elevation_max > elevation_min then elevation_min || '–' || elevation_max || 'm'
                else elevation_min || 'm'
            end as elevation
      from coffees
),

agg_ratings as (
    select coffee_id,
           avg(rating) as average_rating,
           sum(weighted_rating) / sum(weight) as weighted_avg_rating,
           min(rating_date) as first_rating_date,
           max(rating_date) as most_recent_rating_date,
           count(rating_id) as number_of_ratings
      from ratings
  group by 1
),

latest_ratings as (
    select coffee_id,
           rating as most_recent_rating
      from ratings
     where rating_date in (
           select most_recent_rating_date
             from agg_ratings
     )
),

coffees_with_ratings as (
    select coffees.coffee_id,
           coffees.coffee_name,
           coffees.roaster,
           coffees.country,
           coffees.world_region,
           coffees.country_region,
           coffees.varietal,
           coffees.caffeine_content,
           coffees.roast_darkness,
           coffees.process,
           coffees.elevation_min,
           coffees.elevation_max,
           coalesce(elevations.elevation, 'Unknown')    as elevation,
           coffees.flavor_profile_key,
           coffees.date_added,
           agg_ratings.first_rating_date,
           agg_ratings.most_recent_rating_date,
           latest_ratings.most_recent_rating,
           agg_ratings.average_rating,
           agg_ratings.weighted_avg_rating,
           coalesce(agg_ratings.number_of_ratings, 0) as number_of_ratings
      from coffees
 left join elevations
        on coffees.coffee_id = elevations.coffee_id
 left join agg_ratings
        on coffees.coffee_id = agg_ratings.coffee_id
 left join latest_ratings
        on coffees.coffee_id = latest_ratings.coffee_id
)

select * from coffees_with_ratings
