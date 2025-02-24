---
title: Flavor Profiles
queries:
---

```sql flavor_categories_list
select distinct flavor_category as flavor_category
  from md.flavor_categories
 order by 1
```

{@partial "date-picker.md"}

<Dropdown
    data={flavor_categories_list}
    name=flavor_categories
    value=flavor_category
    multiple=true
    selectAllByDefault=true
/>

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

# Flavor Categories

### Ratings by Flavor Category

```sql ratings_by_flavor_category
select flavor_category,
       rating,
       rating_value,
       count(*) as ratings,
  from ${flavor_ratings}
  join md.flavor_categories
 using (flavor_category_group_key)
 where flavor_category != 'Uncategorized'
 group by all
 order by rating_value desc
```

<BarChart
    data={ratings_by_flavor_category}
    x=flavor_category
    y=ratings
    series=rating
    swapXY=true
    sort=false
    colorPalette=goodNeutralBad
/>

### Net Score by Flavor Category

```sql net_score_by_flavor_category
select flavor_category,
       sum(rating_value) as net_liked,
       count(*) as coffees_rated,
       net_liked/coffees_rated * 100 as net_score,
  from ${flavor_ratings}
  join md.flavor_categories
 using (flavor_category_group_key)
 where flavor_category != 'Uncategorized'
 group by all
 order by all
```

<BubbleChart
    data={net_score_by_flavor_category}
    x=flavor_category
    y=net_score
    size=coffees_rated
    sort=false
    yFmt=num0
/>

# Flavors

### Ratings by Flavor

```sql ratings_by_flavor
select flavor,
       rating,
       rating_value,
       count(*) as ratings,
  from ${flavor_ratings}
 group by all
 order by rating_value desc
```

<BarChart
    data={ratings_by_flavor}
    x=flavor
    y=ratings
    series=rating
    swapXY=true
    sort=false
    colorPalette=goodNeutralBad
/>

<LastRefreshed/>
