$ARGUMENTS

Generate the staging model for the given source table:

1. Run the `generate_base_model` dbt operation.
2. Add aliases to snake_case the column names, aligning all `as` keywords vertically.
  - Find the longest column name and align all `as` keywords to the next 4-space tab stop after that length.
  - (Very conservatively) expand abbreviations within column names--if you are certain you know what it is referring to from context
  - Do not add aliases that don't change the original column name or that simply remove leading underscores.
  - Do not reformat the SQL in any way (including removing empty lines) besides adding aliases.
