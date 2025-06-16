from dagster import Definitions, load_assets_from_modules, define_asset_job
from .resources import snowflake_resource
from . import assets

# Charge automatiquement tous les assets depuis le module assets
all_assets = load_assets_from_modules([assets])

# Définit un job qui exécute tous les assets
weather_asset_job = define_asset_job(name="weather_asset_job")

defs = Definitions(
    assets=all_assets,
    resources={
        "snowflake": snowflake_resource,
    },
    jobs=[weather_asset_job], 
)