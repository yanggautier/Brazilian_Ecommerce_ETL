#!/bin/bash

# Configurations
# Folder of the files in GCS
FILE_FOLDER_PATH="gs://brazilian-ecommerce-dbt-project"
RAW_PATH="raw"
PROCESSED_PATH="processed"
# Get list of files in raw folder
RAW_FILES=$(gsutil ls "${FILE_FOLDER_PATH}/${RAW_PATH}/*.csv" 2>/dev/null)
SQL_INSTANCE="my-sql-instance"
DATABASE="brazilian_ecommerce"

# Check if files exist
if [ -z "$RAW_FILES" ]; then
    echo "No CSV files found in ${FILE_FOLDER_PATH}/raw/"
    exit 1
fi

# Process each file
for full_file_path in $RAW_FILES
do
    file=$(basename "$full_file_path")
    echo "Processing file: $file"
    
    # Download the file from GCS
    if gsutil cp "$full_file_path" .; then
        echo "Downloaded: $file"
    else
        echo "Error downloading: $file"
        continue
    fi
    
    # Check if file exists locally
    if [ ! -f "$file" ]; then
        echo "File not found locally: $file"
        continue
    fi
    
    # Remove the header line from the CSV file
    if sed -i '1d' "$file"; then
        echo "Removed header from: $file"
    else
        echo "Error processing: $file"
        rm -f "$file"
        continue
    fi


    # Remove the first colon (:) from the header line
    if sed -i 's/:\\//g' "$file"; then
        echo "Removed header from: $file"
    else
        echo "Error processing: $file"
        rm -f "$file"
        continue
    fi
    
    # Upload the modified file back to GCS processed folder
    if gsutil cp "$file" "${FILE_FOLDER_PATH}/${PROCESSED_PATH}/${file}"; then
        echo "Uploaded processed file: $file"
    else
        echo "Error uploading: $file"
    fi
    
    # Clean up local file
    rm -f "$file"
    echo "Cleaned up local file: $file"
    echo "---"
done

# Final cleanup - remove any remaining local files
echo "Final cleanup..."
for cleanup_file in *.csv; do
    if [ -f "$cleanup_file" ]; then
        rm -f "$cleanup_file"
        echo "Removed remaining file: $cleanup_file"
    fi
done

echo "Remove csv complete!"


# Associative array pour mapper fichiers -> tables
declare -A file_table_map=(
    ["olist_customers_dataset.csv"]="customers"
    ["olist_geolocation_dataset.csv"]="geolocation"
    ["olist_order_items_dataset.csv"]="order_items"
    ["olist_order_payments_dataset.csv"]="payments"
    ["olist_order_reviews_dataset.csv"]="reviews"
    ["olist_orders_dataset.csv"]="orders"
    ["olist_products_dataset.csv"]="products"
    ["olist_sellers_dataset.csv"]="sellers"
    ["product_category_name_translation.csv"]="product_category_name_translation"
)

# Function to import a file to Cloud SQL
import_csv_to_sql() {
    local file_path="$1"
    local table_name="$2"
    local file_name="$3"
    
    echo "Importing $file_name to Cloud SQL table: $table_name..."
    
    if gcloud sql import csv "$SQL_INSTANCE" "$file_path" \
        --database="$DATABASE" \
        --table="$table_name" \
        --quote="22" \
        --escape="5C" \
        --fields-terminated-by="2C" \
        --quiet; then
        echo "✓ Successfully imported $file_name"
        return 0
    else
        echo "✗ Failed to import $file_name"
        return 1
    fi
}

# counter
total_files=0
imported_files=0
failed_files=0
skipped_files=0


# Import processed CSV to Cloud SQL
for file in $(gsutil ls "${FILE_FOLDER_PATH}/${PROCESSED_PATH}/*.csv" 2>/dev/null); do
    file_name=$(basename "$file")
    ((total_files++))
    
    echo "Processing: $file_name"
    
    # Vérifier si le fichier a une table correspondante
    if [[ -n "${file_table_map[$file_name]}" ]]; then
        table_name="${file_table_map[$file_name]}"
        
        if import_csv_to_sql "$file" "$table_name" "$file_name"; then
            ((imported_files++))
        else
            ((failed_files++))
        fi
    else
        echo "⚠ No matching table for $file_name - skipping"
        ((skipped_files++))
    fi
    
    echo "---"
done

# Statistiques finales
echo "=== Import Summary ==="
echo "Total files processed: $total_files"
echo "Successfully imported: $imported_files"
echo "Failed imports: $failed_files"
echo "Skipped files: $skipped_files"

if [ $failed_files -gt 0 ]; then
    echo "⚠ Warning: Some imports failed. Check the logs above."
    exit 1
elif [ $imported_files -eq 0 ]; then
    echo "⚠ No files were imported. Check your file paths and permissions."
    exit 1
else
    echo "✓ All imports completed successfully!"
fi