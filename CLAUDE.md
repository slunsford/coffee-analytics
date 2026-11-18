# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Coffee Analytics** project, a dbt-powered data platform for tracking and analyzing personal coffee tasting experiences. The project transforms data exported from the Bean Counter app (loaded into MotherDuck's `ingest.bean_counter` schema) into dimensional models for personal reference and analysis. Collections and Airtable were earlier sources; their data was imported into Bean Counter and is no longer modeled here (`beans.legacy_coffee_id` keeps the old coffee_id). It follows a standard dbt medallion architecture with staging → intermediate → marts layers.

## Essential Commands

### dbt Operations
- `dbt build` — Compile, run, and test all models
- `dbt build --select model_name` — Build a specific model
- `dbt build --select model_name+` — Build a model and all downstream models
- `dbt build --select +model_name` — Build a model and all upstream models
- `dbt run` — Execute all models
- `dbt test` — Run all tests
- `dbt compile` — Compile SQL without executing
- `dbt deps` — Install dependencies from packages.yml
- `dbt clean` — Clean the target directory
- `dbt docs generate` — Generate documentation
- `dbt run-operation generate_base_model --args '{"source_name": "bean_counter", "table_name": "beans"}'` — Generate base model for a specific source and table
- `dbt run-operation generate_model_yaml --args '{"model_names": ["beans"], "include_data_types": true}'` — Generate YAML for a specific model with data types

### Evidence Reports
- `npm run dev --prefix ./reports` — Start Evidence dev server for interactive reports
- `npm run build --prefix ./reports` — Build Evidence reports for production

### Model Selection Patterns
- `dbt build --select staging.bean_counter` — Build all Bean Counter staging models
- `dbt build --select marts` — Build all mart tables
- `dbt build --select +cups` — Build the cups mart with all dependencies

## Architecture Overview

### Data Sources
- **Bean Counter**: The only source. An export of the app's tables (`beans`, `cups`, `origins`, `roasters`, `tasting_notes`, `tasting_note_flavors`, `flavor_nodes`, `export_info`). Tables and columns carry comments in the source database; check them (`duckdb_tables()`/`duckdb_columns()` `comment`) before modeling.
  - `beans`: one row per coffee, not per bag. Nothing per-bag (roast date, price) exists.
  - `cups`: one row per drink; the verdict (good/fine/bad) is optional. `verdict_value` (1/0/-1) sums to net score.
  - `origins`: zero or more rows per bean (one per disclosed blend component). `is_blend` is declared by the roaster, not derived.
  - `tasting_notes`: roaster notes carry `bean_id`; notes tasted in a cup carry `cup_id` only. `tasting_note_flavors` maps notes onto the `flavor_nodes` tree; roll up with `root_slug`/path, not `slug` (which can go stale after a re-parent).

### Model Layers

**Staging (`models/staging/`)**
- Clean and standardize source data
- Naming: `stg_source__entity.sql` (e.g., `stg_bean_counter__beans`, `stg_bean_counter__cups`)
- Materialized as views
- Handle data type conversions and basic transformations

**Intermediate (`models/intermediate/`)**
- Business logic transformations and joins
- Naming: `int_entity_action.sql` (e.g., `int_beans_origins_summarized`)
- Materialized as views
- Denormalization and data enrichment

**Marts (`models/marts/`)**
- Final dimensional models for personal coffee analytics
- Naming: entity-focused tables (e.g., `beans`, `cups`, `bean_flavors`)
- Materialized as tables
- Only marts layer is exposed to end users via Evidence reports

### Key Domains
- **Beans**: One row per coffee, with roaster, an origin summary, roaster notes, and cup totals
- **Cups**: Logged drinks and their verdicts; the fact table reports are built on, denormalized with bean attributes
- **Origins**: Per-component growing origin and process detail
- **Roasters**: Coffee roasting companies with rolled-up totals
- **Flavors**: The `flavor_nodes` tree, `tasting_notes`, and the `bean_flavors` bridge (one row per bean and flavor)

## Data Modeling Patterns

### Key Identifiers
- Primary keys use `_id` suffix (e.g., `bean_id`, `cup_id`, `roaster_id`); flavor nodes are keyed by `flavor_slug`
- Boolean fields use `is_` prefix (e.g., `is_blend`, `is_decaf`, `is_liked`)
- Cross-references maintained via relationship tests
- Verdicts: `verdict` is Good/Fine/Bad (Unrated when missing); `verdict_value` is 1/0/-1; net score is `sum(verdict_value)`

### Custom Macros (`macros/`)
- `generate_schema_name.sql` — Uses a custom `+schema` as-is instead of prefixing the target schema
- `humanize.sql` — Turns camelCase enum values (`mediumLight`) and lowercase words (`good`) into labels

## Development Standards

### Model Documentation
- All models require YAML documentation with column descriptions
- Use `data_tests:` (not deprecated `tests:`)
- Document grain, relationships, and context
- Include model descriptions explaining purpose and data sources

### Testing Strategy
- Unique/not null tests on primary keys
- Relationship tests for foreign keys
- Accepted values tests for categorical columns
- Data freshness checks on source tables
- Custom validation for data quality

### SQL Formatting Standards

**DuckDB from-first Syntax**
- Use DuckDB's from-first syntax: `from table_name` instead of `select * from table_name`
- This is cleaner and more readable for simple table selections
- Example:
```sql
with

source as (
    from {{ source('bean_counter', 'beans') }}
),

final as (
    from source
)

from final
```

**Column Selection Alignment**
- Within SELECT clauses, align column names consistently with 12-space indentation from left margin
- Place aliases on same line with `as` keyword
- Example:
```sql
     select bean_id,
            bean_name,
            roaster_id,
            coalesce(country, '[Unknown]') as country,
            verdict_value
```

**Join and Keyword Alignment**
- All SQL keywords (`from`, `join`, `left join`, `where`, `group by`, etc.) are right-aligned
- Single space between right-aligned keyword and following table/column names
- Use `using` keyword when possible for natural joins on identical column names
- Example:
```sql
       from beans
  left join origins
      using (bean_id)
  left join roasters
      using (roaster_id)
      where is_decaf = true
```

**CTE Structure**
- Use descriptive CTE names that explain the transformation
- Start with `source` CTE for staging models
- Include `final` CTE for complex models
- Separate CTEs with blank lines and clear comments

### Field Naming Conventions
- **Identifiers**: Use `_id` suffix (bean_id, roaster_id)
- **Booleans**: Use `is_` prefix (is_blend, is_decaf, is_liked)
- **Dates**: Use clear suffixes (`_at` for timestamps, `_date` for dates)
- **Categorical**: Use descriptive names (verdict, caffeine_content)
- **Nulls**: Handle with coalesce and meaningful defaults

### Model Materialization
- **Staging**: Views (for real-time source data)
- **Intermediate**: Views (for transformation flexibility)
- **Marts**: Tables (for performance and end-user access)

## Code Quality Standards

### Error Handling
- Use coalesce() for null handling with meaningful defaults
- Provide fallback values for missing data (e.g., '[Unknown]', '[Blend]')
- Validate data types and handle edge cases

### Performance Considerations
- Use appropriate materializations for each layer
- Optimize join patterns and avoid unnecessary complexity
- Consider incremental models for large datasets

### Documentation Requirements
- All columns must have descriptions
- Model descriptions should explain purpose
- Include examples for complex transformations
- Document any assumptions or data quirks
