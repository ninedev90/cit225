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
--   sql> @apply_oracle_lab2.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit225/oracle/lib/create_oracle_store.sql

-- Add your lab here:
-- ----------------------------------------------------------------------

-- Open log file.
SPOOL apply_oracle_lab2.log

-- Set SQL*Plus environmnet variables.
SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON SIZE UNLIMITED

-- ------------------------------------------------------------------
--  Create and assign bind variable for table name.
-- ------------------------------------------------------------------
VARIABLE table_name VARCHAR2(30)

BEGIN
:table_name := UPPER('system_user_lab');
END;
/

--  Verify table name.
SELECT :table_name FROM dual;

-- ------------------------------------------------------------------
--  Conditionally drop table.
-- ------------------------------------------------------------------
DECLARE
/* Dynamic cursor. */
CURSOR c (cv_object_name VARCHAR2) IS
SELECT o.object_type
  ,      o.object_name
FROM   user_objects o
WHERE  o.object_name LIKE UPPER(cv_object_name||'%');
BEGIN
  FOR i IN c(:table_name) LOOP
    IF i.object_type = 'SEQUENCE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name;
    ELSIF i.object_type = 'TABLE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name||' CASCADE CONSTRAINTS';
    END IF;
END LOOP;
END;
/

-- Create table.
CREATE TABLE system_user_lab
( system_user_lab_id              NUMBER
  , system_user_lab_name            VARCHAR2(20) CONSTRAINT nn_system_user_lab_1 NOT NULL
  , system_user_lab_group_id        NUMBER       CONSTRAINT nn_system_user_lab_2 NOT NULL
  , system_user_lab_type            NUMBER       CONSTRAINT nn_system_user_lab_3 NOT NULL
  , first_name                  VARCHAR2(20)
  , middle_name                 VARCHAR2(20)
  , last_name                   VARCHAR2(20)
  , created_by                  NUMBER       CONSTRAINT nn_system_user_lab_4 NOT NULL
  , creation_date               DATE         CONSTRAINT nn_system_user_lab_5 NOT NULL
  , last_updated_by             NUMBER       CONSTRAINT nn_system_user_lab_6 NOT NULL
  , last_update_date            DATE         CONSTRAINT nn_system_user_lab_7 NOT NULL
  , CONSTRAINT pk_system_user_lab_1 PRIMARY KEY(system_user_lab_id)
  , CONSTRAINT fk_system_user_lab_1 FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
  , CONSTRAINT fk_system_user_lab_2 FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));

-- Display the table organization.
SET NULL ''
COLUMN table_name   FORMAT A16
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
WHERE    table_name = 'SYSTEM_USER_LAB'
ORDER BY 2;

-- Display non-unique constraints.
COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
  ,        uc.search_condition
  ,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
    ON       uc.table_name = ucc.table_name
             AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('system_user_lab')
         AND      uc.constraint_type = UPPER('c')
ORDER BY uc.constraint_name;

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
         ||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
  ,       'REFERENCES'||CHR(10)
          ||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
  ,        user_cons_columns ucc1
  ,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
         AND      uc.r_constraint_name = ucc2.constraint_name
         AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
         AND      uc.constraint_type = 'R'
         AND      ucc1.table_name = 'SYSTEM_USER_LAB'
ORDER BY ucc1.table_name
  ,        uc.constraint_name;

-- Create unique index.
CREATE UNIQUE INDEX uq_system_user_lab_1
  ON system_user_lab (system_user_lab_name);

-- Display unique indexes.
COLUMN index_name FORMAT A20 HEADING "Index Name"
SELECT   index_name
FROM     user_indexes
WHERE    TABLE_NAME = UPPER('system_user_lab');

-- Create sequence.
CREATE SEQUENCE system_user_lab_s1 START WITH 1001 NOCACHE;

-- Display sequence.
COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = UPPER('system_user_lab_s1');

-- ------------------------------------------------------------------
-- Create COMMON_LOOKUP_LAB table and sequence and seed data.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'COMMON_LOOKUP_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE common_lookup_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'COMMON_LOOKUP_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE common_lookup_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE common_lookup_lab
( common_lookup_lab_id            NUMBER
  , common_lookup_lab_context       VARCHAR2(30) CONSTRAINT nn_clookup_lab_1 NOT NULL
  , common_lookup_lab_type          VARCHAR2(30) CONSTRAINT nn_clookup_lab_2 NOT NULL
  , common_lookup_lab_meaning       VARCHAR2(30) CONSTRAINT nn_clookup_lab_3 NOT NULL
  , created_by                  NUMBER       CONSTRAINT nn_clookup_lab_4 NOT NULL
  , creation_date               DATE         CONSTRAINT nn_clookup_lab_5 NOT NULL
  , last_updated_by             NUMBER       CONSTRAINT nn_clookup_lab_6 NOT NULL
  , last_update_date            DATE         CONSTRAINT nn_clookup_lab_7 NOT NULL
  , CONSTRAINT pk_clookup_lab_1    PRIMARY KEY(common_lookup_lab_id)
  , CONSTRAINT fk_clookup_lab_1    FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
  , CONSTRAINT fk_clookup_lab_2    FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));

