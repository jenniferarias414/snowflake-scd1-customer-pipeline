# SCD Type 1 Notes

## What Is a Slowly Changing Dimension?

A slowly changing dimension is a dimension table where descriptive attributes can change over time.

Examples:

- a customer changes phone number
- a customer changes city
- an employee changes job title
- a product changes description

These changes do not usually happen as frequently as transaction records, but they still need to be handled correctly.

## What Is SCD Type 1?

SCD Type 1 means the old value is overwritten with the new value.

No history is kept.

The table only stores the latest/current version of the record.

## Simple Example

Original customer record:

```text
Customer: Elizabeth Yu
Phone: 555-1111
```

Updated customer record:

```text
Customer: Elizabeth Yu
Phone: 555-9999
```

After SCD Type 1 processing, the target table stores only:

```text
Customer: Elizabeth Yu
Phone: 555-9999
```

The old phone value is gone.

## Why Use SCD Type 1?

SCD Type 1 is useful when:

- only the current value matters
- historical changes are not needed
- reporting should show the latest known value
- the business does not want multiple versions of the same dimension record

## What This Project Uses as the Match Key

This project matches customers using:

```text
CONTACTFIRSTNAME + CONTACTLASTNAME
```

In a real production system, a stronger customer ID would usually be better.

## How the MERGE Works

The stored procedure uses a `MERGE` statement.

The merge logic means:

```text
If customer exists:
    update current values

If customer does not exist:
    insert new record
```

## What Was Validated

The project validated SCD Type 1 behavior by checking:

- Elizabeth Yu was updated
- Kyung Benitez was updated
- John Wick was inserted

The final customer count changed from:

```text
80
```

to:

```text
81
```

That means the change file updated existing rows and added one new row.