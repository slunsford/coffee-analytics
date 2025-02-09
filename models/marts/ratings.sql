with

unite_sources as (

    {{ dbt_utils.union_relations(
        relations = [ref('coffees_ratings_snapshot'), ref('int_airtable_ratings_joined_to_coffees')],
        include = ['coffee_id', 'flavor_profile_key', 'rated_date', 'rating', 'rating_value', 'modified_at']
    ) }}

),

dedupe_ratings as (

    {{ dedupe (
        relation = 'unite_sources',
        partition_by = 'coffee_id, rated_date',
        order_by = 'modified_at desc'
    ) }}

),

final as (

     select coffee_id,
            flavor_profile_key,
            rated_date,
            rating,
            rating_value,
            rating_value = 1 as is_liked,
            rating_value = -1 as is_disliked,
            row_number() over (partition by coffee_id order by rated_date desc) = 1 as is_current

       from dedupe_ratings

)

from final
