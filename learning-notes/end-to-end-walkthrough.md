# End-to-End Walkthrough

This project built an automated SCD Type 1 customer pipeline using Python, Amazon S3, Snowflake Snowpipe, Streams, Tasks, and Stored Procedures.

## Big Picture

The pipeline works like this:

```text
Local customer CSV files
→ Python upload script
→ S3 data/ folder
→ Snowflake external stage
→ Snowpipe
→ CUSTOMER_SOURCE table
→ CUSTOMER_STREAM
→ CUSTOMER_TASK
→ CUSTOMER_SP stored procedure
→ CUSTOMER target table
```

## Step 1: Local Customer Files

The project starts with two customer CSV files:

```text
customer_full_data.csv
customer_change_data.csv
```

The full file contains the original customer dataset.

The change file contains a mix of:

- updated records for existing customers
- new customer records not already in the target table

These files are stored locally and are not committed to the public repo.

## Step 2: Python Uploads Files to S3

A Python script uploads the CSV files to Amazon S3.

The script uses:

```text
boto3
AWS CLI profile: scd1-lab
```

The files are uploaded to:

```text
s3://scd1-customer-data-jenny/data/
```

This keeps AWS credentials out of the code and out of GitHub.

## Step 3: S3 Stores the Incoming Files

S3 acts as the file landing zone.

The full file and change file both land in the same `data/` prefix.

Snowflake reads from this folder through an external stage.

## Step 4: Snowflake Connects to S3

Snowflake connects to S3 using:

- AWS IAM role
- Snowflake storage integration
- Snowflake external stage

The external stage points to:

```text
s3://scd1-customer-data-jenny/data/
```

A successful `LS @SCD1_DB.PUBLIC.SCD1_STAGE;` command proves Snowflake can access the S3 location.

## Step 5: Snowpipe Loads the Source Table

Snowpipe is configured with auto-ingest.

When a new CSV file lands in S3, S3 event notifications trigger Snowpipe.

Snowpipe loads the CSV file into:

```text
SCD1_DB.PUBLIC.CUSTOMER_SOURCE
```

This means the user does not manually run a `COPY INTO` command every time a new file arrives.

## Step 6: Stream Tracks New Rows

A stream is created on the source table:

```text
SCD1_DB.PUBLIC.CUSTOMER_STREAM
```

The stream tracks newly inserted rows from `CUSTOMER_SOURCE`.

This allows the pipeline to process only new incoming data instead of repeatedly scanning the entire source table.

## Step 7: Stored Procedure Applies SCD1 Logic

The stored procedure is:

```text
SCD1_DB.PUBLIC.CUSTOMER_SP
```

The procedure:

1. Reads new rows from the stream.
2. Creates a temporary work table.
3. Merges rows into the target `CUSTOMER` table.

The merge logic uses:

```text
CONTACTFIRSTNAME + CONTACTLASTNAME
```

as the matching key.

If the customer already exists, the procedure updates the record.

If the customer does not exist, the procedure inserts a new record.

## Step 8: Task Automates the Stored Procedure

The task is:

```text
SCD1_DB.PUBLIC.CUSTOMER_TASK
```

The task runs every minute, but only calls the procedure when the stream has data.

The condition is:

```sql
WHEN SYSTEM$STREAM_HAS_DATA('SCD1_DB.PUBLIC.CUSTOMER_STREAM')
```

This makes the pipeline automated after files land in S3.

## Step 9: Full Load Validation

After uploading `customer_full_data.csv`, the target table reached:

```text
80 records
```

This proved the first file loaded successfully through Snowpipe, stream, task, stored procedure, and merge logic.

## Step 10: Change Load Validation

After uploading `customer_change_data.csv`, the target table reached:

```text
81 records
```

This proved:

- existing records were updated
- a new customer was inserted
- SCD Type 1 overwrite logic worked

Specific checks:

- Elizabeth Yu had an updated phone value.
- Kyung Benitez had an updated city value.
- John Wick was inserted as a new record.

## Final Result

The final `CUSTOMER` table stores the latest version of each customer record.

Because this is SCD Type 1, older values are overwritten and not retained.