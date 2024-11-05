```sql dimensions
select roaster,
       country,
       process
  from md.coffees
 where rated_date between date_add('${inputs.dates.start}'::date, interval 1 day)
                      and date_add('${inputs.dates.end}'::date, interval 1 day)
```

<DimensionGrid 
    data={dimensions} 
    name=selected_dimensions
    multiple
/>

```sql filtered_coffees
  from md.coffees
 where ${inputs.selected_dimensions}
   and rated_date between date_add('${inputs.dates.start}'::date, interval 1 day)
                      and date_add('${inputs.dates.end}'::date, interval 1 day)
       -- For some reason the dates are being set one day before the start/end dates in the picker
 order by coffee_name
```
