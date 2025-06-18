#!/bin/bash
set -e


echo "✅ DB prête, initialisation de Superset..."

pip install --no-cache snowflake-sqlalchemy  trino sqlalchemy-redshift pillow

superset db upgrade

superset fab create-admin \
  --username "${SUPERSET_ADMIN_USERNAME}" \
  --firstname "${SUPERSET_ADMIN_FIRSTNAME}" \
  --lastname "${SUPERSET_ADMIN_LASTNAME}" \
  --email "${SUPERSET_ADMIN_EMAIL}" \
  --password "${SUPERSET_ADMIN_PASSWORD}" || true

superset init

superset run -h 0.0.0.0 -p 8088
