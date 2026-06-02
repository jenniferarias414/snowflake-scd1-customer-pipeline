# Learning Notes

These notes explain the Snowflake SCD Type 1 customer pipeline in a slower, more approachable way than the main README.

The main README is the quick project overview. This folder explains how the pipeline works, why each service is used, and how the SCD Type 1 logic is applied.

## Notes Included

- `end-to-end-walkthrough.md` explains the full project flow from local CSV files to the final customer target table.
- `service-by-service-notes.md` explains the role of each tool and Snowflake feature.
- `scd1-notes.md` explains Slowly Changing Dimension Type 1 in plain language.
- `how-to-explain-this-project.md` gives a concise project explanation.

## Project Flow

```text
Local CSV files
→ Python upload script
→ Amazon S3
→ Snowflake external stage
→ Snowpipe
→ CUSTOMER_SOURCE
→ CUSTOMER_STREAM
→ CUSTOMER_TASK
→ CUSTOMER_SP stored procedure
→ CUSTOMER target table
```

## Main Concept

This project demonstrates how Snowflake can automate a file-based customer dimension pipeline.

The full file creates the initial customer target table. The change file updates existing customers and inserts new customers using SCD Type 1 logic.