# Snowflake Setup

This folder contains the Snowflake SQL scripts for the SCD Type 1 customer pipeline.

## Purpose

Snowflake handles the automated ingestion and transformation workflow for this project.

The pipeline uses:

- Snowflake storage integration
- external stage
- Snowpipe
- source table
- stream
- stored procedure
- task
- target customer table

## SQL Files

### `01_database_setup.sql`

Creates:

```text
SCD1_DB
CUSTOMER_SOURCE
CUSTOMER
```

`CUSTOMER_SOURCE` stores raw rows loaded from CSV files.

`CUSTOMER` stores the current version of each customer record after SCD Type 1 processing.

### `02_storage_integration_stage.sql`

Creates:

```text
SCD1_INT
SCD1_STAGE
```

The storage integration allows Snowflake to securely access S3.

The external stage points to:

```text
s3://scd1-customer-data-jenny/data/
```

### `03_snowpipe_setup.sql`

Creates:

```text
SCD1PIPE
```

Snowpipe automatically loads CSV files from the external stage into `CUSTOMER_SOURCE`.

The pipe uses:

```text
AUTO_INGEST = TRUE
```

S3 event notifications trigger the pipe when new files land in the S3 `data/` prefix.

### `04_stream_setup.sql`

Creates:

```text
CUSTOMER_STREAM
```

The stream tracks new rows inserted into `CUSTOMER_SOURCE`.

### `05_stored_procedure_scd1.sql`

Creates:

```text
CUSTOMER_SP
```

The stored procedure reads from the stream and merges new or changed rows into the `CUSTOMER` target table.

The merge logic implements SCD Type 1 behavior:

- matching customer records are updated
- new customer records are inserted
- old values are overwritten
- no history is retained

### `06_task_setup.sql`

Creates:

```text
CUSTOMER_TASK
```

The task runs every minute and calls the stored procedure when the stream has data.

### `07_testing_scd1_logic.sql`

Contains validation queries for:

- full-load row count
- before-change customer values
- after-change row count
- updated customer values
- inserted customer records

## SCD Type 1 Merge Logic

The target table uses this matching key:

```text
CONTACTFIRSTNAME + CONTACTLASTNAME
```

If a matching customer exists, values such as phone, address, and city are overwritten.

If a matching customer does not exist, a new customer row is inserted.

## Final Validation

Expected results:

```text
After full load: CUSTOMER count = 80
After change load: CUSTOMER count = 81
```

The final validation confirms:

- Elizabeth Yu was updated
- Kyung Benitez was updated
- John Wick was inserted