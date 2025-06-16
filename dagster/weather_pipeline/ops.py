import os
import requests
import pandas as pd
from dagster import op
import datetime


@op
def fetch_stations_data():
    """Récupère la liste des stations météorologiques"""
    api_key = os.getenv("NOAA_API_KEY")
    url = "https://www.ncdc.noaa.gov/cdo-web/api/v2/stations"
    
    headers = {
        "token": api_key
    }
    
    params = {
        "limit": 1000,
        "datatypeid": "TMAX,TMIN,PRCP"
    }
    
    response = requests.get(url, headers=headers, params=params)
    data = response.json()
    
    stations_df = pd.DataFrame(data["results"])
    return stations_df

@op
def fetch_weather_data(stations_df):
    """Récupère les données météorologiques pour les stations spécifiées"""
    api_key = os.getenv("NOAA_API_KEY")
    url = "https://www.ncdc.noaa.gov/cdo-web/api/v2/data"
    
    headers = {
        "token": api_key
    }
    
    all_data = []

    end_date = datetime.datetime.now().strftime("%Y-%m-%d")
    start_date = (datetime.datetime.now() - datetime.timedelta(days=30)).strftime("%Y-%m-%d")
    
    
    # Pour chaque station, récupérer les données
    for station_id in stations_df["id"].head(10):  # Limiter à 10 stations pour l'exemple
        params = {
            "datasetid": "GHCND",
            "stationid": station_id,
            "startdate": start_date,
            "enddate": end_date,
            "limit": 1000,
            "datatypeid": "TMAX,TMIN,PRCP",
            "units": "metric"
        }
        
        response = requests.get(url, headers=headers, params=params)
        if response.status_code == 200 and "results" in response.json():
            station_data = pd.DataFrame(response.json()["results"])
            all_data.append(station_data)
    
    if all_data:
        weather_df = pd.concat(all_data, ignore_index=True)
        return weather_df
    else:
        return pd.DataFrame()

@op
def transform_weather_data(weather_df, stations_df):
    """Transforme les données météorologiques brutes"""
    if weather_df.empty:
        return pd.DataFrame()
    
    # Fusionner avec les informations des stations
    stations_minimal = stations_df[["id", "name", "latitude", "longitude"]]
    merged_df = weather_df.merge(stations_minimal, left_on="station", right_on="id", how="left")
    
    # Pivoter les données pour avoir une colonne pour chaque type de mesure
    pivot_df = merged_df.pivot_table(
        index=["station", "name", "latitude", "longitude", "date"],
        columns="datatype",
        values="value"
    ).reset_index()
    
    # Renommer les colonnes
    pivot_df.columns.name = None
    
    return pivot_df

@op(required_resource_keys={"snowflake"})
def load_to_snowflake(context, transformed_data):
    """Charge les données transformées dans Snowflake"""
    if transformed_data.empty:
        context.log.warning("Aucune donnée à charger dans Snowflake")
        return
    
    # Créer la table si elle n'existe pas
    context.resources.snowflake.execute_query("""
    CREATE TABLE IF NOT EXISTS WEATHER_DATA (
        station_id VARCHAR(20),
        station_name VARCHAR(100),
        latitude FLOAT,
        longitude FLOAT,
        date DATE,
        tmax FLOAT,
        tmin FLOAT,
        prcp FLOAT
    )
    """)
    
    # Charger les données
    # Note: Dans un vrai projet, utiliser COPY ou Snowpipe serait plus efficace
    for _, row in transformed_data.iterrows():
        query = f"""
        INSERT INTO WEATHER_DATA (station_id, station_name, latitude, longitude, date, tmax, tmin, prcp)
        VALUES (
            '{row['station']}',
            '{row['name'].replace("'", "''")}',
            {row['latitude']},
            {row['longitude']},
            '{row['date']}',
            {row.get('TMAX', 'NULL')},
            {row.get('TMIN', 'NULL')},
            {row.get('PRCP', 'NULL')}
        )
        """
        context.resources.snowflake.execute_query(query)
    
    context.log.info(f"Chargé {len(transformed_data)} lignes dans Snowflake")