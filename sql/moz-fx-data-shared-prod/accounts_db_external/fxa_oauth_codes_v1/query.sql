SELECT
  clientId,
  userId,
  scope,
  createdAt,
  SAFE.TIMESTAMP_MILLIS(SAFE_CAST(authAt AS INT)) AS authAt,
  amr,
  aal,
  SAFE_CAST(offline AS BOOL) AS offline,
  codeChallengeMethod,
  SAFE.TIMESTAMP_MILLIS(SAFE_CAST(profileChangedAt AS INT)) AS profileChangedAt,
  sessionTokenId,
FROM
  EXTERNAL_QUERY(
    "moz-fx-fxa-prod.us.fxa-oauth-prod-prod-fxa-oauth",
    """SELECT
         clientId,
         userId,
         scope,
         createdAt,
         authAt,
         amr,
         aal,
         offline,
         codeChallengeMethod,
         profileChangedAt,
         sessionTokenId
       FROM
         fxa_oauth.codes
    """
  )
