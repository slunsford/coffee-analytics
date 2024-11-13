```sql rating_dates
select distinct rated_date
  from md.ratings
```

<DateRange
    name=dates
    data={rating_dates}
    dates=rated_date
/>

