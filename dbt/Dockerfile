FROM python:3.10-slim

WORKDIR /dbt

RUN pip install dbt-core dbt-snowflake dbt-postgres

COPY . .

# Par défaut, ne fait rien quand le conteneur démarre
CMD ["tail", "-f", "/dev/null"]