-- Display the table organization.
SET NULL ''
COLUMN table_name   FORMAT A16
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

-- Display non-unique constraints.
COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
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

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
         ||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
  ,       'REFERENCES'||CHR(10)
          ||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
  ,        user_cons_columns ucc1
  ,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
         AND      uc.r_constraint_name = ucc2.constraint_name
         AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
         AND      uc.constraint_type = 'R'
         AND      ucc1.table_name = 'COMMON_LOOKUP_LAB'
ORDER BY ucc1.table_name
  ,        uc.constraint_name;

-- Create a non-unique index.
CREATE INDEX common_lookup_lab_n1
  ON common_lookup_lab(common_lookup_lab_context);

-- Create a unique index.
CREATE UNIQUE INDEX common_lookup_lab_u2
  ON common_lookup_lab(common_lookup_lab_context,common_lookup_lab_type);

-- Display unique and non-unique indexes.
COLUMN sequence_name   FORMAT A22 HEADING "Sequence Name"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   ui.index_name
  ,        uic.column_position
  ,        uic.column_name
FROM     user_indexes ui INNER JOIN user_ind_columns uic
    ON       ui.index_name = uic.index_name
             AND      ui.table_name = uic.table_name
WHERE    ui.table_name = UPPER('common_lookup_lab')
ORDER BY ui.index_name
  ,        uic.column_position;

-- Add a constraint to the SYSTEM_USER_LAB table dependent on the COMMON_LOOKUP_LAB table.
ALTER TABLE system_user_lab
  ADD CONSTRAINT fk_system_user_lab_3 FOREIGN KEY(system_user_lab_group_id)
REFERENCES common_lookup_lab(common_lookup_lab_id);

ALTER TABLE system_user_lab
  ADD CONSTRAINT fk_system_user_lab_4 FOREIGN KEY(system_user_lab_type)
REFERENCES common_lookup_lab(common_lookup_lab_id);

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
         ||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
  ,       'REFERENCES'||CHR(10)
          ||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
  ,        user_cons_columns ucc1
  ,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
         AND      uc.r_constraint_name = ucc2.constraint_name
         AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
         AND      uc.constraint_type = 'R'
         AND      ucc1.table_name = 'SYSTEM_USER_LAB'
ORDER BY ucc1.table_name
  ,        uc.constraint_name;

-- Create a sequence.
CREATE SEQUENCE common_lookup_lab_s1 START WITH 1001;

-- Display sequence.
COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = UPPER('common_lookup_lab_s1');

