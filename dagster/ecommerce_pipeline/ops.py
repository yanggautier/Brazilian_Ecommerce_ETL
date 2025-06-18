import subprocess
from dagster import op


@op
def run_dbt_run_command():
    """Exécute une commande dbt dans le conteneur dbt"""
    command = [
        "docker-compose", "exec", 
        "dbt",  # dbt container name
        "dbt",   # dbt command
        "run"    # dbt subcommand
    ] 
    
    result = subprocess.run(command, capture_output=True, text=True)
    
    if result.returncode != 0:
        raise Exception(f"dbt command failed: {result.stderr}")
    
    return result.stdout

@op
def run_dbt_test_command():
    """Exécute une commande dbt test dans le conteneur dbt"""
    command = [
        "docker-compose", "exec", 
        "dbt",  # dbt container name
        "dbt",   # dbt command
        "test"   # dbt subcommand
    ] 
    
    result = subprocess.run(command, capture_output=True, text=True)
    
    if result.returncode != 0:
        raise Exception(f"dbt command failed: {result.stderr}")
    
    return result.stdout