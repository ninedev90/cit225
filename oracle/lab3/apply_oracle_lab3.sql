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
--   sql> @apply_oracle_lab3.sql
--
-- ----------------------------------------------------------------------

-- Add your lab here:
-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab2/apply_oracle_lab2.sql
@/home/student/Data/cit225/oracle/lib2/preseed/preseed_oracle_store.sql

-- Open log file.
SPOOL apply_oracle_lab3.txt
-- Set the page size.
SET ECHO ON
SET PAGESIZE 999
-- ----------------------------------------------------------------------
-- Step #0 : CALL updated preseed script that has _lab corrections in it
-- ----------------------------------------------------------------------
SELECT 'Step #0 Call updated preseed script that has _lab corrections in it' 
AS "Step Number" FROM dual;

-- ----------------------------------------------------------------------
-- Objective #1: Setup preseed for _LAB tables 
-- ----------------------------------------------------------------------
@/home/student/Data/cit225/oracle/lab3/preseed_oracle_store_lab_tables.sql

spool off

-- ----------------------------------------------------------------------

