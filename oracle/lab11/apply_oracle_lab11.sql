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
--   sql> @apply_oracle_lab11.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab10/apply_oracle_lab10.sql

SPOOL apply_oracle_lab11.log

-- Step#1 - [6 points] This step requires that you use the query from Lab #10 that you used to insert records into the RENTAL table. You need to put it inside the USING clause of the MERGE statement as the query, resolve which columns you use in an UPDATE statement, and resolve which columns you use in an INSERT statement.

MERGE INTO rental_lab target
USING (
  SELECT DISTINCT r.rental_lab_id
  ,      c.contact_lab_id
  ,      TRUNC(tu.check_out_date) AS check_out_date
  ,      TRUNC(tu.return_date) AS return_date
  ,      1 AS created_by
  ,      TRUNC(SYSDATE) AS creation_date
  ,      1 AS last_updated_by
  ,      TRUNC(SYSDATE) AS last_update_date
  FROM member_lab m
  INNER JOIN contact_lab c ON m.member_lab_id = c.member_lab_id
  INNER JOIN transaction_upload tu ON c.first_name = tu.first_name
  AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
  AND  c.last_name = tu.last_name
  AND  tu.account_number = m.account_number
  LEFT JOIN rental_lab r ON c.contact_lab_id = r.customer_id
  AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
  AND  TRUNC(tu.return_date) = TRUNC(r.return_date)
) source
ON (target.column_name = source.column_name)
WHEN MATCHED THEN
UPDATE SET target.column_name = source.column_name
,          target.column_name = source.column_name
WHEN NOT MATCHED THEN
INSERT VALUES
(
       rental_lab_s1.nextval
,      source.contact_lab_id
,      source.check_out_date
,      source.return_date
,      source.created_by
,      source.creation_date
,      source.last_updated_by
,      source.last_update_date
);



SELECT   TO_CHAR(COUNT(*),'99,999') AS "Rental after merge"
FROM     rental_lab;

-- Step#2 - [6 points] This step requires that the preceding MERGE statement ran successfully and that you use the query from Lab #10 that you used to insert records into the RENTAL_ITEM table. You need to put it inside the USING clause of the MERGE statement as the query, resolve which columns you use in an UPDATE statement, and resolve which columns you use in an INSERT statement.

MERGE INTO rental_item_lab target
USING (
  SELECT   r.rental_lab_id
  ,        tu.item_id
  ,        TRUNC(r.return_date) - TRUNC(r.check_out_date) AS rental_item_lab_price
  ,        cl.common_lookup_lab_id AS rental_item_lab_type
  ,        1 AS created_by
  ,        TRUNC(SYSDATE) AS creation_date
  ,        1 AS last_updated_by
  ,        TRUNC(SYSDATE) AS last_update_date
  FROM member_lab m INNER JOIN contact_lab c
  ON   m.member_lab_id = c.member_lab_id INNER JOIN transaction_upload tu
  ON   c.first_name = tu.first_name
  AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
  AND  c.last_name = tu.last_name
  AND  tu.account_number = m.account_number INNER JOIN common_lookup_lab cl
  ON cl.common_lookup_lab_type = tu.rental_item_type
  AND cl.common_lookup_lab_table = 'RENTAL_ITEM_LAB' LEFT JOIN rental_lab r
  ON   c.contact_lab_id = r.customer_id
  AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
  AND TRUNC(tu.return_date) = TRUNC(r.return_date)
) source
ON (target.column_name = source.column_name)
WHEN MATCHED THEN
UPDATE SET target.column_name = source.column_name
,          target.column_name = source.column_name
WHEN NOT MATCHED THEN
INSERT VALUES
(
  rental_item_lab_s1.nextval
  , source.rental_lab_id
  , source.item_lab_id
  , source.created_by
  , source.creation_date
  , source.last_updated_by
  , source.last_update_date
  , source.rental_item_lab_price
  , source.rental_item_lab_type
);


SELECT   TO_CHAR(COUNT(*),'99,999') AS "Rental Item after merge"
FROM     rental_item_lab;


