SELECT *
FROM divvy_trips
WHERE (
  {% if filter_values('trip_month_label') %}
    TO_CHAR(DATE_TRUNC('month', started_at), 'Mon YYYY') IN ({{ filter_values('trip_month_label')|where_in }})
  {% else %}
    1=1
  {% endif %}
)