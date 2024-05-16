SELECT
  submission_date,
  first_seen_date,
  locale,
  normalized_channel,
  country,
  app_name,
  app_version,
  adjust_network,
  adjust_campaign,
  adjust_ad_group,
  adjust_creative,
  play_store_attribution_campaign,
  play_store_attribution_source,
  play_store_attribution_medium,
  meta_attribution_app,
  install_source,
  is_suspicious_device_client,
  COUNTIF(is_dau) AS dau,
  COUNTIF(is_wau) AS wau,
  COUNTIF(is_mau) AS mau
FROM
  `moz-fx-data-shared-prod.telemetry_derived.mobile_engagement_clients_v1`
WHERE
  submission_date = @submission_date
GROUP BY
  submission_date,
  first_seen_date,
  locale,
  normalized_channel,
  country,
  app_name,
  app_version,
  adjust_network,
  adjust_campaign,
  adjust_ad_group,
  adjust_creative,
  play_store_attribution_campaign,
  play_store_attribution_source,
  play_store_attribution_medium,
  meta_attribution_app,
  install_source,
  is_suspicious_device_client
