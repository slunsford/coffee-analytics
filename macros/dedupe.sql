-- Because dbt_utils.deduplicate keeps removing too many rows

{% macro dedupe(relation, partition_by, order_by) -%}

    from {{ relation }}
    qualify row_number() over (partition by {{ partition_by }} order by {{ order_by }}) = 1

{%- endmacro %}
