from dagster import asset, AssetExecutionContext
import datetime
from .ops import fetch_stations_data, fetch_weather_data, transform_weather_data, load_to_snowflake

@asset
def weather_stations():
    """Liste des stations météorologiques"""
    return fetch_stations_data()

@asset(deps=[weather_stations])
def raw_weather_data(context: AssetExecutionContext, weather_stations):
    """Données météorologiques brutes"""
    # Récupère les dates depuis la configuration
    start_date = context.op_config.get(
        "start_date",
        (datetime.datetime.now() - datetime.timedelta(days=30)).strftime("%Y-%m-%d")
    )
    end_date = context.op_config.get(
        "end_date", 
        datetime.datetime.now().strftime("%Y-%m-%d")
    )
    
    return fetch_weather_data(weather_stations, start_date, end_date)

@asset(deps=[raw_weather_data, weather_stations])
def transformed_weather_data(raw_weather_data, weather_stations):
    """Données météorologiques transformées"""
    return transform_weather_data(raw_weather_data, weather_stations)

@asset(deps=[transformed_weather_data])
def snowflake_weather_data(context, transformed_weather_data):
    """Données météorologiques chargées dans Snowflake"""
    load_to_snowflake(context, transformed_weather_data)
    return "Données chargées dans Snowflake"