import pandas as pd
import csv
import argparse


def standardize_column_names(input_path, output_path):
    """
    Standardizes the column names of the DataFrame.
    """

    try:
        df = pd.read_csv(input_path)

        if 'review_creation_date' in df.columns:
            df['review_creation_date'] = pd.to_datetime(df['review_creation_date'])
        if 'review_answer_timestamp' in df.columns:
            df['review_answer_timestamp'] = pd.to_datetime(df['review_answer_timestamp'])


        # Write the csv file in standardized format
        df.to_csv(
            output_path,
            index=False,              
            encoding='utf-8',         
            sep=',',              
            quotechar='"',          
            doublequote=True,       
            quoting=csv.QUOTE_MINIMAL,
                            
            date_format='%Y-%m-%d %H:%M:%S'
        )

        print(f"Creation of file with Success: {output_path}")

    except Exception as e:
        print(f"One error was produced when write : {e}")


if __name__ == "__main__":

    # Argument parser for command line arguments
    args = argparse.ArgumentParser(description="Standardize CSV file column names")
    args.add_argument(
        "--input_path",
        type=str,
        help="Path to the input CSV file"
    )
    args.add_argument(
        "--output_path",
        type=str,
        help="Path to the output CSV file"
    )

    args = args.parse_args()
    input_path = args.input_path
    output_path = args.output_path
    standardize_column_names("olist_order_reviews_dataset", "olist_order_reviews_dataset")
    print("Standardization completed successfully.")