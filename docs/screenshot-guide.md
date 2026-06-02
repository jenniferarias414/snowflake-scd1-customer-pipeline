# Screenshot Guide

This project uses screenshots as validation evidence for the Snowflake SCD Type 1 pipeline.

The screenshots are organized into two folders:

```text
screenshots/full-walkthrough/
screenshots/selected-for-readme/
```

## Screenshot Folders

### `screenshots/full-walkthrough/`

Contains the full project build and validation trail.

### `screenshots/selected-for-readme/`

Contains the strongest screenshots for the main README or portfolio case study.

## Recommended Public Screenshots

| Screenshot | What it proves |
|---|---|
| `02-s3-bucket-data-folder-created.png` | S3 bucket and data prefix were created |
| `05-snowflake-stage-list-success-empty.png` | Snowflake stage successfully connected to S3 |
| `07-snowpipe-created-and-running.png` | Snowpipe was created and active |
| `10-customer-stream-created.png` | Stream was created on `CUSTOMER_SOURCE` |
| `12-customer-stored-procedure-created.png` | Stored procedure was created |
| `13-customer-task-started.png` | Task was resumed/started |
| `14-python-full-file-upload-success.png` | Python uploaded the full CSV to S3 |
| `16-customer-full-load-80-records.png` | Full load created 80 customer records |
| `20-customer-after-change-load-81-records.png` | Change load produced 81 customer records |
| `21-scd1-after-change-validation.png` | SCD1 updates and insert were validated |

## Privacy Review Before Publishing

Before using screenshots publicly, review and blur or crop:

- AWS account IDs
- full IAM role ARNs
- Snowflake account identifiers
- email addresses
- access keys or secret keys
- SQS notification channel ARNs if needed
- anything unrelated to the project

Do not publish screenshots that show access keys, secret keys, or credential files.

## Screenshot Strategy

This project intentionally keeps screenshots lean.

The goal is not to prove every click. The goal is to prove:

- resources were created
- files were uploaded
- Snowpipe loaded data
- streams/tasks/procedures worked
- SCD Type 1 logic updated and inserted records correctly