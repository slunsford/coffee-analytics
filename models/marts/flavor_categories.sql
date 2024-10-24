with

categories as (
    select * from {{ ref('int_flavor_categories_unnested') }}
)

from categories
