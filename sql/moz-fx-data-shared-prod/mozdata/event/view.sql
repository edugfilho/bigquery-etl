CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.mozdata.event`
AS -- Generated by bigquery_etl.view.generate_stable_views

SELECT
  * REPLACE(
    mozfun.norm.metadata(metadata) AS metadata)
FROM
  `moz-fx-data-shared-prod.mozdata_stable.event_v1`