-- ------------------------------------------------------------------
-- Create MEMBER_LAB table and sequence and seed data.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'MEMBER_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE member_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'MEMBER_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE member_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE member_lab
( member_lab_id                   NUMBER
  , member_lab_type                 NUMBER
  , account_number              VARCHAR2(10) CONSTRAINT nn_member_lab_2 NOT NULL
  , credit_card_number          VARCHAR2(19) CONSTRAINT nn_member_lab_3 NOT NULL
  , credit_card_type            NUMBER       CONSTRAINT nn_member_lab_4 NOT NULL
  , created_by                  NUMBER       CONSTRAINT nn_member_lab_5 NOT NULL
  , creation_date               DATE         CONSTRAINT nn_member_lab_6 NOT NULL
  , last_updated_by             NUMBER       CONSTRAINT nn_member_lab_7 NOT NULL
  , last_update_date            DATE         CONSTRAINT nn_member_lab_8 NOT NULL
  , CONSTRAINT pk_member_lab_1      PRIMARY KEY(member_lab_id)
  , CONSTRAINT fk_member_lab_1      FOREIGN KEY(member_lab_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
  , CONSTRAINT fk_member_lab_2      FOREIGN KEY(credit_card_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
  , CONSTRAINT fk_member_lab_3      FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
  , CONSTRAINT fk_member_lab_4      FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));

-- Display the table organization.
SET NULL ''
COLUMN table_name   FORMAT A16
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
WHERE    table_name = 'MEMBER_LAB'
ORDER BY 2;

-- Display non-unique constraints.
COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
  ,        uc.search_condition
  ,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
    ON       uc.table_name = ucc.table_name
             AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('member_lab')
         AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
  ,        uc.constraint_name;

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
         ||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
  ,       'REFERENCES'||CHR(10)
          ||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
  ,        user_cons_columns ucc1
  ,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
         AND      uc.r_constraint_name = ucc2.constraint_name
         AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
         AND      uc.constraint_type = 'R'
         AND      ucc1.table_name = 'MEMBER_LAB'
ORDER BY ucc1.table_name
  ,        uc.constraint_name;

-- Create a non-unique index.
CREATE INDEX member_lab_n1 ON member_lab(credit_card_type);

-- Display the non-unique index.
COLUMN sequence_name   FORMAT A22 HEADING "Sequence Name"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   ui.index_name
  ,        uic.column_position
  ,        uic.column_name
FROM     user_indexes ui INNER JOIN user_ind_columns uic
    ON       ui.index_name = uic.index_name
             AND      ui.table_name = uic.table_name
WHERE    ui.table_name = UPPER('member_lab')
         AND NOT  ui.index_name IN (SELECT constraint_name
                                    FROM   user_constraints)
ORDER BY ui.index_name
  ,        uic.column_position;

-- Create a sequence.
CREATE SEQUENCE member_lab_s1 START WITH 1001 NOCACHE;

COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = UPPER('member_lab_s1');


-- ------------------------------------------------------------------
-- Create CONTACT_LAB table and sequence and seed data.
-- ------------------------------------------------------------------
-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'CONTACT_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE contact_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'CONTACT_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE contact_lab_s1';
  END LOOP;
END;
/
CREATE TABLE contact_lab
( contact_lab_id                  NUMBER
  , member_lab_id                   NUMBER       CONSTRAINT nn_contact_lab_1 NOT NULL
  , contact_lab_type                NUMBER       CONSTRAINT nn_contact_lab_2 NOT NULL
  , first_name                  VARCHAR2(20) CONSTRAINT nn_contact_lab_3 NOT NULL
  , middle_name                 VARCHAR2(20)
  , last_name                   VARCHAR2(20) CONSTRAINT nn_contact_lab_4 NOT NULL
  , created_by                  NUMBER       CONSTRAINT nn_contact_lab_5 NOT NULL
  , creation_date               DATE         CONSTRAINT nn_contact_lab_6 NOT NULL
  , last_updated_by             NUMBER       CONSTRAINT nn_contact_lab_7 NOT NULL
  , last_update_date            DATE         CONSTRAINT nn_contact_lab_8 NOT NULL
  , CONSTRAINT pk_contact_lab_1     PRIMARY KEY(contact_lab_id)
  , CONSTRAINT fk_contact_lab_1     FOREIGN KEY(member_lab_id) REFERENCES member_lab(member_lab_id)
  , CONSTRAINT fk_contact_lab_2     FOREIGN KEY(contact_lab_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
  , CONSTRAINT fk_contact_lab_3     FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
  , CONSTRAINT fk_contact_lab_4     FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));

-- Display the table organization.
SET NULL ''
COLUMN table_name   FORMAT A16
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
WHERE    table_name = 'CONTACT_LAB'
ORDER BY 2;

-- Display non-unique constraints.
COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
  ,        uc.search_condition
  ,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
    ON       uc.table_name = ucc.table_name
             AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('contact_lab')
         AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
  ,        uc.constraint_name;

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
         ||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
  ,       'REFERENCES'||CHR(10)
          ||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
  ,        user_cons_columns ucc1
  ,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
         AND      uc.r_constraint_name = ucc2.constraint_name
         AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
         AND      uc.constraint_type = 'R'
         AND      ucc1.table_name = 'CONTACT_LAB'
ORDER BY ucc1.table_name
  ,        uc.constraint_name;

-- Create non-unique indexes.
CREATE INDEX contact_lab_n1 ON contact_lab(member_lab_id);
CREATE INDEX contact_lab_n2 ON contact_lab(contact_lab_type);

-- Display the non-unique index.
COLUMN sequence_name   FORMAT A22 HEADING "Sequence Name"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   ui.index_name
  ,        uic.column_position
  ,        uic.column_name
FROM     user_indexes ui INNER JOIN user_ind_columns uic
    ON       ui.index_name = uic.index_name
             AND      ui.table_name = uic.table_name
WHERE    ui.table_name = UPPER('contact_lab')
         AND NOT  ui.index_name IN (SELECT constraint_name
                                    FROM   user_constraints)
ORDER BY ui.index_name
  ,        uic.column_position;

-- Create sequence.
CREATE SEQUENCE contact_lab_s1 START WITH 1001 NOCACHE;

-- Display sequence value.
COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = UPPER('contact_lab_s1');


-- ------------------------------------------------------------------
-- Create ADDRESS_LAB table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'ADDRESS_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE address_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'ADDRESS_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE address_lab_s1';
  END LOOP;
END;
/

-- create table
CREATE TABLE address_lab
( address_lab_id                  NUMBER
  , contact_lab_id                  NUMBER       CONSTRAINT nn_address_lab_1 NOT NULL
  , address_lab_type                NUMBER       CONSTRAINT nn_address_lab_2 NOT NULL
  , city                        VARCHAR2(30) CONSTRAINT nn_address_lab_3 NOT NULL
  , state_province              VARCHAR2(30) CONSTRAINT nn_address_lab_4 NOT NULL
  , postal_code                 VARCHAR2(20) CONSTRAINT nn_address_lab_5 NOT NULL
  , created_by                  NUMBER       CONSTRAINT nn_address_lab_6 NOT NULL
  , creation_date               DATE         CONSTRAINT nn_address_lab_7 NOT NULL
  , last_updated_by             NUMBER       CONSTRAINT nn_address_lab_8 NOT NULL
  , last_update_date            DATE         CONSTRAINT nn_address_lab_9 NOT NULL
  , CONSTRAINT pk_address_lab_1     PRIMARY KEY(address_lab_id)
  , CONSTRAINT fk_address_lab_1     FOREIGN KEY(contact_lab_id) REFERENCES contact_lab(contact_lab_id)
  , CONSTRAINT fk_address_lab_2     FOREIGN KEY(address_lab_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
  , CONSTRAINT fk_address_lab_3     FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
  , CONSTRAINT fk_address_lab_4     FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));


-- Display the table organization.
SET NULL ''
COLUMN table_name   FORMAT A16
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
WHERE    table_name = 'ADDRESS_LAB'
ORDER BY 2;

-- Display non-unique constraints.
COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
  ,        uc.search_condition
  ,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
    ON       uc.table_name = ucc.table_name
             AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('address_lab')
         AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
  ,        uc.constraint_name;

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
         ||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
  ,       'REFERENCES'||CHR(10)
          ||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
  ,        user_cons_columns ucc1
  ,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
         AND      uc.r_constraint_name = ucc2.constraint_name
         AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
         AND      uc.constraint_type = 'R'
         AND      ucc1.table_name = 'ADDRESS_LAB'
ORDER BY ucc1.table_name
  ,        uc.constraint_name;

-- Create a non-unique index.
CREATE INDEX address_lab_n1 ON address_lab(contact_lab_id);
CREATE INDEX address_lab_n2 ON address_lab(address_lab_type);

-- Display the non-unique index.
COLUMN sequence_name   FORMAT A22 HEADING "Sequence Name"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   ui.index_name
  ,        uic.column_position
  ,        uic.column_name
FROM     user_indexes ui INNER JOIN user_ind_columns uic
    ON       ui.index_name = uic.index_name
             AND      ui.table_name = uic.table_name
WHERE    ui.table_name = UPPER('address_lab')
         AND NOT  ui.index_name IN (SELECT constraint_name
                                    FROM   user_constraints)
ORDER BY ui.index_name
  ,        uic.column_position;

-- Create a sequence.
CREATE SEQUENCE address_lab_s1 START WITH 1001 NOCACHE;

-- Display sequence value.
COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = UPPER('address_lab_s1');

-- ------------------------------------------------------------------
-- Create STREET_ADDRESS_LAB table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'STREET_ADDRESS_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE street_address_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'STREET_ADDRESS_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE street_address_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE street_address_lab
( street_address_lab_id           NUMBER
  , address_lab_id                  NUMBER       CONSTRAINT nn_saddress_lab_1 NOT NULL
  , street_address_lab              VARCHAR2(30) CONSTRAINT nn_saddress_lab_2 NOT NULL
  , created_by                  NUMBER       CONSTRAINT nn_saddress_lab_3 NOT NULL
  , creation_date               DATE         CONSTRAINT nn_saddress_lab_4 NOT NULL
  , last_updated_by             NUMBER       CONSTRAINT nn_saddress_lab_5 NOT NULL
  , last_update_date            DATE         CONSTRAINT nn_saddress_lab_6 NOT NULL
  , CONSTRAINT pk_s_address_lab_1   PRIMARY KEY(street_address_lab_id)
  , CONSTRAINT fk_s_address_lab_1   FOREIGN KEY(address_lab_id) REFERENCES address_lab(address_lab_id)
  , CONSTRAINT fk_s_address_lab_3   FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
  , CONSTRAINT fk_s_address_lab_4   FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));

