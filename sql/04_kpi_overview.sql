WITH bounds AS (
  SELECT
    {% if filter_values('trip_month_label') %}
      GREATEST(
        {% for v in filter_values('trip_month_label') %}
          TO_DATE('{{ v }}', 'Mon YYYY'){% if not loop.last %}, {% endif %}
        {% endfor %}
      )
    {% else %}
      (SELECT DATE_TRUNC('month', MAX(started_at)) FROM divvy_trips)
    {% endif %} AS latest_month
)
SELECT
  COUNT(*) FILTER (
    WHERE {% if filter_values('trip_month_label') %}
      TO_CHAR(DATE_TRUNC('month', started_at), 'Mon YYYY') IN ({{ filter_values('trip_month_label')|where_in }})
    {% else %}
      1=1
    {% endif %}
  ) AS total_cnt,
  COUNT(*) FILTER (WHERE DATE_TRUNC('month', started_at) = (SELECT latest_month FROM bounds)) AS current_month_cnt,
  COUNT(*) FILTER (WHERE DATE_TRUNC('month', started_at) = (SELECT latest_month FROM bounds) - INTERVAL '1 month') AS prev_month_cnt,

  COUNT(DISTINCT start_station_name) FILTER (
    WHERE {% if filter_values('trip_month_label') %}
      TO_CHAR(DATE_TRUNC('month', started_at), 'Mon YYYY') IN ({{ filter_values('trip_month_label')|where_in }})
    {% else %}
      1=1
    {% endif %}
  ) AS total_stations,
  COUNT(DISTINCT start_station_name) FILTER (WHERE DATE_TRUNC('month', started_at) = (SELECT latest_month FROM bounds)) AS current_month_stations,
  COUNT(DISTINCT start_station_name) FILTER (WHERE DATE_TRUNC('month', started_at) = (SELECT latest_month FROM bounds) - INTERVAL '1 month') AS prev_month_stations,

  AVG(EXTRACT(EPOCH FROM (ended_at - started_at))/60) FILTER (
    WHERE {% if filter_values('trip_month_label') %}
      TO_CHAR(DATE_TRUNC('month', started_at), 'Mon YYYY') IN ({{ filter_values('trip_month_label')|where_in }})
    {% else %}
      1=1
    {% endif %}
  ) AS avg_duration,
  AVG(EXTRACT(EPOCH FROM (ended_at - started_at))/60) FILTER (WHERE DATE_TRUNC('month', started_at) = (SELECT latest_month FROM bounds)) AS current_month_duration,
  AVG(EXTRACT(EPOCH FROM (ended_at - started_at))/60) FILTER (WHERE DATE_TRUNC('month', started_at) = (SELECT latest_month FROM bounds) - INTERVAL '1 month') AS prev_month_duration

FROM divvy_trips;