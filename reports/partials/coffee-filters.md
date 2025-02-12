```sql coffee_ratings_history
select coffees.* exclude (rated_date, rating, rating_value, is_liked, is_disliked),
       ratings.* exclude (coffee_id, flavor_profile_key)
  from md.coffees
  join md.ratings
 using (coffee_id)
```

```sql dimensions
select country,
       roaster,
       process,
       rating,
       count(distinct coffee_id) as coffees
  from ${coffee_ratings_history}
 where rated_date between date_add('${inputs.dates.start}'::date, interval 1 day)
                      and date_add('${inputs.dates.end}'::date, interval 1 day)
 group by all
```

<DimensionGrid
    data={dimensions}
    name=selected_dimensions
    metric='sum(coffees)'
    multiple
/>

```sql filtered_ratings
  from ${coffee_ratings_history}
 where ${inputs.selected_dimensions}
   and rated_date between date_add('${inputs.dates.start}'::date, interval 1 day)
                      and date_add('${inputs.dates.end}'::date, interval 1 day)
       -- For some reason the dates are being set one day before the start/end dates in the picker
 order by coffee_name
```

```sql filtered_coffees
  from ${filtered_ratings}
 where is_current
```
