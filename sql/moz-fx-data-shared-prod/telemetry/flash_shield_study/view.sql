CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.telemetry.flash_shield_study`
AS -- Generated by bigquery_etl.view.generate_stable_views

SELECT
  * REPLACE(
    mozfun.norm.metadata(metadata) AS metadata)
FROM
  `moz-fx-data-shared-prod.telemetry_stable.flash_shield_study_v4`
