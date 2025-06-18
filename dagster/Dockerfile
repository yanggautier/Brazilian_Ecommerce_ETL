FROM python:3.10-slim

WORKDIR /opt/dagster/app

# Installer les dépendances
RUN pip install dagster \
                dagster-webserver \
                dagit \
                dagster-snowflake \
                dagster-dbt

# Configuration de l'environnement Dagster
ENV DAGSTER_HOME=/opt/dagster/app

# Copier les fichiers de configuration
COPY workspace.yaml .
COPY ecommerce_pipeline ./ecommerce_pipeline

# Exposer le port pour Dagit
EXPOSE 3000

# Commande par défaut
CMD ["dagit", "-h", "0.0.0.0", "-p", "3000"]