 select coffee_id,
        coffee_name,
        roaster_id,
        roaster,
        origin_id,
        country,
        world_region,
        country_region,
        availability,
        caffeine_content,
        roast_darkness,
        varietals,
        process,
        elevation_min,
        elevation_max,
        elevation,
        coffees.flavor_profile_key,
        rating,
        is_liked,
        rating_value,
        rated_date,
        added_at,
        is_current
        
   from {{ ref('coffees') }}
   join {{ ref('ratings') }}
  using (coffee_id)
