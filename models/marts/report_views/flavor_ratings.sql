 select flavor_id,
        rating_id,
        coffee_id,
        flavor,
        primary_flavor_category,
        flavor_categories,
        brew_method,
        rating,
        is_liked,
        rating_value,
        rated_date,
        is_current
        
   from {{ ref('flavors') }}
   join {{ ref('flavor_profiles') }}
  using (flavor_id)
   join {{ ref('ratings') }}
  using (flavor_profile_key)
