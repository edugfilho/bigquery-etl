-- Generated by bigquery_etl.view.generate_stable_views
CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.telemetry.account_ecosystem`
AS
SELECT
  * REPLACE (mozfun.norm.metadata(metadata) AS metadata)
FROM
  `moz-fx-data-shared-prod.telemetry_stable.account_ecosystem_v4`