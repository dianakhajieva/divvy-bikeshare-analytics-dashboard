SELECT DISTINCT
  DATE_TRUNC('month', started_at)::date AS trip_month,
  TO_CHAR(DATE_TRUNC('month', started_at), 'Mon YYYY') AS trip_month_label
FROM divvy_trips
ORDER BY trip_month DESC;