-- Generated by ./bqetl generate events_daily
SELECT
  * EXCEPT (submission_date)
FROM
  fenix_derived.event_types_history_v1
WHERE
  submission_date = @submission_date
