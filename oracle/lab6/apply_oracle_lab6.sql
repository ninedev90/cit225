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
--   sql> @apply_oracle_lab6.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab5/apply_oracle_lab5.sql

SPOOL apply_oracle_lab5.txt

-- 1. [4 points] Add the RENTAL_ITEM_PRICE and RENTAL_ITEM_TYPE columns to
-- the RENTAL_ITEM table. Both columns should use a NUMBER data type.
ALTER TABLE rental_item_lab ADD (rental_item_lab_price NUMBER);
ALTER TABLE rental_item_lab ADD (rental_item_lab_type NUMBER);


-- 2. [4 points] Create the PRICE table as per the specification qualified
-- below. The specification requires that you add a 'Y' or 'N' against the
-- ACTIVE_FLAG column. You should use YN_PRICE for the name of the CHECK
-- constraint.


CREATE TABLE price_lab
( price_lab_id                  NUMBER
  , item_lab_id                 NUMBER        CONSTRAINT nn_price_lab_1 NOT NULL
  , price_type                  NUMBER
  , active_flag                 VARCHAR2(1)   CONSTRAINT nn_price_lab_2 NOT NULL
  , start_date                  DATE          CONSTRAINT nn_price_lab_3 NOT NULL
  , end_date                    DATE
  , created_by                  NUMBER        CONSTRAINT nn_price_lab_4 NOT NULL
  , creation_date               DATE          CONSTRAINT nn_price_lab_5 NOT NULL
  , last_updated_by             NUMBER        CONSTRAINT nn_price_lab_6 NOT NULL
  , last_update_date            DATE          CONSTRAINT nn_price_lab_7 NOT NULL
  , CONSTRAINT pk_price_lab_1      PRIMARY KEY(price_lab_id)
  , CONSTRAINT fk_price_lab_2      FOREIGN KEY(last_updated_by) REFERENCES item_lab(item_lab_id));
  , CONSTRAINT fk_price_lab_3      FOREIGN KEY(price_type)      REFERENCES common_lookup_lab(common_lookup_lab_id)
  , CONSTRAINT fk_price_lab_4      FOREIGN KEY(created_by)      REFERENCES system_user_lab(system_user_lab_id)
  , CONSTRAINT fk_price_lab_5      FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));


--You should use the following formatting and query to verify completion of this step:
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT    table_name
  ,       column_id
  ,       column_name
  ,       CASE
            WHEN nullable = 'N' THEN 'NOT NULL'
            ELSE ''
          END AS nullable
  ,       CASE
            WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
          ELSE
             data_type
           END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'RENTAL_ITEM'
ORDER BY 2;

SPOOL OFF
