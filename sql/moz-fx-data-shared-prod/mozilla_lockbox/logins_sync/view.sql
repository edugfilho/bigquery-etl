CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.mozilla_lockbox.logins_sync`
AS -- Generated by bigquery_etl.view.generate_stable_views

SELECT
  * REPLACE(
    mozfun.norm.metadata(metadata) AS metadata)
FROM
  `moz-fx-data-shared-prod.mozilla_lockbox_stable.logins_sync_v1`
