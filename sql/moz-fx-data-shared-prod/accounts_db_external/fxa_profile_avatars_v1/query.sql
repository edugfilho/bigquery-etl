SELECT
  id,
  url,
  userId,
  providerId,
FROM
  EXTERNAL_QUERY(
    "moz-fx-fxa-prod.us.fxa-rds-prod-prod-fxa-profile",
    """SELECT
         id,
         url,
         userId,
         providerId
       FROM
         fxa_profile.avatars
    """
  )
