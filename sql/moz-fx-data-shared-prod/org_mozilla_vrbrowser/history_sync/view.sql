CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.org_mozilla_vrbrowser.history_sync`
AS -- Generated by bigquery_etl.view.generate_stable_views

SELECT
  * REPLACE(
    mozfun.norm.metadata(metadata) AS metadata)
FROM
  `moz-fx-data-shared-prod.org_mozilla_vrbrowser_stable.history_sync_v1`