-- Step#3 - [6 points] This step requires that the preceding MERGE statement ran successfully and that you use the query from Lab #10 that you used to insert records into the TRANSACTION table. You need to put it inside the USING clause of the MERGE statement as the query, resolve which columns you use in an UPDATE statement, and resolve which columns you use in an INSERT statement.


MERGE INTO transaction target
USING (
  SELECT t.transaction_id AS transaction_id
  ,      tu.account_number AS transaction_account
  ,      cl1.common_lookup_lab_id AS transaction_type
  ,      TRUNC(tu.transaction_date) AS transaction_date
  ,      SUM(tu.transaction_amount) AS transaction_amount
  ,      r.rental_lab_id
  ,      cl2.common_lookup_lab_id AS payment_method_type
  ,      tu.payment_account_number
  ,      1 AS created_by
  ,      TRUNC(SYSDATE) AS creation_date
  ,      1 AS last_updated_by
  ,      TRUNC(SYSDATE) AS last_update_date
  FROM member_lab m
  INNER JOIN contact_lab c ON   m.member_lab_id = c.member_lab_id
  INNER JOIN transaction_upload tu ON   c.first_name = tu.first_name
  AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
  AND  c.last_name = tu.last_name
  AND  tu.account_number = m.account_number
  INNER JOIN rental_lab r ON   c.contact_lab_id = r.customer_id
  AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
  AND  TRUNC(tu.return_date) = TRUNC(r.return_date)
  INNER JOIN common_lookup_lab cl1 ON      cl1.common_lookup_lab_table = 'TRANSACTION'
  AND     cl1.common_lookup_lab_column = 'TRANSACTION_TYPE'
  AND     cl1.common_lookup_lab_type = tu.transaction_type
  INNER JOIN common_lookup_lab cl2 ON      cl2.common_lookup_lab_table = 'TRANSACTION'
  AND     cl2.common_lookup_lab_column = 'PAYMENT_METHOD_TYPE'
  AND     cl2.common_lookup_lab_type = tu.payment_method_type
  LEFT JOIN transaction t ON t.TRANSACTION_ACCOUNT = tu.payment_account_number
  AND t.TRANSACTION_TYPE = cl1.common_lookup_lab_id
  AND t.TRANSACTION_DATE = tu.transaction_date
  AND t.TRANSACTION_AMOUNT = tu.TRANSACTION_AMOUNT
  AND t.PAYMENT_METHOD_type = cl2.common_lookup_lab_id
  AND t.PAYMENT_ACCOUNT_NUMBER = tu.payment_account_number
  GROUP BY t.transaction_id
  , tu.account_number
  , cl1.common_lookup_lab_id
  , tu.transaction_date
  , r.rental_lab_id
  , cl2.common_lookup_lab_id
  , tu.payment_account_number
) source
ON (target.column_name = source.column_name)
WHEN MATCHED THEN
UPDATE SET target.column_name = source.column_name
,          target.column_name = source.column_name
WHEN NOT MATCHED THEN
INSERT VALUES
(
    transaction_s1.nextval
  , source.transaction_account
  , source.transaction_type
  , source.transaction_date
  , source.transaction_amount
  , source.rental_lab_id
  , source.payment_method_type
  , source.payment_account_number
  , source.created_by
  , source.creation_date
  , source.last_updated_by
  , source.last_update_date
);

SELECT   TO_CHAR(COUNT(*),'99,999') AS "Transaction after merge"
FROM     transaction;


-- Step#4 - [12 points] After running the first three steps, you need to put the three MERGE statement into a single upload_transaction procedure. Then, you need to run the upload_transaction procedure, run a validation query, run the upload_transaction procedure a second time, and run a validation query again.

-- 4a - [4 points of 12 points] After running the first three steps, you need to put the three MERGE statement into a single upload_transaction procedure.

