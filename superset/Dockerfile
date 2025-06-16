FROM apache/superset:latest

USER root

# Installer les dépendances pour Snowflake
RUN pip install snowflake-sqlalchemy pillow

# Créer un répertoire pour les scripts d'initialisation
RUN mkdir -p /app/docker

# Copier le script d'initialisation
COPY ./docker-init.sh /app/docker/docker-init.sh
RUN chmod +x /app/docker/docker-init.sh

USER superset

ENTRYPOINT [ "/app/docker/docker-init.sh" ]