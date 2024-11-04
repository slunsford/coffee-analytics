```sql rating_dates
select distinct rated_date
  from md.coffees
```

<DateRange
    name=dates
    data={rating_dates}
    dates=rated_date
/>

