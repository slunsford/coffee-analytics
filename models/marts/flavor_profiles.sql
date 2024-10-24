with

flavor_profiles as (
    from {{ ref('int_flavor_profiles_unnested') }}
)

from flavor_profiles
