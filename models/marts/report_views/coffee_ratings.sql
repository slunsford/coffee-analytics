{{ config(
    enabled = false
) }}

 select coffee_name     as "Coffee",
        roaster         as "Roaster",
        country         as "Country",
        world_region    as "World Region",
        availability    as "Availability",
        brew_method     as "Brew Method",
        rating          as "Rating",
        
   from {{ ref('coffees') }}
   join {{ ref('ratings') }}
  using (coffee_id)
