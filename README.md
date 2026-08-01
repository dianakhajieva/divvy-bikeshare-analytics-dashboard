# Divvy Bike-Share Analytics Dashboard

An interactive Apache Superset dashboard analyzing ~1.4M Chicago Divvy bike-share trips (Mar–May 2026) to compare how casual riders and annual members use the system.

![Dashboard](screenshots/dashboard-full.png)

## Research Question

How do casual riders and annual members use the bike-share system differently — and what does that suggest for membership conversion strategy?

## Data Source

[Divvy System Data](https://ride.divvybikes.com/system-data) — public trip-level data, ~1.4M records, March–May 2026.

## Key Insights

- Members show sharp commute-hour peaks (~8am / ~5pm on weekdays), while casual riders' usage is spread across midday and weekends.
- Average ride duration: members ride shorter trips on average than casual riders.
- Ride volume grew steadily from March to May, consistent with seasonal ridership increases.
- Top stations are concentrated around downtown/lakefront areas.

## Dashboard Features

- KPI cards (Handlebars + Jinja) with dynamic month-over-month comparisons
- Interactive month filter across both physical and virtual datasets
- Hourly / day-of-week rider behavior breakdowns
- Geographic density map of trip start locations
- Custom dashboard styling (`dashboard.css`)

**Screenshots:** [KPI cards](screenshots/kpi-cards.png) · [Map view](screenshots/map-view.png)
**Demo:** ![Demo](demo.gif)

## Technical Approach

**Stack:** PostgreSQL, Apache Superset (Docker), SQL, Handlebars/Jinja

**Pipeline:** raw CSVs → PostgreSQL (`sql/01_create_table.sql`) → Jinja-templated virtual datasets (`sql/02_month_dim.sql`, `sql/03_divvy_trips_filtered.sql`, `sql/04_kpi_overview.sql`) → custom KPI cards (`handlebars/`)

**Notable details:**
- Month-over-month deltas computed in SQL (`FILTER` clauses), with a minimum-volume guard to avoid misleading percentages from partial-month data
- Filtered out null station names that were inflating one ranking chart
- Single dashboard filter cascades across both a physical table and Jinja-templated datasets — normally two disconnected Superset object types

## Limitations

- Only 3 months of data — no year-over-year or seasonal extremes comparison possible
- Small percentage of trips missing station name data
- Run locally via Docker; screenshots/GIF used in place of a live public link (Superset's free public embedding isn't available)
