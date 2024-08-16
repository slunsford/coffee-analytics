 select flavor          as "Flavor",
        flavor_category as "Flavor Category",
        coffee_name     as "Coffee",
        roaster         as "Roaster",
        country         as "Country",
        world_region    as "World Region",
        availability    as "Availability",
        brew_method     as "Brew Method",
        rating          as "Rating",
        rated_date      as "Rated Date",
        weight          as "Weight",
        weighted_rating as "Weighted Rating"
        
   from {{ ref('flavors') }}
   join {{ ref('flavor_profiles') }}
  using (flavor_id)
   join {{ ref('coffees') }}
  using (flavor_profile_key)
   join {{ ref('ratings') }}
  using (coffee_id)
