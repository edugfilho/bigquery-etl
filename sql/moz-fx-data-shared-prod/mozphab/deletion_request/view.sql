CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.mozphab.deletion_request`
AS -- Generated by bigquery_etl.view.generate_stable_views

SELECT
  * REPLACE(
    mozfun.norm.metadata(metadata) AS metadata)
FROM
  `moz-fx-data-shared-prod.mozphab_stable.deletion_request_v1`
