---
title: Coffees, Roasters, and Origins
queries:
  - coffees_list.sql
  - roasters_list.sql
  - countries_list.sql
  - rating_dates.sql
---

{@partial "define-colors.md"}

<Dropdown
    data={roasters_list}
    name=roasters
    value=roaster
    multiple=true
    selectAllByDefault=true
/>

<Dropdown
    data={countries_list}
    name=countries
    value=country
    multiple=true
    selectAllByDefault=true
/>

<Dropdown
    data={coffees_list}
    name=coffees
    value=coffee_name
    multiple=true
    selectAllByDefault=true
/>

{@partial "date-picker.md"}

```sql coffee_ratings
  from md.coffees
 where coffee_name in ${inputs.coffees.value}
   and roaster in ${inputs.roasters.value}
   and country in ${inputs.countries.value}
   and rated_date between date_add('${inputs.dates.start}'::date, interval 1 day)
                      and date_add('${inputs.dates.end}'::date, interval 1 day)
       -- For some reason the dates are being set one day before the start/end dates in the picker
 order by coffee_name
```
    
```sql coffee_counts
select count(distinct coffee_id) as coffees,
       count(distinct roaster_id) as roasters,
       count(distinct country) as countries,
  from ${coffee_ratings}
 group by all
```

<BigValue 
  data={coffee_counts} 
  value=roasters
  link='#roasters--processes'
/>

<BigValue 
  data={coffee_counts} 
  value=countries
  link='#origins'
/>

<BigValue 
  data={coffee_counts} 
  value=coffees
  link='#coffees'
/>


# Roasters & Processes

```sql ratings_by_roaster
select roaster,
       rating,
       count(*) as ratings,
  from ${coffee_ratings}
 group by all
```
    
<BarChart
    data={ratings_by_roaster}
    title="Ratings by Roaster"
    x=roaster
    y=ratings
    series=rating
    swapXY=true
    colorPalette={chartColors}
/>

```sql ratings_by_process
select process,
       rating,
       count(*) as ratings,
  from ${coffee_ratings}
 group by all
```

<BarChart
    data={ratings_by_process}
    title="Ratings by Process"
    x=process
    y=ratings
    series=rating
    swapXY=true
    colorPalette={chartColors}
/>

# Origins

```sql ratings_by_country
select country,
       count_if(is_liked) as liked,
       count_if(not is_liked) as disliked,
       liked - disliked as net_liked,
       count(*) as coffees_rated,
       liked/coffees_rated as liked_pct,
  from ${coffee_ratings}
 group by all
 order by net_liked desc, liked desc
```

<AreaMap 
    data={ratings_by_country} 
    title="% Liked by Country"
    areaCol=country
    geoJsonUrl=https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_50m_admin_0_countries.geojson
    geoId=name
    value=liked_pct
    valueFmt=pct0
    colorPalette={colorGradient}
    tooltip={[
        {id: 'country', fmt: 'id', showColumnName: false, valueClass: 'text-xl font-semibold'},
        {id: 'liked_pct', title: '% Liked', fmt: 'pct0', fieldClass: 'text-[grey]', valueClass: 'text-[#236aa4] font-bold'},
        {id: 'liked', fieldClass: 'text-[grey]', valueClass: 'text-[#236aa4]'},
        {id: 'disliked', fieldClass: 'text-[grey]', valueClass: 'text-[#a45c23]'},
        {id: 'coffees_rated', fieldClass: 'text-[grey]'},
    ]}
/>

<BarChart
    data={ratings_by_country}
    title="Ratings by Country"
    x=country
    y={['liked','disliked']}
    swapXY=true
    colorPalette={chartColors}
    sort=false
/>

# Coffees

<DataTable
    data={coffee_ratings}
    rows=50
    sortable
    subtotals
    totalRow
    rowShading>
    
    <Column id='coffee_name' totalAgg=countDistinct totalFmt='0 "coffees"'/>
    <Column id='roaster' totalAgg=countDistinct totalFmt='0 "roasters"'/>
    <Column id='country' colGroup='Origin' totalAgg=countDistinct totalFmt='0 "countries"'/>
    <Column id='world_region' colGroup='Origin'/>
    <!-- <Column id='country_region' colGroup='Origin'/> -->
    <Column id='favorite_emoji' title='Favorite' align='center' colGroup='Rating'/>
    <Column id='rating' colGroup='Rating'/>
    <Column id='rated_date' title='Date' colGroup='Rating'/>
    <Column id='caffeine_content' title='Caffeine'/>
    <Column id='process'/>
    <Column id='availability'/>
    
</DataTable>
