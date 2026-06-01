USE ROLE ACCOUNTADMIN;
USE WAREHOUSE COMPUTE_WH;
USE DATABASE SCD1_DB;
USE SCHEMA PUBLIC;

CREATE OR REPLACE PROCEDURE SCD1_DB.PUBLIC.CUSTOMER_SP()
RETURNS VARCHAR(100)
LANGUAGE JAVASCRIPT
EXECUTE AS CALLER
AS
$$
try {
    snowflake.execute({sqlText: `BEGIN TRANSACTION;`});

    snowflake.execute({sqlText: `
        CREATE OR REPLACE TEMPORARY TABLE SCD1_DB.PUBLIC.CUSTOMER_TEMP AS
        SELECT
            CONTACTFIRSTNAME,
            CONTACTLASTNAME,
            CUSTOMERNAME,
            PHONE,
            ADDRESSLINE1,
            ADDRESSLINE2,
            CITY,
            STATE,
            POSTALCODE,
            COUNTRY,
            TERRITORY,
            CURRENT_TIMESTAMP(6) AS INSERT_DTS,
            CURRENT_TIMESTAMP(6) AS UPDATE_DTS
        FROM SCD1_DB.PUBLIC.CUSTOMER_STREAM;
    `});

    snowflake.execute({sqlText: `
        MERGE INTO SCD1_DB.PUBLIC.CUSTOMER AS TGT
        USING SCD1_DB.PUBLIC.CUSTOMER_TEMP AS TMP
            ON TGT.CONTACTFIRSTNAME = TMP.CONTACTFIRSTNAME
           AND TGT.CONTACTLASTNAME = TMP.CONTACTLASTNAME

        WHEN MATCHED THEN UPDATE SET
            TGT.CUSTOMERNAME = TMP.CUSTOMERNAME,
            TGT.PHONE = TMP.PHONE,
            TGT.ADDRESSLINE1 = TMP.ADDRESSLINE1,
            TGT.ADDRESSLINE2 = TMP.ADDRESSLINE2,
            TGT.CITY = TMP.CITY,
            TGT.STATE = TMP.STATE,
            TGT.POSTALCODE = TMP.POSTALCODE,
            TGT.COUNTRY = TMP.COUNTRY,
            TGT.TERRITORY = TMP.TERRITORY,
            TGT.UPDATE_DTS = TMP.UPDATE_DTS

        WHEN NOT MATCHED THEN INSERT
        (
            CONTACTFIRSTNAME,
            CONTACTLASTNAME,
            CUSTOMERNAME,
            PHONE,
            ADDRESSLINE1,
            ADDRESSLINE2,
            CITY,
            STATE,
            POSTALCODE,
            COUNTRY,
            TERRITORY,
            INSERT_DTS,
            UPDATE_DTS
        )
        VALUES
        (
            TMP.CONTACTFIRSTNAME,
            TMP.CONTACTLASTNAME,
            TMP.CUSTOMERNAME,
            TMP.PHONE,
            TMP.ADDRESSLINE1,
            TMP.ADDRESSLINE2,
            TMP.CITY,
            TMP.STATE,
            TMP.POSTALCODE,
            TMP.COUNTRY,
            TMP.TERRITORY,
            TMP.INSERT_DTS,
            TMP.UPDATE_DTS
        );
    `});

    snowflake.execute({sqlText: `COMMIT;`});
    return "Stored Procedure Executed Successfully";

} catch (err) {
    snowflake.execute({sqlText: `ROLLBACK;`});
    throw "Error: " + err;
}
$$;

SHOW PROCEDURES LIKE 'CUSTOMER_SP' IN SCHEMA SCD1_DB.PUBLIC;
