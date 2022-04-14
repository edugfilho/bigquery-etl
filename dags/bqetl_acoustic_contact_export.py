# Generated via https://github.com/mozilla/bigquery-etl/blob/main/bigquery_etl/query_scheduling/generate_airflow_dags.py

from airflow import DAG
from operators.task_sensor import ExternalTaskCompletedSensor
import datetime
from utils.gcp import bigquery_etl_query, gke_command

docs = """
### bqetl_acoustic_contact_export

Built from bigquery-etl repo, [`dags/bqetl_acoustic_contact_export.py`](https://github.com/mozilla/bigquery-etl/blob/main/dags/bqetl_acoustic_contact_export.py)

#### Description

Processing data loaded by
fivetran_acoustic_contact_export
DAG to prepare it for Looker.

#### Owner

kignasiak@mozilla.com
"""


default_args = {
    "owner": "kignasiak@mozilla.com",
    "start_date": datetime.datetime(2021, 1, 1, 0, 0),
    "end_date": None,
    "email": ["telemetry-alerts@mozilla.com", "kignasiak@mozilla.com"],
    "depends_on_past": False,
    "retry_delay": datetime.timedelta(seconds=300),
    "email_on_failure": True,
    "email_on_retry": True,
    "retries": 2,
}

tags = ["impact/tier_3", "repo/bigquery-etl"]

with DAG(
    "bqetl_acoustic_contact_export", default_args=default_args, doc_md=docs, tags=tags
) as dag:

    acoustic__contact__v1 = bigquery_etl_query(
        task_id="acoustic__contact__v1",
        destination_table="contact_v1",
        dataset_id="acoustic",
        project_id="moz-fx-data-marketing-prod",
        owner="kignasiak@mozilla.com",
        email=["kignasiak@mozilla.com", "telemetry-alerts@mozilla.com"],
        date_partition_parameter="submission_date",
        depends_on_past=False,
        arguments=["--submission_date", "{{ ds }}"],
    )
