# Projet Data Engineering : Analyse des Données Brazilian Ecommerce


## Description du projet
visualisation BI, le tout dans un environnement Docker Compose.

## Data source


Source files: https://www.kaggle.com/datasets/burayamail/brazilian-ecommerce-analyses-v2/data

## Architecture du système
Collecte (Dagster)  ----> Snowflake (Stockage)  ---->  dbt (Transform) ----> Superset (BI/Viz) 


## Source configurations

1. Create a new bucket, then a folder for raw data, a folder for processed folder and for scrips.
2. Put all csv file that we just download in this bucket
3. Update the script `import_csv_tocloud.sh` which in the `./scripts` folde, then put it into the script folder in your bucket
4. Open Cloud Shell and use gsutil command to download the script to the vm `gsutil cp gs://BUCKET_FOLDER/SCRIPT_FOLDER/import_csv_to_cloudsql.sh ./import_csv_to_cloudsql.sh`
5. Grant execution permission to th script file `chmod + x import_csv_to_cloudsql.sh`
6. Go to Cloud SQL PostgreSQL, create an instance and a database for the projet in the Cloud SQL instance
7. Open Cloud SQL Studio page and create tables in the database (SQL in the `./scripts` folder, I've removed all foreign keys and some primary keys due to duplicated keys or other problems)
8. Grant `Storage Object Viewer` of the bucket to your Cloud SQL service principal/
9. Execute the script `import_csv_tocloud.sh` to remove headers of csv files to Cloud SQL

**Note**: If you don't want use a cloud based sql server for the source you can place csv files n the `seed`folder then use `dbt seed` command to populate tables

## Output configurations 
1. Create or use an existing account Snowflake
2. Create an Warehouse 
3. Create a database for this project
4. Update the section Snowflake in `.env` file (get account-indenfitifer in Account -> View account details )

