The combined [dbt](https://www.getdbt.com/)/[Evidence](https://evidence.dev/) project for Sean's coffee ratings log.

- [dbt project documentation](https://slunsford.github.io/coffee-analytics)
- [Evidence report](https://lunsford.coffee/)


## The Full Stack

1. Data is tracked in Bean Counter, an app for logging a coffee library, the cups brewed from it, and tasting notes mapped onto the SCA flavor wheel.[^legacy]
2. The app's export is loaded into [MotherDuck](https://motherduck.com/) (`ingest.bean_counter`).
3. This dbt project transforms the data in MotherDuck into `beans`, `cups`, `origins`, `roasters`, and flavor models.
4. The [Evidence site](https://lunsford.coffee/) is deployed on [Vercel](https://vercel.com/).

[^legacy]: Earlier versions tracked coffees in Collections and, before that, Airtable. That data was imported into Bean Counter and the old sources are no longer modeled here.