-- Display the table organization.
SET NULL ''
COLUMN table_name   FORMAT A16
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
WHERE    table_name = 'STREET_ADDRESS_LAB'
ORDER BY 2;

-- Display non-unique constraints.
COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
  ,        uc.search_condition
  ,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
    ON       uc.table_name = ucc.table_name
             AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('street_address_lab')
         AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
  ,        uc.constraint_name;

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
         ||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
  ,       'REFERENCES'||CHR(10)
          ||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
  ,        user_cons_columns ucc1
  ,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
         AND      uc.r_constraint_name = ucc2.constraint_name
         AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
         AND      uc.constraint_type = 'R'
         AND      ucc1.table_name = 'STREET_ADDRESS_LAB'
ORDER BY ucc1.table_name
  ,        uc.constraint_name;

-- Create sequence.
CREATE SEQUENCE street_address_lab_s1 START WITH 1001 NOCACHE;

-- Display sequence value.
COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = UPPER('street_address_lab_s1');

-- ------------------------------------------------------------------
-- Create TELEPHONE_LAB table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'TELEPHONE_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE telephone_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'TELEPHONE_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE telephone_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE telephone_lab
( telephone_lab_id                NUMBER
  , contact_lab_id                  NUMBER       CONSTRAINT nn_telephone_lab_1 NOT NULL
  , address_lab_id                  NUMBER
  , telephone_lab_type              NUMBER       CONSTRAINT nn_telephone_lab_2 NOT NULL
  , country_code                VARCHAR2(3)  CONSTRAINT nn_telephone_lab_3 NOT NULL
  , area_code                   VARCHAR2(6)  CONSTRAINT nn_telephone_lab_4 NOT NULL
  , telephone_lab_number            VARCHAR2(10) CONSTRAINT nn_telephone_lab_5 NOT NULL
  , created_by                  NUMBER       CONSTRAINT nn_telephone_lab_6 NOT NULL
  , creation_date               DATE         CONSTRAINT nn_telephone_lab_7 NOT NULL
  , last_updated_by             NUMBER       CONSTRAINT nn_telephone_lab_8 NOT NULL
  , last_update_date            DATE         CONSTRAINT nn_telephone_lab_9 NOT NULL
  , CONSTRAINT pk_telephone_lab_1   PRIMARY KEY(telephone_lab_id)
  , CONSTRAINT fk_telephone_lab_1   FOREIGN KEY(contact_lab_id) REFERENCES contact_lab(contact_lab_id)
  , CONSTRAINT fk_telephone_lab_2   FOREIGN KEY(telephone_lab_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
  , CONSTRAINT fk_telephone_lab_3   FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
  , CONSTRAINT fk_telephone_lab_4   FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));

