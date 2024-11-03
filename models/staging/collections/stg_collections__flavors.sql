with

source as (
    from {{ source('collections', 'flavors') }}
),

renamed as (
    
     select short_id as flavor_id,
            flavor,
            categories as flavor_categories,
            coalesce(string_split(categories, ', '), ['Uncategorized']) as flavor_categories_list,
            flavor_categories_list[1] as primary_flavor_category,
            {{ dbt_utils.generate_surrogate_key(['list_sort(flavor_categories_list)']) }} as flavor_category_group_key,
            modified_date as modified_at
            
       from source
       
)

from renamed
