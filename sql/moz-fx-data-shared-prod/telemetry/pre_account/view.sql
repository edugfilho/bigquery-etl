CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.telemetry.pre_account`
AS -- Generated by bigquery_etl.view.generate_stable_views

SELECT
  * REPLACE(
    mozfun.norm.metadata(metadata) AS metadata)
FROM
  `moz-fx-data-shared-prod.telemetry_stable.pre_account_v4`
