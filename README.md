The combined [dbt](https://www.getdbt.com/)/[Evidence](https://evidence.dev/) project for Sean's coffee ratings log.

- [dbt project documentation](https://slunsford.github.io/coffee-analytics)
- [Evidence report](https://lunsford.coffee/)


## The Full Stack

1. Data is tracked in [Collections](https://apps.apple.com/us/app/collections-database/id1568395334), a macOS/iOS database app with Shortcuts support.[^airtable]
2. A shortcut exports the data to CSV, converts column names from `Title Case` to `snake_case`, and saves the files to S3 via [S3 Files](https://apps.apple.com/us/app/s3-storage-files/id6447647340). This shortcut is run on a schedule with automations.
3. This dbt project transforms the data in [MotherDuck](https://motherduck.com/).
4. The [Evidence site](https://lunsford.coffee/) is deployed on [Vercel](https://vercel.com/).

[^airtable]: Until recently, this was done in [Airtable](https://airtable.com/) and synced via [Fivetran](https://www.fivetran.com/).
