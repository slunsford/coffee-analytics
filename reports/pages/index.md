---
title: Coffees, Roasters, and Origins
queries:
  - roasters_list.sql
  - countries_list.sql
---

<Dropdown name=year>
    <DropdownOption value=% valueLabel="[All Years]"/>
    <DropdownOption value=2021/>
    <DropdownOption value=2022/>
    <DropdownOption value=2023/>
    <DropdownOption value=2024/>
</Dropdown>

<Dropdown data={countries_list} name=country value=country>
    <DropdownOption value="%" valueLabel="[All Countries]"/>
</Dropdown>

<Dropdown data={roasters_list} name=roaster value=roaster>
    <DropdownOption value="%" valueLabel="[All Roasters]"/>
</Dropdown>

```sql coffee_ratings
select *
  from md.coffees
  join md.ratings
 using (coffee_id)
 where is_current
   and roaster like '${inputs.roaster.value}'
   and country like '${inputs.country.value}'
   and date_part('year', rated_date) like '${inputs.year.value}'
 order by coffee_name
```
    
```sql ratings_by_roaster
select roaster,
       rating,
       sum(rating_value) as ratings,
  from ${coffee_ratings}
 group by all
```
    
```sql ratings_by_process
select process,
       rating,
       sum(rating_value) as ratings,
  from ${coffee_ratings}
 where process != 'Unknown'
 group by all
```
    
```sql net_score_by_country
select country,
       count(*) as ratings,
       sum(rating_value) as net_rating,
       net_rating/ratings*100 as net_score,
  from ${coffee_ratings}
 group by all
```
    
```sql ratings_by_country
select country,
       rating,
       sum(rating_value) as ratings,
  from ${coffee_ratings}
 group by all
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
  value=coffees
  link='#coffees'
/>

<BigValue 
  data={coffee_counts} 
  value=countries
  link='#origins'
/>

<BigValue 
  data={coffee_counts} 
  value=roasters
  link='#roasters--processes'
/>


# Roasters & Processes

<BarChart
    data={ratings_by_roaster}
    title="Ratings by Roaster"
    x=roaster
    y=ratings
    series=rating
    swapXY=true
/>

<BarChart
    data={ratings_by_process}
    title="Ratings by Process"
    x=process
    y=ratings
    series=rating
    swapXY=true
/>

# Origins

<AreaMap 
    data={net_score_by_country} 
    title="Net Score by Country"
    areaCol=country
    geoJsonUrl=https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_50m_admin_0_countries.geojson
    geoId=name
    value=net_score
/>

<BarChart
    data={ratings_by_country}
    title="Ratings by Country"
    x=country
    y=ratings
    series=rating
    swapXY=true
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