-- Display the table organization.
SET NULL ''
COLUMN table_name   FORMAT A16
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
WHERE    table_name = 'TELEPHONE_LAB'
ORDER BY 2;

-- Display non-unique constraints.
COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
  ,        uc.search_condition
  ,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
    ON       uc.table_name = ucc.table_name
             AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('telephone_lab')
         AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
  ,        uc.constraint_name;

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
         ||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
  ,       'REFERENCES'||CHR(10)
          ||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
  ,        user_cons_columns ucc1
  ,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
         AND      uc.r_constraint_name = ucc2.constraint_name
         AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
         AND      uc.constraint_type = 'R'
         AND      ucc1.table_name = 'TELEPHONE_LAB'
ORDER BY ucc1.table_name
  ,        uc.constraint_name;

-- Create non-unique indexes.
CREATE INDEX telephone_lab_n1 ON telephone_lab(contact_lab_id,address_lab_id);
CREATE INDEX telephone_lab_n2 ON telephone_lab(address_lab_id);
CREATE INDEX telephone_lab_n3 ON telephone_lab(telephone_lab_type);

-- Display the non-unique index.
COLUMN sequence_name   FORMAT A22 HEADING "Sequence Name"
COLUMN column_position FORMAT 999 HEADING "Column|Position"
COLUMN column_name     FORMAT A22 HEADING "Column|Name"
SELECT   ui.index_name
  ,        uic.column_position
  ,        uic.column_name
FROM     user_indexes ui INNER JOIN user_ind_columns uic
    ON       ui.index_name = uic.index_name
             AND      ui.table_name = uic.table_name
WHERE    ui.table_name = UPPER('telephone_lab')
         AND NOT  ui.index_name IN (SELECT constraint_name
                                    FROM   user_constraints)
ORDER BY ui.index_name
  ,        uic.column_position;

-- Create sequence.
CREATE SEQUENCE telephone_lab_s1 START WITH 1001 NOCACHE;

-- Display sequence value.
COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = UPPER('telephone_lab_s1');

