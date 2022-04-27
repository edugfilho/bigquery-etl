CREATE TEMP FUNCTION FORMAT_FXA_DATE(date_string STRING)
RETURNS DATE AS (
  CASE
  WHEN
    REGEXP_CONTAINS(date_string, r"^(\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}\.\d{1,3}Z)$")
  THEN
    DATE(DATETIME(SPLIT(date_string, ".")[OFFSET(0)]))
  WHEN
    REGEXP_CONTAINS(date_string, r"^(\d{2}/\d{2}/\d{4})$")
  THEN
    PARSE_DATE("%m/%d/%Y", date_string)
  WHEN
    REGEXP_CONTAINS(date_string, r"^(\d{2}/\d{2}/\d{4}\s\d{2}:\d{2}\s(AM|PM))$")
  THEN
    DATE(PARSE_DATETIME("%d/%m/%Y %I:%M %p", date_string))
  ELSE
    DATE(
      NULLIF(date_string, '')
    )  -- In case new unexpected date format comes along this will fail. This is expected and intended behaviour.
  END
);
BEGIN
  WITH JUST_LOADED_CONTACTS AS (
    SELECT
        -- LOWER(email),  -- do we actually need email? Looks like we could use email_id as a unique identifier? -- not null // string
      email_id,  -- not null // string
      basket_token,  -- 8729 so far with null values | is this a problem?  // string
      NULLIF(
        sfdc_id,
        ''
      ) AS sfdc_id,  -- 1142993 so far with null values | is this a problem?  // string
      NULLIF(
        fxa_id,
        ''
      ) AS fxa_id,  -- 121606 nulls || this is bad?
      CAST(
        COALESCE(CAST(double_opt_in AS INTEGER), 0) AS BOOLEAN
      ) AS double_opt_in,  -- no nulls, true or false value  // boolean
      CAST(
        COALESCE(CAST(has_opted_out_of_email AS INTEGER), 0) AS BOOLEAN
      ) AS has_opted_out_of_email,  -- int, no nulls, true or false value  // boolean
      LOWER(
        COALESCE(NULLIF(email_lang, ''), "unknown")
      ) AS email_lang, --  6126 nulls, and case differences  // string
      LOWER(
        email_format
      ) AS email_format,  -- no nulls, CHAR (T OR H)  // string
      LOWER(
        COALESCE(NULLIF(mailing_country, ''), "unknown")
      ) AS mailing_country,  -- no nulls  // string
      LOWER(
        COALESCE(NULLIF(cohort, ''), "unknown")
      ) AS cohort,  -- 1320918 nulls
      FORMAT_FXA_DATE(
        fxa_created_date
      ) AS fxa_created_date,  -- 107057 nulls  -- need to parse the date
      LOWER(
        COALESCE(NULLIF(fxa_first_service, ''), "unknown")
      ) AS fxa_first_service,  -- no nulls  // string
      CAST(
        COALESCE(CAST(fxa_account_deleted AS INTEGER), 0) AS BOOLEAN
      ) AS fxa_account_deleted,  -- 77207 nulls // boolean but contains nulls | how should they be treated?
      CAST(
        COALESCE(CAST(sub_mozilla_foundation AS INTEGER), 0) AS BOOLEAN
      ) AS sub_mozilla_foundation,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_common_voice AS INTEGER), 0) AS BOOLEAN
      ) AS sub_common_voice,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_hubs AS INTEGER), 0) AS BOOLEAN
      ) AS sub_hubs,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_mixed_reality AS INTEGER), 0) AS BOOLEAN
      ) AS sub_mixed_reality,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_internet_health_report AS INTEGER), 0) AS BOOLEAN
      ) AS sub_internet_health_report,  -- # nulls  // boolean
      CAST(
        COALESCE(CAST(sub_miti AS INTEGER), 0) AS BOOLEAN
      ) AS sub_miti,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_mozilla_fellowship_awardee_alumni AS INTEGER), 0) AS BOOLEAN
      ) AS sub_mozilla_fellowship_awardee_alumni,  -- # nulls  // boolean
      CAST(
        COALESCE(CAST(sub_mozilla_festival AS INTEGER), 0) AS BOOLEAN
      ) AS sub_mozilla_festival,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_mozilla_technology AS INTEGER), 0) AS BOOLEAN
      ) AS sub_mozilla_technology,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_mozillians_nda AS INTEGER), 0) AS BOOLEAN
      ) AS sub_mozillians_nda,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_firefox_accounts_journey AS INTEGER), 0) AS BOOLEAN
      ) AS sub_firefox_accounts_journey,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_knowledge_is_power AS INTEGER), 0) AS BOOLEAN
      ) AS sub_knowledge_is_power,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_take_action_for_the_internet AS INTEGER), 0) AS BOOLEAN
      ) AS sub_take_action_for_the_internet,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_test_pilot AS INTEGER), 0) AS BOOLEAN
      ) AS sub_test_pilot,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_firefox_news AS INTEGER), 0) AS BOOLEAN
      ) AS sub_firefox_news,  -- 2 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_about_mozilla AS INTEGER), 0) AS BOOLEAN
      ) AS sub_about_mozilla,  -- 13436 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_apps_and_hacks AS INTEGER), 0) AS BOOLEAN
      ) AS sub_apps_and_hacks,  -- 12988 nulls  // boolean
      CAST(
        COALESCE(CAST(sub_rally AS INTEGER), 0) AS BOOLEAN
      ) AS sub_rally,  -- 13641 nulls  // boolean
      CAST(
        COALESCE(CAST(NULLIF(sub_firefox_sweepstakes, '') AS INTEGER), 0) AS BOOLEAN
      ) AS sub_firefox_sweepstakes,  -- 14226 nulls  // boolean
      LOWER(
        NULLIF(vpn_waitlist_geo, '')
      ) AS vpn_waitlist_geo,  -- 1221463 nulls, contains case diffences  // no_value is a bad choice of default, should this just be null?
      SPLIT(
        NULLIF(vpn_waitlist_platform, ''),
        ","
      ) AS vpn_waitlist_platform,  -- 1230937 nulls, single field contains multiple values comma separated, should this be a repeated field?  // repeated string field
      relay_waitlist_geo,  -- # missing field, need to verify, maybe it's related to reusing old connector
      RECIPIENT_ID AS recipient_id,  -- Acoustic system field
      FORMAT_FXA_DATE(
        Last_Modified_Date
      ) AS acoustic_last_modifled_date,  -- Acoustic system field
      @submission_date AS job_date,
      CURRENT_DATETIME() AS processed_at,
    FROM
      `moz-fx-data-bq-fivetran.acoustic_sftp.contact_export`
  )

  , YESTERDAY_LOADED_CONTACTS AS (
      SELECT * EXCEPT(job_date, processed_at)
      FROM `moz-fx-data-marketing-prod.acoustic.contact_v1`  -- possible that this may not exist on first run
      WHERE job_date = DATE_SUB(@submission_date, INTERVAL 1 DAY)
  )


  SELECT * FROM JUST_LOADED_CONTACTS
  UNION ALL
  SELECT
    *,
    @submission_date AS job_date,
    CURRENT_DATETIME() AS processed_at,
  FROM YESTERDAY_LOADED_CONTACTS
  WHERE email_id NOT IN (SELECT DISTINCT email_id FROM JUST_LOADED_CONTACTS);

  TRUNCATE TABLE `moz-fx-data-bq-fivetran.acoustic_sftp.contact_export`;
END;
