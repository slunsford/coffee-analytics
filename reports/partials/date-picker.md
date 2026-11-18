```sql cup_dates
select distinct brewed_date
  from md.cups
 where is_rated
```

<DateRange
    name=dates
    data={cup_dates}
    dates=brewed_date
/>
