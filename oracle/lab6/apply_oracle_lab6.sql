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
-- Set the page size.
SET ECHO ON
SET PAGESIZE 999
-- ----------------------------------------------------------------------
-- Item #1. [4 points] Add the RENTAL_ITEM_PRICE and RENTAL_ITEM_TYPE columns to
-- the RENTAL_ITEM table. Both columns should use a NUMBER data type.
-- ----------------------------------------------------------------------
ALTER TABLE rental_item_lab 
  ADD (rental_item_lab_price NUMBER)
  ADD (rental_item_lab_type NUMBER);


/* ----------------------------------------------------------------------
-- Verification of item #1.
-- Should show the table below

TABLE_NAME     COLUMN_ID COLUMN_NAME            NULLABLE DATA_TYPE
-------------- --------- ---------------------- -------- ------------
RENTAL_ITEM            1 RENTAL_ITEM_ID         NOT NULL NUMBER(22)
RENTAL_ITEM            2 RENTAL_ID              NOT NULL NUMBER(22)
RENTAL_ITEM            3 ITEM_ID                NOT NULL NUMBER(22)
RENTAL_ITEM            4 CREATED_BY             NOT NULL NUMBER(22)
RENTAL_ITEM            5 CREATION_DATE          NOT NULL DATE
RENTAL_ITEM            6 LAST_UPDATED_BY        NOT NULL NUMBER(22)
RENTAL_ITEM            7 LAST_UPDATE_DATE       NOT NULL DATE
RENTAL_ITEM            8 RENTAL_ITEM_TYPE                NUMBER(22)
RENTAL_ITEM            9 RENTAL_ITEM_PRICE               NUMBER(22)
 
9 rows selected.
*/
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'RENTAL_ITEM_LAB'
ORDER BY 2;

-- ----------------------------------------------------------------------
-- Step #2. [4 points] Create the PRICE table as per the specification qualified
-- below. The specification requires that you add a 'Y' or 'N' against the
-- ACTIVE_FLAG column. You should use YN_PRICE for the name of the CHECK
-- constraint.
-- ----------------------------------------------------------------------