-- ------------------------------------------------------------------
-- Create RENTAL_LAB table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'RENTAL_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE rental_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'RENTAL_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE rental_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE rental_lab
( rental_lab_id                   NUMBER
  , customer_id                 NUMBER CONSTRAINT nn_rental_lab_1 NOT NULL
  , check_out_date              DATE   CONSTRAINT nn_rental_lab_2 NOT NULL
  , return_date                 DATE   CONSTRAINT nn_rental_lab_3 NOT NULL
  , created_by                  NUMBER CONSTRAINT nn_rental_lab_4 NOT NULL
  , creation_date               DATE   CONSTRAINT nn_rental_lab_5 NOT NULL
  , last_updated_by             NUMBER CONSTRAINT nn_rental_lab_6 NOT NULL
  , last_update_date            DATE   CONSTRAINT nn_rental_lab_7 NOT NULL
  , CONSTRAINT pk_rental_lab_1      PRIMARY KEY(rental_lab_id)
  , CONSTRAINT fk_rental_lab_1      FOREIGN KEY(customer_id) REFERENCES contact_lab(contact_lab_id)
  , CONSTRAINT fk_rental_lab_2      FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
  , CONSTRAINT fk_rental_lab_3      FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));

-- Display the table organization.
SET NULL ''
COLUMN table_name   FORMAT A16
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
WHERE    table_name = 'RENTAL_LAB'
ORDER BY 2;

-- Display non-unique constraints.
COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
  ,        uc.search_condition
  ,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
    ON       uc.table_name = ucc.table_name
             AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('rental_lab')
         AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
  ,        uc.constraint_name;

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
         ||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
  ,       'REFERENCES'||CHR(10)
          ||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
  ,        user_cons_columns ucc1
  ,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
         AND      uc.r_constraint_name = ucc2.constraint_name
         AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
         AND      uc.constraint_type = 'R'
         AND      ucc1.table_name = 'RENTAL_LAB'
ORDER BY ucc1.table_name
  ,        uc.constraint_name;

-- Create a sequence.
CREATE SEQUENCE rental_lab_s1 START WITH 1001 NOCACHE;

-- Display sequence value.
COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = UPPER('rental_lab_s1');

-- ------------------------------------------------------------------
-- Create ITEM_LAB table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop objects.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'ITEM_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE item_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'ITEM_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE item_lab_s1';
  END LOOP;
END;
/

-- Create a table.
CREATE TABLE item_lab
( item_lab_id                     NUMBER
  , item_lab_barcode                VARCHAR2(14) CONSTRAINT nn_item_lab_1 NOT NULL
  , item_lab_type                   NUMBER       CONSTRAINT nn_item_lab_2 NOT NULL
  , item_lab_title                  VARCHAR2(60) CONSTRAINT nn_item_lab_3 NOT NULL
  , item_lab_subtitle               VARCHAR2(60)
  , item_lab_rating                 VARCHAR2(8)  CONSTRAINT nn_item_lab_4 NOT NULL
  , item_lab_release_date           DATE         CONSTRAINT nn_item_lab_5 NOT NULL
  , created_by                  NUMBER       CONSTRAINT nn_item_lab_6 NOT NULL
  , creation_date               DATE         CONSTRAINT nn_item_lab_7 NOT NULL
  , last_updated_by             NUMBER       CONSTRAINT nn_item_lab_8 NOT NULL
  , last_update_date            DATE         CONSTRAINT nn_item_lab_9 NOT NULL
  , CONSTRAINT pk_item_lab_1        PRIMARY KEY(item_lab_id)
  , CONSTRAINT fk_item_lab_1        FOREIGN KEY(item_lab_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
  , CONSTRAINT fk_item_lab_2        FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
  , CONSTRAINT fk_item_lab_3        FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));

-- Display the table organization.
SET NULL ''
COLUMN table_name   FORMAT A16
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

-- Display non-unique constraints.
COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
  ,        uc.search_condition
  ,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
    ON       uc.table_name = ucc.table_name
             AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('item_lab')
         AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
  ,        uc.constraint_name;

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
         ||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
  ,       'REFERENCES'||CHR(10)
          ||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
  ,        user_cons_columns ucc1
  ,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
         AND      uc.r_constraint_name = ucc2.constraint_name
         AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
         AND      uc.constraint_type = 'R'
         AND      ucc1.table_name = 'ITEM_LAB'
ORDER BY ucc1.table_name
  ,        uc.constraint_name;

-- Create a sequence.
CREATE SEQUENCE item_lab_s1 START WITH 1001 NOCACHE;

-- Display sequence value.
COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = UPPER('item_lab_s1');

