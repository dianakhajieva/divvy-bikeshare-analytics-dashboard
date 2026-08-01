# Divvy Bike-Share Analytics Dashboard

An interactive Apache Superset dashboard analyzing ~1.4M Chicago Divvy
bike-share trips to understand how casual riders and annual members
use the system differently.

![Dashboard Overview](screenshots/dashboard-full.png)

## Research Question

How do casual riders and annual members use the bike-share system
differently — and what does that suggest for a membership conversion
strategy?

## Data Source

[Divvy System Data](https://ride.divvybikes.com/system-data) — public
trip-level data published by Chicago's bike-share program.
- **Period analyzed:** March – May 2026
- **Volume:** ~1.4 million individual trip records
- **Fields:** trip timestamps, start/end stations, coordinates, rider
  type (member/casual), bike type

## Key Insights

*(Fill in with your actual numbers once you've reviewed the final charts — a few sentences on: what the hour-of-day chart shows about member vs. casual commute patterns, whether casual riders ride longer on average, top stations, any seasonal growth trend across Mar–May.)*

- Members show a distinct commute pattern with peaks around [X]am/[X]pm on weekdays, while casual riders' usage is spread more evenly across [weekends/midday].
- Average ride duration: members ride [X] min on average vs. casual riders at [X] min.
- [Top station] accounts for the highest trip volume, concentrated in [area/context].
- Total ride volume grew [X]% from March to May, consistent with seasonal spring ridership increases.

## Dashboard Features

- **KPI overview row** — custom Handlebars-templated cards showing
  total rides, unique stations, and average ride duration, each with
  a dynamic month-over-month comparison (green/red/grey indicators
  computed live via Jinja-templated SQL, not hardcoded)
- **Interactive month filter** — cascades across both a physical
  table and a Jinja-templated virtual dataset simultaneously
- **Time pattern analysis** — hourly and day-of-week breakdowns split
  by rider type
- **Geographic visualization** — deck.gl density map of trip start
  locations
- **Custom dashboard styling** — modern card-based design system

## Technical Approach

**Stack:** PostgreSQL, Apache Superset (self-hosted via Docker), SQL,
Handlebars/Jinja templating

**Data pipeline:**
1. Raw CSVs loaded into PostgreSQL via DBeaver
2. Custom SQL views (`divvy_trips_filtered`, `kpi_overview`,
   `month_dim`) built to support dynamic, filter-aware calculations
3. Month-over-month deltas computed server-side via SQL `FILTER`
   clauses, not client-side estimation

**Notable engineering details:**
- KPI cards use **Jinja-templated virtual datasets** so a single
  dashboard-level filter drives both simple charts and custom
  Handlebars visualizations — these are architecturally different
  Superset objects that don't sync by default
- Guarded the month-over-month comparison against a data quality
  issue: the raw dataset contains a handful of stray late-February
  trip records, which without safeguards produced a misleading
  six-figure percentage change; added a minimum-volume threshold so
  the comparison silently falls back to "no prior data" instead of
  showing a meaningless number
- Filtered out records with null/missing station names from
  ranking charts after discovering they were being grouped into a
  single artificially inflated "category"

## Limitations

- Dataset covers only 3 months (Mar–May 2026); seasonal comparisons
  (e.g. winter vs. summer ridership) aren't possible with this window
- A small percentage of trips have missing station name data
- Hosted locally for development; screenshots/GIF used for
  portfolio presentation rather than a live public link (see note
  below)

## Why No Live Link

This dashboard runs on a local Superset instance rather than a
public hosting service. Fully public dashboard embedding on hosted
platforms like Preset requires a paid plan; screenshots and the demo
GIF below give an accurate representation of the finished,
interactive product.

## Demo

![Dashboard Demo](demo.gif)