-- Create a procedure to wrap the transaction.
CREATE OR REPLACE PROCEDURE upload_transaction IS
BEGIN
  -- Set save point for an all or nothing transaction.
  SAVEPOINT starting_point;

  -- Merge into RENTAL table.
  MERGE INTO rental_lab target
  USING (
  SELECT DISTINCT r.rental_lab_id
  ,      c.contact_lab_id
  ,      TRUNC(tu.check_out_date) AS check_out_date
  ,      TRUNC(tu.return_date) AS return_date
  ,      1 AS created_by
  ,      TRUNC(SYSDATE) AS creation_date
  ,      1 AS last_updated_by
  ,      TRUNC(SYSDATE) AS last_update_date
  FROM member_lab m
  INNER JOIN contact_lab c ON m.member_lab_id = c.member_lab_id
  INNER JOIN transaction_upload tu ON c.first_name = tu.first_name
  AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
  AND  c.last_name = tu.last_name
  AND  tu.account_number = m.account_number
  LEFT JOIN rental_lab r ON c.contact_lab_id = r.customer_id
  AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
  AND  TRUNC(tu.return_date) = TRUNC(r.return_date)
  ) source
  ON (target.column_name = source.column_name)
  WHEN MATCHED THEN
  UPDATE SET target.column_name = source.column_name
  ,          target.column_name = source.column_name
  WHEN NOT MATCHED THEN
  INSERT VALUES
  (
  rental_lab_s1.nextval
  ,      source.contact_lab_id
  ,      source.check_out_date
  ,      source.return_date
  ,      source.created_by
  ,      source.creation_date
  ,      source.last_updated_by
  ,      source.last_update_date
  );

  -- Merge into RENTAL_ITEM table.
  MERGE INTO rental_item_lab target
  USING (
  SELECT   r.rental_lab_id
  ,        tu.item_id
  ,        TRUNC(r.return_date) - TRUNC(r.check_out_date) AS rental_item_lab_price
  ,        cl.common_lookup_lab_id AS rental_item_lab_type
  ,        1 AS created_by
  ,        TRUNC(SYSDATE) AS creation_date
  ,        1 AS last_updated_by
  ,        TRUNC(SYSDATE) AS last_update_date
  FROM member_lab m INNER JOIN contact_lab c
  ON   m.member_lab_id = c.member_lab_id INNER JOIN transaction_upload tu
  ON   c.first_name = tu.first_name
  AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
  AND  c.last_name = tu.last_name
  AND  tu.account_number = m.account_number INNER JOIN common_lookup_lab cl
  ON cl.common_lookup_lab_type = tu.rental_item_type
  AND cl.common_lookup_lab_table = 'RENTAL_ITEM_LAB' LEFT JOIN rental_lab r
  ON   c.contact_lab_id = r.customer_id
  AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
  AND TRUNC(tu.return_date) = TRUNC(r.return_date)
  ) source
  ON (target.column_name = source.column_name)
  WHEN MATCHED THEN
  UPDATE SET target.column_name = source.column_name
  ,          target.column_name = source.column_name
  WHEN NOT MATCHED THEN
  INSERT VALUES
  (
  rental_item_lab_s1.nextval
  , source.rental_lab_id
  , source.item_lab_id
  , source.created_by
  , source.creation_date
  , source.last_updated_by
  , source.last_update_date
  , source.rental_item_lab_price
  , source.rental_item_lab_type
  );

  -- Merge into TRANSACTION table.
  MERGE INTO transaction target
  USING (
  SELECT t.transaction_id AS transaction_id
  ,      tu.account_number AS transaction_account
  ,      cl1.common_lookup_lab_id AS transaction_type
  ,      TRUNC(tu.transaction_date) AS transaction_date
  ,      SUM(tu.transaction_amount) AS transaction_amount
  ,      r.rental_lab_id
  ,      cl2.common_lookup_lab_id AS payment_method_type
  ,      tu.payment_account_number
  ,      1 AS created_by
  ,      TRUNC(SYSDATE) AS creation_date
  ,      1 AS last_updated_by
  ,      TRUNC(SYSDATE) AS last_update_date
  FROM member_lab m
  INNER JOIN contact_lab c ON   m.member_lab_id = c.member_lab_id
  INNER JOIN transaction_upload tu ON   c.first_name = tu.first_name
  AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
  AND  c.last_name = tu.last_name
  AND  tu.account_number = m.account_number
  INNER JOIN rental_lab r ON   c.contact_lab_id = r.customer_id
  AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
  AND  TRUNC(tu.return_date) = TRUNC(r.return_date)
  INNER JOIN common_lookup_lab cl1 ON      cl1.common_lookup_lab_table = 'TRANSACTION'
  AND     cl1.common_lookup_lab_column = 'TRANSACTION_TYPE'
  AND     cl1.common_lookup_lab_type = tu.transaction_type
  INNER JOIN common_lookup_lab cl2 ON      cl2.common_lookup_lab_table = 'TRANSACTION'
  AND     cl2.common_lookup_lab_column = 'PAYMENT_METHOD_TYPE'
  AND     cl2.common_lookup_lab_type = tu.payment_method_type
  LEFT JOIN transaction t ON t.TRANSACTION_ACCOUNT = tu.payment_account_number
  AND t.TRANSACTION_TYPE = cl1.common_lookup_lab_id
  AND t.TRANSACTION_DATE = tu.transaction_date
  AND t.TRANSACTION_AMOUNT = tu.TRANSACTION_AMOUNT
  AND t.PAYMENT_METHOD_type = cl2.common_lookup_lab_id
  AND t.PAYMENT_ACCOUNT_NUMBER = tu.payment_account_number
  GROUP BY t.transaction_id
  , tu.account_number
  , cl1.common_lookup_lab_id
  , tu.transaction_date
  , r.rental_lab_id
  , cl2.common_lookup_lab_id
  , tu.payment_account_number
  ) source
  ON (target.column_name = source.column_name)
  WHEN MATCHED THEN
  UPDATE SET target.column_name = source.column_name
  ,          target.column_name = source.column_name
  WHEN NOT MATCHED THEN
  INSERT VALUES
  (
  transaction_s1.nextval
  , source.transaction_account
  , source.transaction_type
  , source.transaction_date
  , source.transaction_amount
  , source.rental_lab_id
  , source.payment_method_type
  , source.payment_account_number
  , source.created_by
  , source.creation_date
  , source.last_updated_by
  , source.last_update_date
  );

  -- Save the changes.
  COMMIT;

