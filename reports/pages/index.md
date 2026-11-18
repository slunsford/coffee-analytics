---
title: Roasters & Origins
---

{@partial "date-picker.md"}
{@partial "coffee-filters.md"}

```sql coffee_counts
select count(distinct country) filter (where country not like '[%') as countries,
       count(distinct roaster_id) as roasters,
       count(distinct bean_id) as coffees,
  from ${filtered_cups}
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

# Coffee Flow

```sql coffee_sankey
select country,
       roaster_name,
       count(distinct bean_id) as coffees
  from ${filtered_cups}
 group by all
```

```sql coffee_sankey_with_process
select country as source,
       process as target,
       count(distinct bean_id) as coffees
  from ${filtered_cups}
 group by all

union all

select process as source,
       roaster_name as target,
       count(distinct bean_id) as coffees
  from ${filtered_cups}
 group by all
```


<Tabs>
  <Tab label="Origins &rarr; Roasters">
    <SankeyDiagram
      data={coffee_sankey}
      sourceCol=country
      targetCol=roaster_name
      valueCol=coffees
      linkColor=gradient
    />
  </Tab>
  <Tab label="Origins &rarr; Processes &rarr; Roasters">
    <SankeyDiagram
      data={coffee_sankey_with_process}
      sourceCol=source
      targetCol=target
      valueCol=coffees
      linkColor=gradient
    />
  </Tab>
</Tabs>


# Roasters

### Verdicts by Roaster

```sql verdicts_by_roaster
select roaster_name,
       verdict,
       verdict_value,
       count(*) as cups,
  from ${filtered_cups}
 group by all
 order by verdict_value desc
```

<BarChart
    data={verdicts_by_roaster}
    connectGroup="roasters"
    x=roaster_name
    y=cups
    series=verdict
    swapXY=true
    sort=false
    colorPalette=goodNeutralBad
/>

### Net Score by Roaster

```sql net_score_by_roaster
select roaster_name,
       sum(verdict_value) as net_liked,
       count(*) as cups_rated,
       net_liked/cups_rated * 100 as net_score,
  from ${filtered_cups}
 group by all
 order by all
```

<BubbleChart
    data={net_score_by_roaster}
    x=roaster_name
    y=net_score
    size=cups_rated
    yFmt=num0
    sort=false
/>

```sql historical_verdicts_by_roaster
select roaster_name,
       date_trunc('year', brewed_date) as date_year,
       year(brewed_date)::string as year,
       count_if(is_liked) as liked,
       count_if(is_disliked) as disliked,
       sum(verdict_value) as net_liked,
       count(*) as cups_rated,
       net_liked/cups_rated * 100 as net_score,
  from ${filtered_cups}
 group by all
 order by year, roaster_name
```

```sql roasters_list
select distinct roaster_name
  from ${historical_verdicts_by_roaster}
 order by all
```

<LineChart
    data={historical_verdicts_by_roaster}
    connectGroup="roasters"
    x=year
    y=net_score
    yMax=100
    series=roaster_name
    seriesOrder={roasters_list}
    sort=false
    markers=true
/>

# Processes

### Verdicts by Process

```sql verdicts_by_process
select process,
       verdict,
       verdict_value,
       count(*) as cups,
  from ${filtered_cups}
 where process not like '%Unknown%'
 group by all
 order by verdict_value desc
```

```sql processes_list
select distinct process
  from ${historical_verdicts_by_process}
 order by all
```

<BarChart
    data={verdicts_by_process}
    connectGroup="processes"
    x=process
    y=cups
    series=verdict
    swapXY=true
    sort=false
    colorPalette=goodNeutralBad
/>

### Net Score by Process

```sql net_score_by_process
select process,
       sum(verdict_value) as net_liked,
       count(*) as cups_rated,
       net_liked/cups_rated * 100 as net_score,
  from ${filtered_cups}
 where process not like '%Unknown%'
 group by all
 order by all
```

<BubbleChart
    data={net_score_by_process}
    x=process
    y=net_score
    size=cups_rated
    sort=false
    yFmt=num0
/>

```sql historical_verdicts_by_process
select process,
       date_trunc('year', brewed_date) as date_year,
       year(brewed_date)::string as year,
       count_if(is_liked) as liked,
       count_if(is_disliked) as disliked,
       sum(verdict_value) as net_liked,
       count(*) as cups_rated,
       liked/cups_rated * 100 as net_score,
  from ${filtered_cups}
 where process not like '%Unknown%'
 group by all
 order by year, process
```

<LineChart
    data={historical_verdicts_by_process}
    connectGroup="processes"
    x=year
    y=net_score
    yMax=100
    series=process
    sort=false
    markers=true
/>

# Origins

### Net Score by Country

```sql net_score_by_country
select country,
       count_if(is_liked) as liked,
       count_if(is_disliked) as disliked,
       sum(verdict_value) as net_liked,
       count(*) as cups_rated,
       net_liked/cups_rated * 100 as net_score,
  from ${filtered_cups}
 where country not like '%Blend%'
 group by all
 order by all
```

<Tabs>
  <Tab label="World Map">
    <AreaMap
        data={net_score_by_country}
        areaCol=country
        geoJsonUrl=https://d2ad6b4ur7yvpq.cloudfront.net/naturalearth-3.3.0/ne_50m_admin_0_countries.geojson
        geoId=name
        value=net_score
        legend=false
        connectGroup="countries"
        tooltip={[
            {id: 'country', fmt: 'id', showColumnName: false, valueClass: 'text-xl font-semibold'},
            {id: 'net_score', fieldClass: 'text-[grey]', valueClass: 'text-[#236aa4] font-bold'},
            {id: 'liked', fieldClass: 'text-[grey]', valueClass: 'text-[#236aa4]'},
            {id: 'disliked', fieldClass: 'text-[grey]', valueClass: 'text-[#a45c23]'},
            {id: 'cups_rated', fieldClass: 'text-[grey]'},
        ]}
    />
  </Tab>
  <Tab label="Bubble Chart">
    <BubbleChart
        data={net_score_by_country}
        x=country
        y=net_score
        size=cups_rated
            yFmt=num0
        sort=false
        connectGroup="countries"
    />
  </Tab>
</Tabs>

```sql verdicts_by_country
select country,
       verdict,
       verdict_value,
       count(*) as cups,
  from ${filtered_cups}
 group by all
 order by verdict_value desc
```

### Verdicts by Country

<BarChart
    data={verdicts_by_country}
    connectGroup="countries"
    x=country
    y=cups
    series=verdict
    swapXY=true
    sort=false
    colorPalette=goodNeutralBad
/>

<LastRefreshed/>
