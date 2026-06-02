# Service-by-Service Notes

This project uses Python, AWS S3, Snowflake Snowpipe, Streams, Tasks, and Stored Procedures.

Each component has a specific role in the pipeline.

## Python

Python uploads the local customer CSV files to S3.

The script uses `boto3` and the local AWS CLI profile `scd1-lab`.

Python is only responsible for file upload in this project.

## Amazon S3

S3 stores the incoming CSV files.

The project bucket is:

```text
scd1-customer-data-jenny
```

The files land under:

```text
data/
```

S3 acts as the cloud landing zone between the local machine and Snowflake.

## AWS IAM

IAM controls permissions.

This project uses IAM for two purposes:

1. A user/access key allows Python to upload files to S3.
2. A role allows Snowflake to read from the S3 bucket.

For a production setup, permissions should be restricted to the specific bucket and prefix.

## Snowflake Storage Integration

The storage integration allows Snowflake to securely access the S3 bucket.

It connects Snowflake to AWS through an IAM role and external ID.

## Snowflake External Stage

The external stage points Snowflake to the S3 folder.

In this project:

```text
SCD1_DB.PUBLIC.SCD1_STAGE
```

points to:

```text
s3://scd1-customer-data-jenny/data/
```

## Snowpipe

Snowpipe automatically loads new files from S3 into Snowflake.

In this project, Snowpipe loads files into:

```text
SCD1_DB.PUBLIC.CUSTOMER_SOURCE
```

Snowpipe is triggered by S3 event notifications.

## CUSTOMER_SOURCE Table

`CUSTOMER_SOURCE` is the landing/source table in Snowflake.

It receives rows from the full and change CSV files.

## Snowflake Stream

The stream tracks new rows inserted into `CUSTOMER_SOURCE`.

In this project:

```text
SCD1_DB.PUBLIC.CUSTOMER_STREAM
```

The stored procedure reads from this stream.

## Stored Procedure

The stored procedure contains the SCD Type 1 merge logic.

It reads stream rows and merges them into the `CUSTOMER` target table.

## Snowflake Task

The task automates the stored procedure.

It runs on a schedule and only executes when the stream has data.

## CUSTOMER Target Table

The `CUSTOMER` table stores the current customer dimension.

Because this is SCD Type 1:

- existing rows are overwritten with new values
- new rows are inserted
- old values are not retained