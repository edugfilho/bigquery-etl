CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.mozilla_lockbox.events`
AS -- Generated by bigquery_etl.view.generate_stable_views

SELECT
  * REPLACE(
    mozfun.norm.metadata(metadata) AS metadata)
FROM
  `moz-fx-data-shared-prod.mozilla_lockbox_stable.events_v1`
