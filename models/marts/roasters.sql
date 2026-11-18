with

roasters as (
    from {{ ref('stg_bean_counter__roasters') }}
),

beans as (
    from {{ ref('beans') }}
),

bean_totals as (

     select roaster_id,
            count(*) as beans,
            sum(cups) as cups,
            sum(liked_cups) as liked_cups,
            sum(disliked_cups) as disliked_cups,
            sum(net_score) as net_score

       from beans
   group by roaster_id

),

final as (

     select roaster_id,
            roaster_name,
            website,
            location,
            notes,
            coalesce(beans, 0) as beans,
            coalesce(cups, 0) as cups,
            coalesce(liked_cups, 0) as liked_cups,
            coalesce(disliked_cups, 0) as disliked_cups,
            coalesce(net_score, 0) as net_score

       from roasters
  left join bean_totals
      using (roaster_id)

)

from final
