#warn
{{ is_unique(["dte", "location", "user_type"], "dte = DATE_SUB(@date, INTERVAL 4 DAY)") }}