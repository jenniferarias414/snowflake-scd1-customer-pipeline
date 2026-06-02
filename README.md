# Snowflake SCD Type 1 Customer Pipeline

## Overview

This project demonstrates a guided Snowflake data engineering pipeline for handling **Slowly Changing Dimension Type 1** customer updates.

The pipeline uploads full-load and change-data customer CSV files to Amazon S3, automatically ingests the files into Snowflake using Snowpipe, tracks new rows with a Snowflake Stream, and uses a Snowflake Task to run a Stored Procedure that applies SCD Type 1 merge logic to a target `CUSTOMER` table.

This project was completed as part of my data engineering studies and organized into a portfolio-ready repo with SQL scripts, Python upload code, validation screenshots, and clear documentation.

## Architecture

```text
Local CSV files
→ Python upload script
→ Amazon S3 data/ folder
→ Snowflake external stage
→ Snowpipe
→ CUSTOMER_SOURCE table
→ CUSTOMER_STREAM
→ CUSTOMER_TASK
→ CUSTOMER_SP stored procedure
→ CUSTOMER target table
```

## What This Project Demonstrates

- Uploading local CSV files to S3 with Python and boto3
- Using AWS IAM credentials through a local AWS CLI profile
- Creating an S3 bucket and `data/` prefix for customer files
- Connecting Snowflake to S3 with a storage integration and external stage
- Creating Snowpipe for automated file ingestion
- Creating a Snowflake Stream to capture newly loaded rows
- Creating a Snowflake Stored Procedure with SCD Type 1 merge logic
- Creating a Snowflake Task to automatically run the procedure when stream data exists
- Validating full-load and change-data behavior
- Confirming SCD Type 1 updates overwrite old values and insert new records

## Tech Stack

- Snowflake
- Snowpipe
- Snowflake Streams
- Snowflake Tasks
- Snowflake Stored Procedures
- Amazon S3
- AWS IAM
- Python
- boto3
- SQL
- GitHub

## What Is SCD Type 1?

Slowly Changing Dimension Type 1 is a data warehousing pattern where changed dimension records are overwritten with the newest values.

SCD Type 1 does not preserve history.

Example:

```text
Original email:
john@example.com

Updated email:
john.new@example.com
```

After the update, the target table stores only:

```text
john.new@example.com
```

The old value is replaced.

## Data Files

This guided lab uses two customer CSV files:

```text
customer_full_data.csv
customer_change_data.csv
```

The full file loads the initial customer dataset.

The change file contains:

- updated records for existing customers
- new customer records that do not already exist in the target table

The CSV files are treated as course-provided/local data and are not committed to the public repo.

## Repository Structure

```text
.
├── architecture/
│   └── architecture-overview.md
├── data/
│   └── README.md
├── docs/
│   ├── project-status.md
│   ├── screenshot-guide.md
│   ├── source-material-handling.md
│   └── troubleshooting.md
├── learning-notes/
│   ├── README.md
│   ├── end-to-end-walkthrough.md
│   ├── how-to-explain-this-project.md
│   ├── scd1-notes.md
│   └── service-by-service-notes.md
├── python/
│   ├── upload_customer_files_to_s3.py
│   └── README.md
├── screenshots/
│   ├── full-walkthrough/
│   ├── selected-for-readme/
│   └── README.md
├── snowflake/
│   ├── 01_database_setup.sql
│   ├── 02_storage_integration_stage.sql
│   ├── 03_snowpipe_setup.sql
│   ├── 04_stream_setup.sql
│   ├── 05_stored_procedure_scd1.sql
│   ├── 06_task_setup.sql
│   ├── 07_testing_scd1_logic.sql
│   └── README.md
├── .gitignore
├── LICENSE
├── README.md
└── requirements.txt
```

## Pipeline Steps

### 1. Local CSV Files

The project starts with two local customer CSV files:

```text
customer_full_data.csv
customer_change_data.csv
```

These files represent the full customer load and later customer changes.

### 2. Python Upload to S3

A Python script uploads the CSV files into the S3 bucket:

```text
s3://scd1-customer-data-jenny/data/
```