EXCEPTION
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END;
/

SHOW ERRORS

-- 4b - [2 points of 12 points] You run the upload_transaction procedure with the following syntax:
EXECUTE upload_transaction;

-- 4c - [2 points of 12 points] You should use the following to query the results from procedure.
COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"

SELECT   il1.rental_count
  ,        il2.rental_item_count
  ,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
  (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
  (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;


-- 4d - [2 points of 12 points] You re-run the upload_transaction procedure with the following syntax:

EXECUTE upload_transaction;

-- 4e - [2 points of 12 points] You should reuse the following to query the results from procedure.

COLUMN rental_count      FORMAT 99,999 HEADING "Rental|Count"
COLUMN rental_item_count FORMAT 99,999 HEADING "Rental|Item|Count"
COLUMN transaction_count FORMAT 99,999 HEADING "Transaction|Count"

SELECT   il1.rental_count
  ,        il2.rental_item_count
  ,        il3.transaction_count
FROM    (SELECT COUNT(*) AS rental_count FROM rental) il1 CROSS JOIN
  (SELECT COUNT(*) AS rental_item_count FROM rental_item) il2 CROSS JOIN
  (SELECT COUNT(*) AS transaction_count FROM TRANSACTION) il3;


-- Step#5 - [5 points] Create a query that prints the following types of data for the year 2009, which is only possible when you adjust for the included 6% interest. You need to make that adjustment inside the third merge statement’s SELECT clause.
SELECT   EXTRACT(MONTH FROM TO_DATE('02-FEB-2009'))
  ,        EXTRACT(YEAR FROM TO_DATE('02-FEB-2009'))
FROM     dual;

SELECT   TO_CHAR(9999,'$9,999,999.00') AS "Formatted"
FROM     dual;

SPOOL OFF

COMMIT;