-- ------------------------------------------------------------------
-- Create RENTAL_ITEM_LAB table and sequence.
-- ------------------------------------------------------------------
-- Conditionally drop table and sequence.
BEGIN
  FOR i IN (SELECT null FROM user_tables WHERE table_name = 'RENTAL_ITEM_LAB') LOOP
    EXECUTE IMMEDIATE 'DROP TABLE rental_item_lab CASCADE CONSTRAINTS';
  END LOOP;
  FOR i IN (SELECT null FROM user_sequences WHERE sequence_name = 'RENTAL_ITEM_LAB_S1') LOOP
    EXECUTE IMMEDIATE 'DROP SEQUENCE rental_item_lab_s1';
  END LOOP;
END;
/

-- Create table.
CREATE TABLE rental_item_lab
( rental_item_lab_id              NUMBER
  , rental_lab_id                   NUMBER CONSTRAINT nn_rental_item_lab_1 NOT NULL
  , item_lab_id                     NUMBER CONSTRAINT nn_rental_item_lab_2 NOT NULL
  , created_by                  NUMBER CONSTRAINT nn_rental_item_lab_3 NOT NULL
  , creation_date               DATE   CONSTRAINT nn_rental_item_lab_4 NOT NULL
  , last_updated_by             NUMBER CONSTRAINT nn_rental_item_lab_5 NOT NULL
  , last_update_date            DATE   CONSTRAINT nn_rental_item_lab_6 NOT NULL
  , CONSTRAINT pk_rental_item_lab_1 PRIMARY KEY(rental_item_lab_id)
  , CONSTRAINT fk_rental_item_lab_1 FOREIGN KEY(rental_lab_id) REFERENCES rental_lab(rental_lab_id)
  , CONSTRAINT fk_rental_item_lab_2 FOREIGN KEY(item_lab_id) REFERENCES item_lab(item_lab_id)
  , CONSTRAINT fk_rental_item_lab_3 FOREIGN KEY(created_by) REFERENCES system_user_lab(system_user_lab_id)
  , CONSTRAINT fk_rental_item_lab_4 FOREIGN KEY(last_updated_by) REFERENCES system_user_lab(system_user_lab_id));

-- Display the table organization.
SET NULL ''
COLUMN table_name   FORMAT A16
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

-- Display non-unique constraints.
COLUMN constraint_name   FORMAT A22
COLUMN search_condition  FORMAT A36
COLUMN constraint_type   FORMAT A1
SELECT   uc.constraint_name
  ,        uc.search_condition
  ,        uc.constraint_type
FROM     user_constraints uc INNER JOIN user_cons_columns ucc
    ON       uc.table_name = ucc.table_name
             AND      uc.constraint_name = ucc.constraint_name
WHERE    uc.table_name = UPPER('rental_item_lab')
         AND      uc.constraint_type IN (UPPER('c'),UPPER('p'))
ORDER BY uc.constraint_type DESC
  ,        uc.constraint_name;

-- Display foreign key constraints.
COL constraint_source FORMAT A38 HEADING "Constraint Name:| Table.Column"
COL references_column FORMAT A40 HEADING "References:| Table.Column"
SELECT   uc.constraint_name||CHR(10)
         ||      '('||ucc1.table_name||'.'||ucc1.column_name||')' constraint_source
  ,       'REFERENCES'||CHR(10)
          ||      '('||ucc2.table_name||'.'||ucc2.column_name||')' references_column
FROM     user_constraints uc
  ,        user_cons_columns ucc1
  ,        user_cons_columns ucc2
WHERE    uc.constraint_name = ucc1.constraint_name
         AND      uc.r_constraint_name = ucc2.constraint_name
         AND      ucc1.position = ucc2.position -- Correction for multiple column primary keys.
         AND      uc.constraint_type = 'R'
         AND      ucc1.table_name = 'RENTAL_LAB_ITEM_LAB'
ORDER BY ucc1.table_name
  ,        uc.constraint_name;

-- Create a sequence.
CREATE SEQUENCE rental_item_lab_s1 START WITH 1001 NOCACHE;

-- Display sequence value.
COLUMN sequence_name FORMAT A20 HEADING "Sequence Name"
SELECT   sequence_name
FROM     user_sequences
WHERE    sequence_name = UPPER('rental_item_lab_s1');

