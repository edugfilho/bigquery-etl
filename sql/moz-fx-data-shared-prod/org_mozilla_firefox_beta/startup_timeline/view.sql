CREATE OR REPLACE VIEW
  `moz-fx-data-shared-prod.org_mozilla_firefox_beta.startup_timeline`
AS -- Generated by bigquery_etl.view.generate_stable_views

SELECT
  * REPLACE(
    mozfun.norm.metadata(metadata) AS metadata)
FROM
  `moz-fx-data-shared-prod.org_mozilla_firefox_beta_stable.startup_timeline_v1`
