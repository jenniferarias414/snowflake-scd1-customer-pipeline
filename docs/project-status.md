# Project Status

## Status

Completed.

This guided data engineering project was built and validated end-to-end using Python, Amazon S3, Snowflake Snowpipe, Streams, Tasks, and Stored Procedures.

## Completed Work

### AWS

- Created IAM user for Python-to-S3 upload testing
- Created S3 bucket for customer data files
- Created `data/` prefix for incoming CSV files
- Configured S3 event notification for Snowpipe auto-ingest

### Python

- Created local Python upload script using `boto3`
- Configured script to use local AWS CLI profile `scd1-lab`
- Uploaded `customer_full_data.csv` to S3
- Uploaded `customer_change_data.csv` to S3

### Snowflake

- Created `SCD1_DB` database
- Created `CUSTOMER_SOURCE` source table
- Created `CUSTOMER` target table
- Created Snowflake storage integration
- Created external stage pointing to the S3 `data/` prefix
- Created Snowpipe with auto-ingest
- Created stream on the source table
- Created stored procedure with SCD Type 1 merge logic
- Created task to run the stored procedure when stream data exists

## Final Data Flow

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

## Validation Evidence

Key validation screenshots include:

- S3 bucket and data folder created
- Snowflake stage validated successfully
- Snowpipe created and running
- Customer stream created
- Stored procedure created
- Task started
- Full CSV uploaded to S3
- Full load produced 80 customer records
- Change CSV uploaded to S3
- Change load produced 81 customer records
- SCD Type 1 update/insert logic validated

## Final Validation Results

Expected results were confirmed:

```text
Full load customer count: 80
After change load customer count: 81
```

SCD Type 1 validation confirmed:

- Elizabeth Yu was updated
- Kyung Benitez was updated
- John Wick was inserted