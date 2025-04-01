# Coffee Analytics Project Guide

## Build Commands
- `/Users/sean/Developer/dbt-duckdb/bin/dbt build` - Build and test all models
- `/Users/sean/Developer/dbt-duckdb/bin/dbt build -s model_name` - Build and test specific model
- `/Users/sean/Developer/dbt-duckdb/bin/dbt build -s +model_name` - Build and test model with all upstream dependencies
- `/Users/sean/Developer/dbt-duckdb/bin/dbt build -s model_name+` - Build model with all downstream dependencies
- `/Users/sean/Developer/dbt-duckdb/bin/dbt run` - Build all models without testing
- `/Users/sean/Developer/dbt-duckdb/bin/dbt run -s model_name` - Build specific model without testing
- `/Users/sean/Developer/dbt-duckdb/bin/dbt run -s +model_name` - Build model with all upstream dependencies
- `/Users/sean/Developer/dbt-duckdb/bin/dbt run -s model_name+` - Build model with all downstream dependencies
- `/Users/sean/Developer/dbt-duckdb/bin/dbt test` - Run all tests
- `/Users/sean/Developer/dbt-duckdb/bin/dbt test -s model_name` - Test specific model
- `/Users/sean/Developer/dbt-duckdb/bin/dbt clean` - Clean target directory
- `npm run dev --prefix ./reports` - Start Evidence dev server
- `npm run build --prefix ./reports` - Build Evidence reports

## Code Style Guidelines
- **Naming**: snake_case for all SQL objects (tables, columns, CTEs)
- **SQL Structure**: Use CTEs with descriptive names, align joins/where clauses
- **Model Naming**:
  - Staging: stg_source__entity (e.g., stg_airtable__coffees)
  - Intermediate: int_entity_action (e.g., int_flavor_profiles_unnested)
  - Marts: entity-focused tables (e.g., coffees, ratings)
- **Fields/Types**:
  - Use _id suffix for identifiers
  - Use is_ prefix for boolean fields
  - Consistent handling of nulls (use coalesce with default values)
- **Macros**: Extract reusable logic into macros (e.g., rating_value)
- **Comments**: Document complex logic or calculations