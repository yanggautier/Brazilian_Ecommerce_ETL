from dagster import job
from .ops import run_dbt_run_command, run_dbt_test_command

@job
def ecommerce_pipeline():
    run_dbt_run_command.alias("dbt_run")
    run_dbt_test_command.alias("dbt_test")