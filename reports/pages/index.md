---
title: Coffees, Roasters, and Origins
queries:
  - roasters_list.sql
  - countries_list.sql
  - rating_dates.sql
---

{@partial "define-colors.md"}

<Dropdown data={roasters_list} name=roaster value=roaster>
    <DropdownOption value="%" valueLabel="[All Roasters]"/>
</Dropdown>

<Dropdown data={countries_list} name=country value=country>
    <DropdownOption value="%" valueLabel="[All Countries]"/>
</Dropdown>

{@partial "date-picker.md"}

```sql coffee_ratings
  from md.coffees
  join md.ratings
 using (coffee_id)
 where is_current
   and roaster like '${inputs.roaster.value}'
   and country like '${inputs.country.value}'
   and rated_date between '${inputs.dates.start}' and date_add('${inputs.dates.end}'::date, interval 1 day)
       -- For some reason the end date is being set one day before the end of the range in the picker
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
       sum(rating_value) as ratings,
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
       sum(rating_value) as ratings,
  from ${coffee_ratings}
 where process != 'Unknown'
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
with pivoted as (
 pivot ${coffee_ratings}
    on lower(rating)
 using count(*),
 group by country
)

select * replace (-disliked as disliked),
       liked - disliked as net_liked,
       liked + disliked as coffees_rated,
       liked/coffees_rated as liked_pct,
  from pivoted
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
    legendType=scalar
    legendFmt=pct0
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
    groupBy='roaster'
    rowShading>
    
    <Column id='coffee_name'/>
    <Column id='country' colGroup='Origin'/>
    <Column id='world_region' colGroup='Origin'/>
    <!-- <Column id='country_region' colGroup='Origin'/> -->
    <Column id='favorite_emoji' title='Favorite' align='center' colGroup='Rating'/>
    <Column id='rating' colGroup='Rating'/>
    <Column id='rated_date' title='Date' colGroup='Rating'/>
    <Column id='caffeine_content' title='Caffeine'/>
    <Column id='process'/>
    <Column id='availability'/>
    
</DataTable>
