#!/bin/bash

# Initialize the database
superset db upgrade

# Create an admin user (change credentials as needed)
superset fab create-admin \
    --username admin \
    --firstname Admin \
    --lastname User \
    --email admin@example.com \
    --password admin

# Load examples (optional)
superset load_examples

# Initialize (deprecated in newer versions)
superset init

# Start the server
superset run -p 8088 --with-threads --reload --debugger --host=0.0.0.0