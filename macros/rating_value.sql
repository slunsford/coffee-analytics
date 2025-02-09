{% macro rating_value(rating_column) -%}

    case {{ rating_column }}
        when 'Good' then 1
        when 'Fine' then 0
        when 'Bad' then -1
        end


{%- endmacro %}