CREATE TABLE price_lab
( price_lab_id                  NUMBER
  , item_lab_id                 NUMBER        CONSTRAINT nn_price_lab_1 NOT NULL
  , price_type                  NUMBER
  , active_flag                 VARCHAR2(1)   CONSTRAINT yn_price CHECK(active_flag in ('Y', 'N'))
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

-- ----------------------------------------------------------------------
-- Verification of Step #2 - Price Lab Table
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'PRICE_LAB'
ORDER BY 2;

-- ----------------------------------------------------------------------
-- Verification of Step #2 - Constraint Check
-- ----------------------------------------------------------------------
COLUMN constraint_name   FORMAT A16
COLUMN search_condition  FORMAT A30
SELECT   uc.constraint_name
,        uc.search_condition
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('price')
AND      ucc.column_name = UPPER('active_flag')
AND      uc.constraint_name = UPPER('yn_price')
AND      uc.constraint_type = 'C';

-- ----------------------------------------------------------------------
-- Step #3a - [2 points] Rename the ITEM_RELEASE_DATE column of the ITEM 
-- table to RELEASE_DATE.
-- ----------------------------------------------------------------------
ALTER TABLE item_lab RENAME 
COLUMN item_lab_release_date TO release_date;

-- ----------------------------------------------------------------------
-- Verification Step #3a
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'ITEM_LAB'
ORDER BY 2;

-- ----------------------------------------------------------------------
-- Step #3b - [6 points] Insert three new DVD releases into the ITEM table.
-- ----------------------------------------------------------------------
--First Item
INSERT INTO item_lab
( item_lab_id
, item_lab_barcode
, item_lab_type
, item_lab_title
, item_lab_subtitle
, item_lab_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'24543-20181'
,(SELECT   common_lab_lookup_id
  FROM     common_lab_lookup
  WHERE    common_lab_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
,'Goku and the prisoner of azkaban'
,'A Otako movie'
,'Everyone'
,TRUNC(SYSDATE + 10)
, 1001
, SYSDATE
, 1001
, SYSDATE);

--Second Item
INSERT INTO item_lab
( item_lab_id
, item_lab_barcode
, item_lab_type
, item_lab_title
, item_lab_subtitle
, item_lab_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'24543-20182'
,(SELECT   common_lab_lookup_id
  FROM     common_lab_lookup
  WHERE    common_lab_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
,'Infinity War'
,'The Last Avanger'
,'PG'
,TRUNC(SYSDATE + 10)
, 1001
, SYSDATE
, 1001
, SYSDATE);

--Third Item
INSERT INTO item_lab
( item_lab_id
, item_lab_barcode
, item_lab_type
, item_lab_title
, item_lab_subtitle
, item_lab_rating
, release_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( item_lab_s1.nextval
,'24543-20183'
,(SELECT   common_lab_lookup_id
  FROM     common_lab_lookup
  WHERE    common_lab_lookup_context = 'ITEM_LAB'
  AND      common_lookup_type = 'DVD_WIDE_SCREEN')
,'Upgrade'
,'No Man, No Machine, More.'
,'Everyone'
,TRUNC(SYSDATE + 10)
, 1001
, SYSDATE
, 1001
, SYSDATE);

-- ----------------------------------------------------------------------
-- Verification Step #3b 
-- ----------------------------------------------------------------------
SELECT   i.item_title
,        SYSDATE AS today
,        i.release_date
FROM     item i
WHERE   (SYSDATE - i.release_date) < 31;

-- ----------------------------------------------------------------------
-- Step #3c - [26 points] Insert a new member account with three contacts.
-- ----------------------------------------------------------------------

-- First Record Set
INSERT INTO member_lab
( member_lab_id
, member_lab_type
, account_number
, credit_card_number
, credit_card_type
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( member_lab_s1.nextval                           -- member_lab_id
, NULL                                            -- member_lab_type
,'US00011'                                        -- account_number
,'6011 0000 0000 0078'                            -- credit_card_number
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'MEMBER_LAB'
  AND      common_lookup_lab_type = 'DISCOVER_CARD')  -- credit_card_type
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_lab_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_lab_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

-- ------------------------------------------------------------------
--  Insert first contact_lab in a group account user.
-- ------------------------------------------------------------------
INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_lab_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_lab_s1.nextval                              -- contact_lab_id
, member_lab_s1.currval                               -- member_lab_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'CONTACT_LAB'
  AND      common_lookup_lab_type = 'CUSTOMER')       -- contact_lab_type
,'Harry'                                          -- first_name
,'Potter'                                           -- last_name
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_lab_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_lab_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO address
( address_id
, contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_s1.nextval                              -- address_id
, contact_s1.currval                              -- contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'Provo'                                       -- city
,'Utah'                                             -- state_province
,'84604'                                          -- postal_code
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO street_address
( street_address_id
, address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_s1.nextval                       -- street_address_id
, address_s1.currval                              -- address_id
,'900 E, 300 N'                              -- street_address
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO telephone
( telephone_id
, contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_s1.nextval                            -- telephone_id
, address_s1.currval                              -- address_id
, contact_s1.currval                              -- contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'001'                                            -- country_code
,'801'                                            -- area_code
,'333-3333'                                       -- telephone_number
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

-- second Record Set
INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_lab_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_lab_s1.nextval                              -- contact_lab_id
, member_lab_s1.currval                               -- member_lab_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'CONTACT_LAB'
  AND      common_lookup_lab_type = 'CUSTOMER')       -- contact_lab_type
,'Ginny'                                          -- first_name
,'Potter'                                           -- last_name
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_lab_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_lab_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO address
( address_id
, contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_s1.nextval                              -- address_id
, contact_s1.currval                              -- contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'Provo'                                       -- city
,'Utah'                                             -- state_province
,'84604'                                          -- postal_code
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO street_address
( street_address_id
, address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_s1.nextval                       -- street_address_id
, address_s1.currval                              -- address_id
,'900 E, 300 N'                              -- street_address
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO telephone
( telephone_id
, contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_s1.nextval                            -- telephone_id
, address_s1.currval                              -- address_id
, contact_s1.currval                              -- contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'001'                                            -- country_code
,'801'                                            -- area_code
,'333-3333'                                       -- telephone_number
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

-- Third Record Set
INSERT INTO contact_lab
( contact_lab_id
, member_lab_id
, contact_lab_type
, first_name
, last_name
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( contact_lab_s1.nextval                              -- contact_lab_id
, member_lab_s1.currval                               -- member_lab_id
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'CONTACT_LAB'
  AND      common_lookup_lab_type = 'CUSTOMER')       -- contact_lab_type
,'Lily Luna'                                          -- first_name
,'Potter'                                           -- last_name
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_lab_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_lab_id
  FROM     system_user_lab
  WHERE    system_user_lab_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO address
( address_id
, contact_id
, address_type
, city
, state_province
, postal_code
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( address_s1.nextval                              -- address_id
, contact_s1.currval                              -- contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_type = 'HOME')           -- address_type
,'Provo'                                       -- city
,'Utah'                                             -- state_province
,'84604'                                          -- postal_code
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO street_address
( street_address_id
, address_id
, street_address
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( street_address_s1.nextval                       -- street_address_id
, address_s1.currval                              -- address_id
,'900 E, 300 N'                              -- street_address
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

INSERT INTO telephone
( telephone_id
, contact_id
, address_id
, telephone_type
, country_code
, area_code
, telephone_number
, created_by
, creation_date
, last_updated_by
, last_update_date )
 VALUES
( telephone_s1.nextval                            -- telephone_id
, address_s1.currval                              -- address_id
, contact_s1.currval                              -- contact_id
,(SELECT   common_lookup_id
  FROM     common_lookup
  WHERE    common_lookup_context = 'MULTIPLE'
  AND      common_lookup_type = 'HOME')           -- telephone_type
,'001'                                            -- country_code
,'801'                                            -- area_code
,'333-3333'                                       -- telephone_number
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- created_by
, SYSDATE                                         -- creation_date
,(SELECT   system_user_id
  FROM     system_user
  WHERE    system_user_name = 'SYSADMIN')         -- last_updated_by
, SYSDATE                                         -- last_update_date
);

-- ----------------------------------------------------------------------
-- Verification on Step #3c
-- ----------------------------------------------------------------------
COLUMN account_number  FORMAT A10  HEADING "Account|Number"
COLUMN full_name       FORMAT A16  HEADING "Name|(Last, First MI)"
COLUMN street_address  FORMAT A14  HEADING "Street Address"
COLUMN city            FORMAT A10  HEADING "City"
COLUMN state           FORMAT A10  HEADING "State"
COLUMN postal_code     FORMAT A6   HEADING "Postal|Code"
SELECT   m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN
             ' ' || c.middle_name || ' '
         END AS full_name
,        sa.street_address
,        a.city
,        a.state_province AS state
,        a.postal_code
FROM     member m INNER JOIN contact c
ON       m.member_id = c.member_id INNER JOIN address a
ON       c.contact_id = a.contact_id INNER JOIN street_address sa
ON       a.address_id = sa.address_id INNER JOIN telephone t
ON       c.contact_id = t.contact_id
WHERE    c.last_name = 'Potter';

-- ------------------------------------------------------------------
-- Step #3d - [14 points] Insert two rows into the RENTAL table with a dependent 
-- row for each in the RENTAL_ITEM table; and one row into the RENTAL 
-- table with two dependent rows in the RENTAL_ITEM table.
-- ------------------------------------------------------------------

-- First Record Set (Harry Potter)
INSERT INTO rental_lab
( rental_lab_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Potter'
  AND      first_name = 'Harry')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 1
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
, rental_lab_s1.currval
,(SELECT   i.item_lab_id
  FROM     item_lab i
  ,        common_lookup_lab cl
  WHERE    i.item_lab_title = 'Star Wars I'
  AND      i.item_lab_subtitle = 'Phantom Menace'
  AND      i.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
, rental_lab_s1.currval
,(SELECT   i.item_lab_id
  FROM     item_lab i
  ,        common_lookup_lab cl
  WHERE    i.item_lab_title = 'Goku and the prisoner of azkaban'
  AND      i.item_lab_subtitle = 'A Otako movie'
  AND      i.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);

-- Second Record Set ( Ginny Potter )
INSERT INTO rental_lab
( rental_lab_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Potter'
  AND      first_name = 'Ginny')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 3
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
, rental_lab_s1.currval
,(SELECT   i.item_lab_id
  FROM     item_lab i
  ,        common_lookup_lab cl
  WHERE    i.item_lab_title = 'Upgrade'
  AND      i.item_lab_subtitle = 'No Man, No Machine, More.'
  AND      i.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);

-- Third Record Set (Lyly Luna Potter)
INSERT INTO rental_lab
( rental_lab_id
, customer_id
, check_out_date
, return_date
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Potter'
  AND      first_name = 'Lily Luna')
, TRUNC(SYSDATE)
, TRUNC(SYSDATE) + 5
, 1001
, SYSDATE
, 1001
, SYSDATE);

INSERT INTO rental_item_lab
( rental_item_lab_id
, rental_lab_id
, item_lab_id
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( rental_item_lab_s1.nextval
, rental_lab_s1.currval
,(SELECT   i.item_lab_id
  FROM     item_lab i
  ,        common_lookup_lab cl
  WHERE    i.item_lab_title = 'Infinity War'
  AND      i.item_lab_subtitle = 'The Last Avanger'
  AND      i.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'DVD_WIDE_SCREEN')
, 1001
, SYSDATE
, 1001
, SYSDATE);

-- ----------------------------------------------------------------------
-- Verification on Step #3d
-- ----------------------------------------------------------------------
COLUMN full_name   FORMAT A18
COLUMN rental_id   FORMAT 9999
COLUMN rental_days FORMAT A14
COLUMN rentals     FORMAT 9999
COLUMN items       FORMAT 9999
SELECT   c.last_name||', '||c.first_name||' '||c.middle_name AS full_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL' AS rental_days
,        COUNT(DISTINCT r.rental_id) AS rentals
,        COUNT(ri.rental_item_id) AS items
FROM     rental r INNER JOIN rental_item ri
ON       r.rental_id = ri.rental_id INNER JOIN contact c
ON       r.customer_id = c.contact_id
WHERE   (SYSDATE - r.check_out_date) < 15
AND      c.last_name = 'Potter'
GROUP BY c.last_name||', '||c.first_name||' '||c.middle_name
,        r.rental_id
,       (r.return_date - r.check_out_date) || '-DAY RENTAL'
ORDER BY 2;

-- ----------------------------------------------------------------------
-- Step #4 - [32 points] Modify the design of the COMMON_LOOKUP table 
-- and make necessary data changes to support the new design.
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Step #4a - Drop the COMMON_LOOKUP_N1 and COMMON_LOOKUP_U2 indexes.
-- ----------------------------------------------------------------------
DROP INDEX common_lookup_lab_n1;
DROP INDEX common_lookup_lab_U2;

-- ----------------------------------------------------------------------
-- Verification on Step #4a
-- ----------------------------------------------------------------------
COLUMN table_name FORMAT A14
COLUMN index_name FORMAT A20
SELECT   table_name
,        index_name
FROM     user_indexes
WHERE    table_name = 'COMMON_LOOKUP_LAB';

-- ----------------------------------------------------------------------
-- Step #4b - Add three new columns to the COMMON_LOOKUP table.
-- ----------------------------------------------------------------------
ALTER TABLE common_lookup_lab
ADD common_lookup_lab_table     VARCHAR2(30)
,   common_lookup_lab_column    VARCHAR2(30)
,   common_lookup_lab_code      VARCHAR2(30);

-- ----------------------------------------------------------------------
-- Verification on Step #4b
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP_LAB'
ORDER BY 2;

-- ----------------------------------------------------------------------
-- Step #4c - Migrate data and populate (or seed) new columns with existing data
-- ----------------------------------------------------------------------
-- Update the COMMON_LOOKUP_TABLE column with the value of the COMMON_LOOKUP_CONTEXT 
-- column when the COMMON_LOOKUP_CONTEXT column’s value isn’t equal to a value of 'MULTIPLE'
UPDATE   common_lookup_lab
SET      common_lookup_lab_table = common_lookup_lab_context
WHERE    common_lookup_lab_context <> 'MULTIPLE';

-- Update the COMMON_LOOKUP_TABLE column with the value of of 'ADDRESS' when the 
-- COMMON_LOOKUP_CONTEXT column value is equal to 'MULTIPLE'
UPDATE   common_lookup_lab
SET      common_lookup_lab_table = 'ADDRESS'
WHERE    common_lookup_lab_context = 'MULTIPLE';

-- Create COMMON_LOOKUP_COLUMN column values based on references to existing 
-- data in the COMMON_LOOKUP table
UPDATE   common_lookup_lab
SET      common_lookup_lab_column = common_lookup_table || '_TYPE'
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables);

UPDATE   common_lookup_lab
SET      common_lookup_lab_column = 'ADDRESS_TYPE'
WHERE    common_lookup_lab_contet = 'MULTIPLE';

-- ----------------------------------------------------------------------
-- Verification on Step #4c
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;

-- ----------------------------------------------------------------------
-- Step #4d - Add two new rows to the COMMON_LOOKUP table to support the 'HOME' and 
-- 'WORK' possibilities for the TELEPHONE_TYPE column
-- ----------------------------------------------------------------------
INSERT INTO common_lookup_lab
( common_lookup_lab_id
, common_lookup_lab_table
, common_lookup_lab_column
, common_lookup_lab_type
, common_lookup_lab_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( common_lookup_lab_s1.nextval    -- common_lookup_lab_id (1002)
,'TELEPHONE'                      -- common_lookup_lab_table
,'TELEPHONE_TYPE'                 -- common_lookup_lab_column
,'HOME'                           -- common_lookup_lab_type
,'Home'                           -- common_lookup_lab_meaning
, 1                               -- created_by
, SYSDATE                         -- creation_date
, 1                               -- last_updated_by
, SYSDATE                         -- last_update_date
);

INSERT INTO common_lookup_lab
( common_lookup_lab_id
, common_lookup_lab_table
, common_lookup_lab_column
, common_lookup_lab_type
, common_lookup_lab_meaning
, created_by
, creation_date
, last_updated_by
, last_update_date )
VALUES
( common_lookup_lab_s1.nextval    -- common_lookup_lab_id (1002)
,'TELEPHONE'                      -- common_lookup_lab_table
,'TELEPHONE_TYPE'                 -- common_lookup_lab_column
,'WORK'                           -- common_lookup_lab_type
,'Work'                           -- common_lookup_lab_meaning
, 1                               -- created_by
, SYSDATE                         -- creation_date
, 1                               -- last_updated_by
, SYSDATE                         -- last_update_date
);

-- ----------------------------------------------------------------------
-- Verification on Step #4d
-- ----------------------------------------------------------------------
COLUMN common_lookup_context  FORMAT A14  HEADING "Common|Lookup Context"
COLUMN common_lookup_table    FORMAT A12  HEADING "Common|Lookup Table"
COLUMN common_lookup_column   FORMAT A18  HEADING "Common|Lookup Column"
COLUMN common_lookup_type     FORMAT A18  HEADING "Common|Lookup Type"
SELECT   common_lookup_context
,        common_lookup_table
,        common_lookup_column
,        common_lookup_type
FROM     common_lookup
WHERE    common_lookup_table IN
          (SELECT table_name
           FROM   user_tables)
ORDER BY 1, 2, 3;

SELECT common_lookup_lab_id
FROM   common_lookup_lab
WHERE  common_lookup_lab_table = 'ADDRESS'
AND    common_lookup_lab_type = 'HOME';

SELECT common_lookup_lab_id
FROM   common_lookup_lab
WHERE  common_lookup_lab_table = 'TELEPHONE'
AND    common_lookup_lab_type = 'HOME';


-- ----------------------------------------------------------------------
-- Step #4e - At this point, you need to fix the COMMON_LOOKUP table’s structure 
-- ----------------------------------------------------------------------
ALTER TABLE common_lookup_lab
DROP COLUMN common_lookup_lab_context;

ALTER TABLE common_lookup_lab
ADD CONSTRAINT nn_common_lookup_lab_table NOT NULL (common_lookup_lab_table);

ALTER TABLE common_lookup_lab
ADD CONSTRAINT nn_common_lookup_lab_column NOT NULL (common_lookup_lab_column);

ALTER TABLE common_lookup_lab
ADD UNIQUE INDEX unique_month ( common_lookup_lab_table
, common_lookup_lab_column
, common_lookup_lab_type ) USING BTREE;

-- ----------------------------------------------------------------------
-- Verification on Step #4e
-- ----------------------------------------------------------------------
SET NULL ''
COLUMN table_name   FORMAT A14
COLUMN column_id    FORMAT 9999
COLUMN column_name  FORMAT A22
COLUMN data_type    FORMAT A12
SELECT   table_name
,        column_id
,        column_name
,        CASE
           WHEN nullable = 'N' THEN 'NOT NULL'
           ELSE ''
         END AS nullable
,        CASE
           WHEN data_type IN ('CHAR','VARCHAR2','NUMBER') THEN
             data_type||'('||data_length||')'
           ELSE
             data_type
         END AS data_type
FROM     user_tab_columns
WHERE    table_name = 'COMMON_LOOKUP_LAB'
ORDER BY 2;

COLUMN constraint_name   FORMAT A22  HEADING "Constraint Name"
COLUMN search_condition  FORMAT A36  HEADING "Search Condition" 
COLUMN constraint_type   FORMAT A10  HEADING "Constraint|Type"
SELECT   uc.constraint_name
,        uc.search_condition
,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
ON       uc.table_name = ucc.table_name
AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('common_lookup_lab')
AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
,        uc.constraint_name;

COLUMN sequence_name   FORMAT A22 HEADING "Sequence Name"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   UI.index_name
,        uic.column_position
,        uic.column_name
FROM     user_indexes UI INNER JOIN user_ind_columns uic
ON       UI.index_name = uic.index_name
AND      UI.table_name = uic.table_name
WHERE    UI.table_name = UPPER('common_lookup')
ORDER BY UI.index_name
,        uic.column_position;


-- ----------------------------------------------------------------------
-- Step #4f - copy the values of the correct COMMON_LOOKUP_ID column values
-- (the surrogate primary key column) into the TELEPHONE_TYPE column of the 
-- TELEPHONE table 
-- ----------------------------------------------------------------------

-- ----------------------------------------------------------------------
-- Verification on Step #4f
-- ----------------------------------------------------------------------
COLUMN common_lookup_table  FORMAT A14 HEADING "Common|Lookup Table"
COLUMN common_lookup_column FORMAT A14 HEADING "Common|Lookup Column"
COLUMN common_lookup_type   FORMAT A8  HEADING "Common|Lookup|Type"
COLUMN count_dependent      FORMAT 999 HEADING "Count of|Foreign|Keys"
COLUMN count_lookup         FORMAT 999 HEADING "Count of|Primary|Keys"
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(a.address_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     address a RIGHT JOIN common_lookup cl
ON       a.address_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'ADDRESS'
AND      cl.common_lookup_column = 'ADDRESS_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
UNION
SELECT   cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type
,        COUNT(t.telephone_id) AS count_dependent
,        COUNT(DISTINCT cl.common_lookup_table) AS count_lookup
FROM     telephone t RIGHT JOIN common_lookup cl
ON       t.telephone_type = cl.common_lookup_id
WHERE    cl.common_lookup_table = 'TELEPHONE'
AND      cl.common_lookup_column = 'TELEPHONE_TYPE'
AND      cl.common_lookup_type IN ('HOME','WORK')
GROUP BY cl.common_lookup_table
,        cl.common_lookup_column
,        cl.common_lookup_type;

SPOOL OFF