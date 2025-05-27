# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Coffee Analytics** project, a dbt-powered data platform for tracking and analyzing personal coffee tasting experiences. The project transforms coffee data from Collections (primary source) and Airtable (historic data) into dimensional models for personal reference and analysis. It follows a standard dbt medallion architecture with staging → intermediate → marts layers.

## Essential Commands

### dbt Operations
- `/Users/sean/Developer/dbt-duckdb/bin/dbt build` — Compile, run, and test all models
- `/Users/sean/Developer/dbt-duckdb/bin/dbt build --select model_name` — Build a specific model
- `/Users/sean/Developer/dbt-duckdb/bin/dbt build --select model_name+` — Build a model and all downstream models
- `/Users/sean/Developer/dbt-duckdb/bin/dbt build --select +model_name` — Build a model and all upstream models
- `/Users/sean/Developer/dbt-duckdb/bin/dbt run` — Execute all models
- `/Users/sean/Developer/dbt-duckdb/bin/dbt test` — Run all tests
- `/Users/sean/Developer/dbt-duckdb/bin/dbt compile` — Compile SQL without executing
- `/Users/sean/Developer/dbt-duckdb/bin/dbt deps` — Install dependencies from packages.yml
- `/Users/sean/Developer/dbt-duckdb/bin/dbt clean` — Clean the target directory
- `/Users/sean/Developer/dbt-duckdb/bin/dbt docs generate` — Generate documentation

### Evidence Reports
- `npm run dev --prefix ./reports` — Start Evidence dev server for interactive reports
- `npm run build --prefix ./reports` — Build Evidence reports for production

### Model Selection Patterns
- `/Users/sean/Developer/dbt-duckdb/bin/dbt build --select staging.collections` — Build all Collections staging models (primary source)
- `/Users/sean/Developer/dbt-duckdb/bin/dbt build --select staging.airtable` — Build all Airtable staging models (historic data)
- `/Users/sean/Developer/dbt-duckdb/bin/dbt build --select marts` — Build all mart tables
- `/Users/sean/Developer/dbt-duckdb/bin/dbt build --select +coffees` — Build coffees model with all dependencies

## Architecture Overview

### Data Sources
- **Collections**: Primary coffee database for current coffee tracking and ratings
- **Airtable**: Historic coffee data source, maintained for legacy data and some reference information

### Model Layers

**Staging (`models/staging/`)**
- Clean and standardize source data
- Naming: `stg_source__entity.sql` (e.g., `stg_collections__coffees`, `stg_airtable__ratings`)
- Materialized as views
- Handle data type conversions and basic transformations

**Intermediate (`models/intermediate/`)**
- Business logic transformations and joins
- Naming: `int_entity_action.sql` (e.g., `int_flavor_profiles_unnested`)
- Materialized as views
- Denormalization and data enrichment

**Marts (`models/marts/`)**
- Final dimensional models for personal coffee analytics
- Naming: entity-focused tables (e.g., `coffees`, `ratings`, `flavors`)
- Materialized as tables
- Only marts layer is exposed to end users via Evidence reports

### Key Domains
- **Coffees**: Coffee records with roasters, origins, and characteristics
- **Ratings**: Personal coffee ratings and tasting notes
- **Flavors**: Flavor profiles and categories
- **Origins**: Geographic coffee origins and regions
- **Roasters**: Coffee roasting companies

## Data Modeling Patterns

### Key Identifiers
- Primary keys use `_id` suffix (e.g., `coffee_id`, `roaster_id`)
- Surrogate keys for flavor profiles use `_key` suffix
- Boolean fields use `is_` prefix (e.g., `is_available`, `is_decaf`)
- Cross-references maintained via relationship tests

### Primary Entities
- **Coffees**: Central entity representing individual coffee records
- **Ratings**: Individual coffee ratings and evaluations
- **Flavors**: Flavor categories and profiles
- **Origins**: Geographic origins and regions

### Custom Macros (`macros/`)
- `rating_value.sql` — Converts rating text to numeric values (-1, 0, 1)
- `extract_id.sql` — Extracts ID from Airtable relationship fields
- `extract_ids.sql` — Extracts multiple IDs from Airtable array fields
- `dedupe.sql` — Deduplication logic for source data

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
    from {{ source('collections', 'coffees') }}
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
     select coffee_id,
            coffee_name,
            roaster_id,
            coalesce(country, '[Blend]') as country,
            rating_value
```

**Join and Keyword Alignment**
- All SQL keywords (`from`, `join`, `left join`, `where`, `group by`, etc.) are right-aligned
- Single space between right-aligned keyword and following table/column names
- Use `using` keyword when possible for natural joins on identical column names
- Example:
```sql
       from coffees
  left join origins
      using (origin_id)
  left join roasters
      using (roaster_id)
      where is_available = true
```

**CTE Structure**
- Use descriptive CTE names that explain the transformation
- Start with `source` CTE for staging models
- Include `final` CTE for complex models
- Separate CTEs with blank lines and clear comments

### Field Naming Conventions
- **Identifiers**: Use `_id` suffix (coffee_id, roaster_id)
- **Booleans**: Use `is_` prefix (is_available, is_decaf, is_favorite)
- **Dates**: Use clear suffixes (`_at` for timestamps, `_date` for dates)
- **Categorical**: Use descriptive names (availability, caffeine_content)
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