-- CONFIRMATION DETAIL TABLES
COLUMN table_name_base FORMAT A30 HEADING "Base Tables"
COLUMN table_name_lab  FORMAT A30 HEADING "Lab Tables"
SELECT   a.table_name_base
,        b.table_name_lab
FROM    (SELECT   table_name AS table_name_base
         FROM     user_tables
         WHERE    table_name IN ('SYSTEM_USER'
                                ,'COMMON_LOOKUP'
                                ,'MEMBER'
                                ,'CONTACT'
                                ,'ADDRESS'
                                ,'STREET_ADDRESS'
                                ,'TELEPHONE'
                                ,'ITEM'
                                ,'RENTAL'
                                ,'RENTAL_ITEM')) a INNER JOIN
        (SELECT   table_name AS table_name_lab
         FROM     user_tables
         WHERE    table_name IN ('SYSTEM_USER_LAB'
                                ,'COMMON_LOOKUP_LAB'
                                ,'MEMBER_LAB'
                                ,'CONTACT_LAB'
                                ,'ADDRESS_LAB'
                                ,'STREET_ADDRESS_LAB'
                                ,'TELEPHONE_LAB'
                                ,'ITEM_LAB'
                                ,'RENTAL_LAB'
                                ,'RENTAL_ITEM_LAB')) b
ON       a.table_name_base = SUBSTR( b.table_name_lab, 1, REGEXP_INSTR(table_name_lab,'_LAB') - 1)
ORDER BY CASE
           WHEN table_name_base LIKE 'SYSTEM_USER%' THEN 0
           WHEN table_name_base LIKE 'COMMON_LOOKUP%' THEN 1
           WHEN table_name_base LIKE 'MEMBER%' THEN 2
           WHEN table_name_base LIKE 'CONTACT%' THEN 3
           WHEN table_name_base LIKE 'ADDRESS%' THEN 4
           WHEN table_name_base LIKE 'STREET_ADDRESS%' THEN 5
           WHEN table_name_base LIKE 'TELEPHONE%' THEN 6
           WHEN table_name_base LIKE 'ITEM%' THEN 7
           WHEN table_name_base LIKE 'RENTAL%' AND NOT table_name_base LIKE 'RENTAL_ITEM%' THEN 8
           WHEN table_name_base LIKE 'RENTAL_ITEM%' THEN 9
         END;

-- CONFIRMATION DETAILS SEQUENCES
COLUMN sequence_name_base FORMAT A30 HEADING "Base Sequences"
COLUMN sequence_name_lab  FORMAT A30 HEADING "Lab Sequences"
SELECT   a.sequence_name_base
,        b.sequence_name_lab
FROM    (SELECT   sequence_name AS sequence_name_base
         FROM     user_sequences
         WHERE    sequence_name IN ('SYSTEM_USER_S1'
                                   ,'COMMON_LOOKUP_S1'
                                   ,'MEMBER_S1'
                                   ,'CONTACT_S1'
                                   ,'ADDRESS_S1'
                                   ,'STREET_ADDRESS_S1'
                                   ,'TELEPHONE_S1'
                                   ,'ITEM_S1'
                                   ,'RENTAL_S1'
                                   ,'RENTAL_ITEM_S1')) a INNER JOIN
        (SELECT   sequence_name AS sequence_name_lab
         FROM     user_sequences
         WHERE    sequence_name IN ('SYSTEM_USER_LAB_S1'
                                   ,'COMMON_LOOKUP_LAB_S1'
                                   ,'MEMBER_LAB_S1'
                                   ,'CONTACT_LAB_S1'
                                   ,'ADDRESS_LAB_S1'
                                   ,'STREET_ADDRESS_LAB_S1'
                                   ,'TELEPHONE_LAB_S1'
                                   ,'ITEM_LAB_S1'
                                   ,'RENTAL_LAB_S1'
                                   ,'RENTAL_ITEM_LAB_S1')) b
ON       SUBSTR(a.sequence_name_base, 1, REGEXP_INSTR(a.sequence_name_base,'_S1') - 1) =
           SUBSTR( b.sequence_name_lab, 1, REGEXP_INSTR(b.sequence_name_lab,'_LAB_S1') - 1)
ORDER BY CASE
           WHEN sequence_name_base LIKE 'SYSTEM_USER%' THEN 0
           WHEN sequence_name_base LIKE 'COMMON_LOOKUP%' THEN 1
           WHEN sequence_name_base LIKE 'MEMBER%' THEN 2
           WHEN sequence_name_base LIKE 'CONTACT%' THEN 3
           WHEN sequence_name_base LIKE 'ADDRESS%' THEN 4
           WHEN sequence_name_base LIKE 'STREET_ADDRESS%' THEN 5
           WHEN sequence_name_base LIKE 'TELEPHONE%' THEN 6
           WHEN sequence_name_base LIKE 'ITEM%' THEN 7
           WHEN sequence_name_base LIKE 'RENTAL%' AND NOT sequence_name_base LIKE 'RENTAL_ITEM%' THEN 8
           WHEN sequence_name_base LIKE 'RENTAL_ITEM%' THEN 9
         END;

-- Close log file.
SPOOL OFF
