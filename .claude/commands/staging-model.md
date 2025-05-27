$ARGUMENTS

Generate the staging model(s) for the given source table(s). Perform these steps for each table, one at a time:

1. Execute `dbt run-operation generate_base_model --args '{"source_name": "example_source", "table_name": "example_table"}'`
2. Make updates to the existing staging model, if it exists.
3. Add aliases to snake_case the column names, aligning all `as` keywords vertically.
  - Find the longest column name and align all `as` keywords to the next 4-space tab stop after that length.
  - (Very conservatively) expand abbreviations within column names--if you are certain you know what it is referring to from context
  - Do not add aliases that don't change the original column name or that simply remove leading underscores.
  - Do not reformat the SQL in any way (including removing empty lines) besides adding aliases.
