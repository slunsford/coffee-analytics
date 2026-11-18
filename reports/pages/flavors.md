---
title: Flavor Profiles
queries:
---

```sql flavor_categories_list
select distinct flavor_category
  from md.flavor_nodes
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
-- One row per rated cup and flavor named on the roaster's bag or in the cup
select cups.cup_id,
       cups.verdict,
       cups.verdict_value,
       bean_flavors.flavor_name as flavor,
       bean_flavors.flavor_category,
  from md.cups
  join md.bean_flavors
 using (bean_id)
 where cups.is_rated
   and bean_flavors.flavor_category in ${inputs.flavor_categories.value}
   and cups.brewed_date between date_add('${inputs.dates.start}'::date, interval 1 day)
                            and date_add('${inputs.dates.end}'::date, interval 1 day)
 order by flavor
```

# Flavor Categories

### Verdicts by Flavor Category

```sql verdicts_by_flavor_category
select flavor_category,
       verdict,
       verdict_value,
       count(*) as cups,
  from ${flavor_ratings}
 group by all
 order by verdict_value desc
```

<BarChart
    data={verdicts_by_flavor_category}
    x=flavor_category
    y=cups
    series=verdict
    swapXY=true
    sort=false
    colorPalette=goodNeutralBad
/>

### Net Score by Flavor Category

```sql net_score_by_flavor_category
select flavor_category,
       sum(verdict_value) as net_liked,
       count(*) as cups_rated,
       net_liked/cups_rated * 100 as net_score,
  from ${flavor_ratings}
 group by all
 order by all
```

<BubbleChart
    data={net_score_by_flavor_category}
    x=flavor_category
    y=net_score
    size=cups_rated
    sort=false
    yFmt=num0
/>

# Flavors

### Verdicts by Flavor

```sql verdicts_by_flavor
select flavor,
       verdict,
       verdict_value,
       count(*) as cups,
  from ${flavor_ratings}
 group by all
 order by verdict_value desc
```

<BarChart
    data={verdicts_by_flavor}
    x=flavor
    y=cups
    series=verdict
    swapXY=true
    sort=false
    colorPalette=goodNeutralBad
/>

<LastRefreshed/>