The script uses a local AWS CLI profile named:

```text
scd1-lab
```

Credentials are not hardcoded in the script.

### 3. Snowflake Storage Integration and Stage

Snowflake connects to S3 through:

- AWS IAM role
- Snowflake storage integration
- Snowflake external stage

The external stage points Snowflake to the S3 `data/` folder.

### 4. Snowpipe Loads the Source Table

Snowpipe is configured with `AUTO_INGEST = TRUE`.

When CSV files are uploaded to S3, S3 event notifications trigger Snowpipe to load the file into:

```text
SCD1_DB.PUBLIC.CUSTOMER_SOURCE
```

### 5. Stream Tracks New Source Rows

A Snowflake Stream is created on `CUSTOMER_SOURCE`:

```text
SCD1_DB.PUBLIC.CUSTOMER_STREAM
```

The stream tracks new rows loaded into the source table.

### 6. Stored Procedure Applies SCD1 Logic

A JavaScript stored procedure reads rows from the stream and merges them into the target table:

```text
SCD1_DB.PUBLIC.CUSTOMER
```

The merge logic uses:

```text
CONTACTFIRSTNAME + CONTACTLASTNAME
```

as the matching key.

If the customer exists, the row is updated.

If the customer does not exist, a new row is inserted.

### 7. Task Automates the Procedure

A Snowflake Task runs every minute and calls the stored procedure only when the stream has data:

```sql
WHEN SYSTEM$STREAM_HAS_DATA('SCD1_DB.PUBLIC.CUSTOMER_STREAM')
```

This automates the merge process after Snowpipe loads new data.

## Validation

The project was validated in two stages.

### Full Load Validation

The full customer CSV file was uploaded to S3 and loaded into Snowflake.

Expected result:

```text
CUSTOMER table count = 80
```

### SCD1 Change Validation

The change CSV file was uploaded to S3.

Expected result:

```text
CUSTOMER table count = 81
```

This confirmed:

- existing customer records were updated
- one new customer record was inserted
- SCD Type 1 overwrite logic worked as expected

Specific validation checks included:

- Elizabeth Yu had an updated phone value
- Kyung Benitez had an updated city value
- John Wick was inserted as a new customer

## Selected Validation Screenshots

| Step | Screenshot |
|---|---|
| S3 bucket and data folder created | `screenshots/selected-for-readme/02-s3-bucket-data-folder-created.png` |
| Snowflake stage validation succeeded | `screenshots/selected-for-readme/05-snowflake-stage-list-success-empty.png` |
| Snowpipe created and running | `screenshots/selected-for-readme/07-snowpipe-created-and-running.png` |
| Customer stream created | `screenshots/selected-for-readme/10-customer-stream-created.png` |
| Stored procedure created | `screenshots/selected-for-readme/12-customer-stored-procedure-created.png` |
| Task started | `screenshots/selected-for-readme/13-customer-task-started.png` |
| Full file uploaded with Python | `screenshots/selected-for-readme/14-python-full-file-upload-success.png` |
| Full load reached 80 records | `screenshots/selected-for-readme/16-customer-full-load-80-records.png` |
| Change load reached 81 records | `screenshots/selected-for-readme/20-customer-after-change-load-81-records.png` |
| SCD1 updates validated | `screenshots/selected-for-readme/21-scd1-after-change-validation.png` |

## Notes About Scope

This is a guided learning project and not a production deployment.

For a production implementation, improvements would include:

- least-privilege IAM policies
- secure secret management
- infrastructure as code
- stronger source file validation
- error handling for rejected files
- monitoring and alerting
- task failure notifications
- better primary key strategy
- historical tracking if SCD Type 2 behavior is required

## Project Status

Completed:

- AWS IAM setup
- S3 bucket and data folder
- Python S3 upload script
- Snowflake storage integration and stage
- Snowpipe auto-ingest setup
- S3 event notification for Snowpipe
- Snowflake stream
- Customer target table
- Stored procedure with SCD Type 1 merge logic
- Snowflake task
- Full load validation
- Change load validation
- SCD Type 1 update/insert validation