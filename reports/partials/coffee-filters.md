```sql brewed_cups
-- Only rated cups: every report here is about verdicts
select cups.*,
       beans.roaster_notes
  from md.cups
  join md.beans
 using (bean_id)
 where cups.is_rated
```

```sql dimensions
select country,
       roaster_name,
       process,
       verdict,
       count(distinct bean_id) as coffees
  from ${brewed_cups}
 where brewed_date between date_add('${inputs.dates.start}'::date, interval 1 day)
                       and date_add('${inputs.dates.end}'::date, interval 1 day)
 group by all
```

<DimensionGrid
    data={dimensions}
    name=selected_dimensions
    metric='sum(coffees)'
    multiple
/>

```sql filtered_cups
  from ${brewed_cups}
 where ${inputs.selected_dimensions}
   and brewed_date between date_add('${inputs.dates.start}'::date, interval 1 day)
                       and date_add('${inputs.dates.end}'::date, interval 1 day)
       -- For some reason the dates are being set one day before the start/end dates in the picker
 order by bean_name, brewed_date
```
