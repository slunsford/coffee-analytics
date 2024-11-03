with

source as (
    from {{ source('collections', 'flavors') }}
),

renamed as (
    
     select short_id as flavor_id,
            flavor,
            coalesce(string_split(categories, ';'), ['Uncategorized']) as flavor_categories,
            {{ dbt_utils.generate_surrogate_key(['list_sort(flavor_categories)']) }} as flavor_category_group_key,
            modified_date as modified_at
            
       from source
       
)

from renamed
