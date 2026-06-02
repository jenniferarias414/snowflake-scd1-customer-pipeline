# How to Explain This Project

## Short Version

This project is an automated Snowflake SCD Type 1 customer pipeline.

A Python script uploads full-load and change-data CSV files to S3. Snowpipe automatically loads the files into a Snowflake source table. A stream tracks newly loaded rows, and a task runs a stored procedure that merges the changes into a customer target table using SCD Type 1 logic.

## Slightly More Detailed Version

I built a guided data engineering pipeline that demonstrates how Snowflake can automate file ingestion and current-state customer updates.

The source files are uploaded to S3 with Python. Snowflake reads the S3 folder through an external stage. Snowpipe automatically loads new files into a source table. A stream captures new rows, and a scheduled task calls a stored procedure. The stored procedure uses a merge statement to update existing customer records or insert new customers.

The SCD Type 1 behavior means old customer values are overwritten with the newest values.

## Technical Walkthrough

The project starts with two customer CSV files: a full data file and a change data file.

Python uploads those files to S3.

Snowflake uses a storage integration and external stage to access the S3 location.

Snowpipe automatically loads files from S3 into `CUSTOMER_SOURCE`.

A stream tracks new source rows.

A task checks whether the stream has data. If it does, the task calls the stored procedure.

The stored procedure applies SCD Type 1 merge logic into the `CUSTOMER` target table.

The final validation confirmed that the full file loaded 80 records and the change file updated existing records while inserting one new customer, resulting in 81 records.

## What This Shows

This project demonstrates:

- Python-to-S3 file upload
- Snowflake external stages
- Snowpipe auto-ingest
- Snowflake streams
- Snowflake tasks
- JavaScript stored procedures in Snowflake
- SQL MERGE logic
- SCD Type 1 current-state dimension handling
- end-to-end validation with row counts and sample records

## Key Talking Points

The most important part of the project is the automation chain:

```text
File lands in S3
→ Snowpipe loads the file
→ Stream tracks the new rows
→ Task runs the stored procedure
→ Stored procedure merges into CUSTOMER
```

This shows how Snowflake can automate incremental processing after a file arrives.

## One-Sentence Summary

Built a guided Snowflake SCD Type 1 pipeline that uploads customer CSV files to S3, auto-ingests them with Snowpipe, tracks changes with Streams, and merges updates into a current-state customer table using a Task and Stored Procedure.