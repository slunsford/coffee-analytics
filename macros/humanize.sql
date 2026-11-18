{#
    Turn the camelCase enum values Bean Counter exports (e.g. mediumLight, wetHulled)
    and lowercase words (e.g. good) into display labels (Medium Light, Wet Hulled, Good).
#}
{% macro humanize(column_name) -%}
    array_to_string(
        list_transform(
            string_split(regexp_replace({{ column_name }}, '([a-z0-9])([A-Z])', '\1 \2', 'g'), ' '),
            word -> upper(word[1]) || word[2:]
        ),
        ' '
    )
{%- endmacro %}
