{% macro extract_id(col_name) -%}

    regexp_extract({{ col_name }}, 'rec\w+')

{%- endmacro %}

{% macro extract_ids(col_name) -%}

    regexp_extract_all({{ col_name }}, 'rec\w+')

{%- endmacro %}
