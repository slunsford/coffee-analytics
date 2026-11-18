---
title: Coffees
---

{@partial "date-picker.md"}
{@partial "coffee-filters.md"}

<DataTable
    data={filtered_cups}
    rows=50
    sortable
    rowShading>
    <Column id='bean_name' title='Coffee'/>
    <Column id='roaster_name' title='Roaster'/>
    <Column id='country' colGroup='Origin'/>
    <Column id='process' colGroup='Origin'/>
    <Column id='verdict' colGroup='Cup'/>
    <Column id='brewed_date' title='Date' colGroup='Cup'/>
    <Column id='brew_method' title='Method' colGroup='Cup'/>
    <Column id='caffeine_content' title='Caffeine'/>
    <Column id='roaster_notes' title='Roaster Notes'/>
</DataTable>

<LastRefreshed/>
