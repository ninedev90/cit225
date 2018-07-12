-- url - http://michaelmclaughlin.info/db1/lesson-7-aggregation/lab-10-oracle-group/
-- ----------------------------------------------------------------------
-- Instructions:
-- ----------------------------------------------------------------------
-- The two scripts contain spooling commands, which is why there
-- isn't a spooling command in this script. When you run this file
-- you first connect to the Oracle database with this syntax:
--
--   sqlplus student/student@xe
--
-- Then, you call this script with the following syntax:
--
--   sql> @apply_oracle_lab10.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab9/apply_oracle_lab9.sql


SPOOL apply_oracle_lab10.log

-- Step #1 - [15 points] The first SELECT statement uses a query that relies on a mapping and translation table. This step requires you to create a query that take records from the TRANSACTION_UPLOAD table and inserts them into the RENTAL table. You’ll use this query inside a SELECT statement in Lab #11.
SELECT   DISTINCT c.contact_id
FROM     member m INNER JOIN transaction_upload tu
ON       m.account_number = tu.account_number INNER JOIN contact c
ON       m.member_id = c.member_id
WHERE    c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
ORDER BY c.contact_id;


UPDATE SET last_updated_by = SOURCE.last_updated_by
,          last_update_date = SOURCE.last_update_date;


-- Step #1a - Check the join condition between the MEMBER and CONTACT table, which should return 15 rows. If this is not correct, fix the foreign key values in the CONTACT table.
SELECT   COUNT(*)
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id;

-- Step #1b - Check the join condition between the CONTACT and TRANSACTION_UPLOAD tables. It should return 11,520 rows. If this is not correct, fix the FIRST_NAME, MIDDLE_NAME, or LAST_NAME values in the CONTACT table or check whether you have the current *.csv file.
SELECT   COUNT(*)
FROM     contact c INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name;

-- Step #1c - Check the join condition between both the MEMBER and CONTACT tables and the join of those two tables with the TRANSACTION_UPLOAD table. This should return 11,520 rows. If this is not correct, fix the ACCOUNT_NUMBER column values in the MEMBER table.
SELECT   COUNT(*)
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN transaction_upload tu
ON       c.first_name = tu.first_name
AND      NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
AND      c.last_name = tu.last_name
AND      m.account_number = tu.account_number;


-- Step #1d - Did you insert the correct foreign key value in the MEMBER_ID column of the CONTACT table when you added the Potter Family?
-- Step #1e - Did you insert an address for each of the individuals in the Potter Family?
-- Step #1f - Do the Potter’s live in Utah?
-- Step #1g - Did you insert the correct foreign key value in the CONTACT_ID column of the ADDRESS table.
-- Step #1h - If the Potter’s live someplace other than Provo or Spanish Fork, did you enter a row in the AIRPORT table for them?
-- Step #1i - Did you enter the correct names for the Potter’s? They should be Harry Potter, Ginny Potter, and Lily Luna Potter.

SET NULL '<Null>'
COLUMN rental_id        FORMAT 9999 HEADING "Rental|ID #"
COLUMN customer         FORMAT 9999 HEADING "Customer|ID #"
COLUMN check_out_date   FORMAT A9   HEADING "Check Out|Date"
COLUMN return_date      FORMAT A10  HEADING "Return|Date"
COLUMN created_by       FORMAT 9999 HEADING "Created|By"
COLUMN creation_date    FORMAT A10  HEADING "Creation|Date"
COLUMN last_updated_by  FORMAT 9999 HEADING "Last|Update|By"
COLUMN last_update_date FORMAT A10  HEADING "Last|Updated"

--before insert
SELECT   COUNT(*) AS "Rental before count"
FROM     rental_lab;

-- after insert
SELECT   COUNT(*) AS "Rental after count"
FROM     rental_lab;

-- Step #2  - [15 points] The second SELECT statement requires that you inserted values into the RENTAL table in the last step. It leverages the joins that you worked out in the first SELECT statement. Don’t try to re-invent the wheel because it isn’t profitable in this case.
SELECT   COUNT(*)
FROM    (SELECT   rental_item_id
           ,        r.rental_id
           ,        tu.item_id
           ,        TRUNC(r.return_date) - TRUNC(r.check_out_date) AS rental_item_price
           ,        cl.common_lookup_id AS rental_item_type
           ,        3 AS created_by
           ,        TRUNC(creation_date) AS creation_date
           ,        3 AS last_updated_by
           ,        TRUNC(last_update_date) AS last_update_date
         FROM ... ) il;


-- Step #2a  - Join the foregoing result set (the foregoing result set is the result set of the prior join) to the COMMON_LOOKUP table on an INNER JOIN, and translate the COMMON_LOOKUP_TYPE column value to a COMMON_LOOKUP_ID value.
-- Step #2b  - Join the foregoing result set to the RENTAL_ITEM table on an LEFT JOIN.
-- Step #2c  - Remove the DISTINCT operator
-- Step #2d  - Restructure the SELECT clause list.
SET NULL '<Null>'
COLUMN rental_item_id     FORMAT 99999 HEADING "Rental|Item ID #"
COLUMN rental_id          FORMAT 99999 HEADING "Rental|ID #"
COLUMN item_id            FORMAT 99999 HEADING "Item|ID #"
COLUMN rental_item_price  FORMAT 99999 HEADING "Rental|Item|Price"
COLUMN rental_item_type   FORMAT 99999 HEADING "Rental|Item|Type"
...

SELECT   COUNT(*) AS "Rental Item Before Count"
FROM     rental_item;

SELECT   COUNT(*) AS "Rental Item After Count"
FROM     rental_item;

-- Step #3 - [15 points] The third SELECT statement requires that you inserted values into the RENTAL_ITEM table in the last step. It also leverages the joins that you worked out in the first and secondSELECT statements. Don’t try to re-invent the wheel because it isn’t profitable, especially in this case.

ON      cl1.common_lookup_table = 'TRANSACTION'
AND     cl1.common_lookup_column = 'TRANSACTION_TYPE'
AND     cl1.common_lookup_type = 'Check mapping table to find the correct type value';

ON      cl2.common_lookup_table = 'TRANSACTION'
AND     cl2.common_lookup_column = 'PAYMENT_METHOD_TYPE'
AND     cl2.common_lookup_type = 'Check mapping table to find the correct type value'



SPOOL OFF