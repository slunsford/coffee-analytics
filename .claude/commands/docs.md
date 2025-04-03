Update or generate the YAML docs for the SQL model or folder of models $ARGUMENTS. Look for a matching YAML file or documentation for this model inside a combined YAML file in the same directory.

- If a uniqueness test for more than one column is required, use `unique_combination_of_columns` from the dbt_utils package and put it after the model description and before `columns:`, under `data_tests:`. Only add such a test if I ask you to. A uniqueness/primary key test for a single column should be the standard `unique` and `not_null` tests on that column only.
- Add tests for individual columns under `models.columns`; do not use the model-wide `models.data_tests` unless directed to do so.
- Use the `data_tests:` syntax instead of the deprecated `tests:`
- Don't include `version: 2` at the top; just start with `models:`
- Do not make guesses about accepted values. Only include accepted values tests when the column's values are explicitly limited in the provided code.
- Do not put quotes around descriptions.

If updating existing documentation:
- Make minimal changes, only adding/removing columns, filling in missing descriptions, or updating outlier descriptions to match the others stylistically.
- Do not update existing descriptions except to correct errors or align with the rules above or stylistically with other descriptions in the file.
- Preserve any tests already added to the model or individual columns.
- If the docs are in a combined file with other models, remove the model from the combined file and create a standalone file instead. If no models are left in the combined file after these edits, delete the combined file.

Create/overwrite the YAML file in the same directory with the same base name as the SQL model.
