---
title: Flavor Ratings
queries:
  - flavor_categories_list.sql
---

<Dropdown name=year>
    <DropdownOption value=% valueLabel="[All Years]"/>
    <DropdownOption value=2021/>
    <DropdownOption value=2022/>
    <DropdownOption value=2023/>
    <DropdownOption value=2024/>
</Dropdown>

<Dropdown data={flavor_categories_list} name=flavor_category value=flavor_category>
    <DropdownOption value="%" valueLabel="[All Categories]"/>
</Dropdown>

```sql flavors_list
select distinct flavor
  from md.flavors
 where flavor_categories like '%${inputs.flavor_category.value}%'
 order by 1
```

<Dropdown data={flavors_list} name=flavor value=flavor>
    <DropdownOption value="%" valueLabel="[All Flavors]"/>
</Dropdown>

```sql flavor_ratings
select *
  from md.flavors
  join md.flavor_profiles
 using (flavor_id)
  join md.ratings
 using (flavor_profile_key)
 where is_current
   and flavor like '${inputs.flavor.value}'
   and flavor_categories like '%${inputs.flavor_category.value}%'
   and date_part('year', rated_date) like '${inputs.year.value}'
 order by flavor
```

```sql ratings_by_flavor_category
select flavor_category,
       rating,
       sum(rating_value) as ratings,
  from ${flavor_ratings}
  join md.flavor_categories
 using (flavor_category_group_key)
 where flavor_category != 'Uncategorized'
 group by all
```

```sql ratings_by_flavor
select flavor,
       rating,
       sum(rating_value) as ratings,
  from ${flavor_ratings}
 group by all
```

<BarChart
    data={ratings_by_flavor_category}
    title="Ratings by Flavor Category"
    x=flavor_category
    y=ratings
    series=rating
    swapXY=true
/>

<BarChart
    data={ratings_by_flavor}
    title="Ratings by Flavor"
    x=flavor
    y=ratings
    series=rating
    swapXY=true
/>

