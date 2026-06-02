# Source Material Handling

This project was completed as a guided data engineering lab and organized into a portfolio-ready GitHub repository.

## Public Repo Content

The public repo includes:

- project overview
- architecture explanation
- Python upload script
- Snowflake SQL scripts
- validation screenshots
- troubleshooting notes
- learning notes written for a technical/business audience

## Private / Excluded Content

The following content should not be committed:

- raw course instructions
- copied course material
- downloaded customer CSV files
- access key CSV files
- personal notes
- credentials
- AWS account IDs
- secret keys
- Snowflake passwords
- unblurred screenshots with sensitive details

## Local Data Files

The project uses two course-provided CSV files:

```text
customer_full_data.csv
customer_change_data.csv
```

These files are stored locally under:

```text
data/local/
```

They are intentionally excluded from GitHub through `.gitignore`.

## Credential Handling

The Python script does not hardcode AWS credentials.

Instead, it uses a local AWS CLI profile:

```text
scd1-lab
```

This keeps access keys out of the repo.

## Guided Project Disclosure

This project is described as a guided learning project because the overall lab scenario came from data engineering coursework.

The public repo expands the work with:

- clean SQL organization
- safer Python script structure
- validation screenshots
- architecture documentation
- troubleshooting notes
- learning notes
- portfolio-ready formatting