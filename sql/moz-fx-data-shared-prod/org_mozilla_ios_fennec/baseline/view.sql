CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.org_mozilla_ios_fennec.baseline`
AS -- Generated by bigquery_etl.view.generate_stable_views

SELECT
  * REPLACE(
    mozfun.norm.metadata(metadata) AS metadata)
FROM
  `moz-fx-data-shared-prod.org_mozilla_ios_fennec_stable.baseline_v1`
