# Python Upload Script

This folder contains the Python script used to upload customer CSV files to Amazon S3.

## Script

```text
upload_customer_files_to_s3.py
```

## Purpose

The script uploads local customer CSV files into the S3 folder monitored by Snowpipe.

The target S3 location is:

```text
s3://scd1-customer-data-jenny/data/
```

## Files Uploaded

The project uses two local CSV files:

```text
customer_full_data.csv
customer_change_data.csv
```

The full file is uploaded first to create the initial customer target table load.

The change file is uploaded second to test SCD Type 1 update and insert behavior.

## Credential Handling

AWS credentials are not hardcoded in the script.

The script uses a local AWS CLI profile:

```text
scd1-lab
```

The profile is configured locally with:

```bash
aws configure --profile scd1-lab
```

This keeps credentials out of the public repo.

## Run Instructions

From the project root, activate the virtual environment:

```bash
source .venv/bin/activate
```

Upload the full customer file:

```bash
python python/upload_customer_files_to_s3.py data/local/customer_full_data.csv
```

Upload the change-data file:

```bash
python python/upload_customer_files_to_s3.py data/local/customer_change_data.csv
```

## Expected Output

Example successful output:

```text
customer_full_data.csv uploaded successfully
s3://scd1-customer-data-jenny/data/customer_full_data.csv
```

## Notes

The CSV files are stored locally under:

```text
data/local/
```

They are intentionally excluded from GitHub because they are course-provided local data files.