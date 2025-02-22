---
title: Coffees
---

{@partial "date-picker.md"}
{@partial "coffee-filters.md"}

<DataTable
    data={filtered_coffees}
    rows=50
    sortable
    rowShading>
    <Column id='coffee_name'/>
    <Column id='roaster'/>
    <Column id='country' colGroup='Origin'/>
    <Column id='world_region' colGroup='Origin'/>
    <Column id='favorite_emoji' title='Favorite' align='center' colGroup='Rating'/>
    <Column id='rating' colGroup='Rating'/>
    <Column id='rated_date' title='Date' colGroup='Rating'/>
    <Column id='caffeine_content' title='Caffeine'/>
    <Column id='process'/>
    <Column id='availability'/>
</DataTable>

<LastRefreshed/>
