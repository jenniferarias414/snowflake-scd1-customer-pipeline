# Troubleshooting Notes

This document captures issues and checks for the Snowflake SCD Type 1 customer pipeline.

## Python Could Not Import boto3

### Issue

The upload script failed with:

```text
ModuleNotFoundError: No module named 'boto3'
```

### Cause

The local Python environment did not have `boto3` installed.

### Resolution

Created a virtual environment and installed dependencies:

```bash
python3 -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip
python -m pip install boto3
pip freeze > requirements.txt
```

## Virtual Environment Creation Was Interrupted

### Issue

The `.venv` folder was partially created, and activation failed.

### Resolution

Removed the incomplete environment and recreated it:

```bash
rm -rf .venv
python3 -m venv .venv
source .venv/bin/activate
```

## Snowflake Stage Returned No Results

### Issue

Running:

```sql
LS @SCD1_DB.PUBLIC.SCD1_STAGE;
```

returned no rows.

### Cause

The S3 `data/` prefix was empty at that time.

### Resolution

No action was needed. No results are expected before CSV files are uploaded. The important validation is that the command runs without a permission error.

## Snowpipe Does Not Load Immediately

### Issue

After uploading a CSV file, the Snowflake table may not update instantly.

### Cause

Snowpipe and the task can take a short amount of time to process the new file and downstream stream data.

### Resolution

Wait 1–2 minutes, then rerun the count query:

```sql
SELECT COUNT(*) AS CUSTOMER_COUNT
FROM SCD1_DB.PUBLIC.CUSTOMER;
```

## Useful Snowpipe Checks

Check pipe status:

```sql
SELECT SYSTEM$PIPE_STATUS('SCD1_DB.PUBLIC.SCD1PIPE');
```

Show pipe metadata:

```sql
SHOW PIPES;
```

Check source table:

```sql
SELECT COUNT(*) AS CUSTOMER_SOURCE_COUNT
FROM SCD1_DB.PUBLIC.CUSTOMER_SOURCE;
```

## Useful Stream Checks

Check stream data:

```sql
SELECT *
FROM SCD1_DB.PUBLIC.CUSTOMER_STREAM;
```

Show stream metadata:

```sql
SHOW STREAMS IN SCHEMA SCD1_DB.PUBLIC;
```

## Useful Task Checks

Show task status:

```sql
SHOW TASKS LIKE 'CUSTOMER_TASK' IN SCHEMA SCD1_DB.PUBLIC;
```

Resume task:

```sql
ALTER TASK SCD1_DB.PUBLIC.CUSTOMER_TASK RESUME;
```

Suspend task after testing:

```sql
ALTER TASK SCD1_DB.PUBLIC.CUSTOMER_TASK SUSPEND;
```

## Important Testing Note

Do not repeatedly upload the same file unless intentionally retesting.

Repeated uploads can create duplicate rows in the source table depending on Snowpipe load history and file names.