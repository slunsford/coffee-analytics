---
title: Flavor Profiles
queries:
  - flavor_categories_list.sql
  - rating_dates.sql
---

{@partial "define-colors.md"}

<Dropdown
    data={flavor_categories_list}
    name=flavor_categories
    value=flavor_category
    multiple=true
    selectAllByDefault=true
/>

{@partial "date-picker.md"}

```sql flavor_ratings
with filter_flavor_categories as (
     select distinct flavor_category_group_key
       from md.flavor_categories
      where flavor_category in ${inputs.flavor_categories.value}    
)

  from md.flavors
  join md.flavor_profiles
 using (flavor_id)
  join md.coffees
 using (flavor_profile_key)
 where flavor_category_group_key in (from filter_flavor_categories)
   and rated_date between date_add('${inputs.dates.start}'::date, interval 1 day)
                      and date_add('${inputs.dates.end}'::date, interval 1 day)
 order by flavor
```

```sql ratings_by_flavor_category
select flavor_category,
       rating,
       count(*) as ratings,
  from ${flavor_ratings}
  join md.flavor_categories
 using (flavor_category_group_key)
 where flavor_category != 'Uncategorized'
 group by all
```
# Flavor Categories

<BarChart
    data={ratings_by_flavor_category}
    title="Ratings by Flavor Category"
    x=flavor_category
    y=ratings
    series=rating
    swapXY=true
    colorPalette={chartColors}
/>

```sql ratings_by_flavor
select flavor,
       rating,
       count(*) as ratings,
  from ${flavor_ratings}
 group by all
```
# Flavors

<BarChart
    data={ratings_by_flavor}
    title="Ratings by Flavor"
    x=flavor
    y=ratings
    series=rating
    swapXY=true
    colorPalette={chartColors}
/>

