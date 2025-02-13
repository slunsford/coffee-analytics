---
title: Roasters & Origins
---

{@partial "define-colors.md"}
{@partial "date-picker.md"}
{@partial "coffee-filters.md"}

```sql coffee_counts
select count(distinct coffee_id) as coffees,
       count(distinct roaster_id) as roasters,
       count(distinct country) as countries,
  from ${filtered_coffees}
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


# Roasters

### Ratings by Roaster

```sql ratings_by_roaster
select roaster,
       rating,
       rating_value,
       count(*) as ratings,
  from ${filtered_coffees}
 group by all
 order by rating_value desc
```

<BarChart
    data={ratings_by_roaster}
    connectGroup="roasters"
    x=roaster
    y=ratings
    series=rating
    swapXY=true
    colorPalette={chartColors}
    sort=false
/>

### Net Score by Roaster

```sql historical_ratings_by_roaster
select roaster,
       date_trunc('year', rated_date) as date_year,
       year(rated_date)::string as year,
       count_if(is_liked) as liked,
       count_if(is_disliked) as disliked,
       sum(rating_value) as net_liked,
       count(*) as coffees_rated,
       liked/coffees_rated * 100 as net_score,
  from ${filtered_ratings}
 group by all
 order by year, roaster
```

```sql roasters_list
select distinct roaster
  from ${historical_ratings_by_roaster}
 order by all
```

<LineChart
    data={historical_ratings_by_roaster}
    connectGroup="roasters"
    x=year
    y=net_score
    yMax=100
    series=roaster
    seriesOrder={roasters_list}
    sort=false
    markers=true
/>

<!-- <BubbleChart
    data={historical_ratings_by_roaster}
    connectGroup="roasters"
    x=year
    y=liked_pct
    yMax=1
    yFmt=pct0
    yAxisTitle='% Liked'
    size=ratings
    series=roaster
    sort=false
/> -->

# Processes

### Ratings by Process

```sql ratings_by_process
select process,
       rating,
       rating_value,
       count(*) as ratings,
  from ${filtered_coffees}
 where process not like '%Unknown%'
 group by all
 order by rating_value desc
```

```sql processes_list
select distinct process
  from ${historical_ratings_by_process}
 order by all
```

<BarChart
    data={ratings_by_process}
    connectGroup="processes"
    x=process
    y=ratings
    series=rating
    swapXY=true
    colorPalette={chartColors}
    sort=false
/>

### Net Score by Process

```sql historical_ratings_by_process
select process,
       date_trunc('year', rated_date) as date_year,
       year(rated_date)::string as year,
       count_if(is_liked) as liked,
       count_if(is_disliked) as disliked,
       sum(rating_value) as net_liked,
       count(*) as coffees_rated,
       liked/coffees_rated * 100 as net_score,
  from ${filtered_ratings}
 where process not like '%Unknown%'
 group by all
 order by year, process
```

<LineChart
    data={historical_ratings_by_process}
    connectGroup="processes"
    x=year
    y=net_score
    yMax=100
    series=process
    sort=false
    markers=true
/>

<!-- <BubbleChart
    data={historical_ratings_by_process}
    connectGroup="processes"
    x=year
    y=liked_pct
    yMax=1
    yFmt=pct0
    yAxisTitle='% Liked'
    size=ratings
    series=process
    sort=false
/> -->

# Origins

```sql net_score_by_country
select country,
       count_if(is_liked) as liked,
       count_if(is_disliked) as disliked,
       sum(rating_value) as net_liked,
       count(*) as coffees_rated,
       liked/coffees_rated * 100 as net_score,
  from ${filtered_coffees}
 group by all
 order by net_score desc, liked desc
```

### Net Score by Country

<AreaMap
    data={net_score_by_country}
    areaCol=country
    geoJsonUrl=https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_50m_admin_0_countries.geojson
    geoId=name
    value=net_score
    colorPalette={colorGradient}
    legend=false
    tooltip={[
        {id: 'country', fmt: 'id', showColumnName: false, valueClass: 'text-xl font-semibold'},
        {id: 'net_score', fieldClass: 'text-[grey]', valueClass: 'text-[#236aa4] font-bold'},
        {id: 'liked', fieldClass: 'text-[grey]', valueClass: 'text-[#236aa4]'},
        {id: 'disliked', fieldClass: 'text-[grey]', valueClass: 'text-[#a45c23]'},
        {id: 'coffees_rated', fieldClass: 'text-[grey]'},
    ]}
/>

```sql ratings_by_country
select country,
       rating,
       rating_value,
       count(*) as ratings,
  from ${filtered_coffees}
 group by all
 order by rating_value desc
```

### Ratings by Country

<BarChart
    data={ratings_by_country}
    connectGroup="countries"
    x=country
    y=ratings
    series=rating
    swapXY=true
    colorPalette={chartColors}
    sort=false
/>

<LastRefreshed/>
