with

categories as (
    from {{ ref('int_flavor_categories_unnested') }}
)

from categories
