-- ------------------------------------------------------------------
--  Program Name:   apply_oracle_lab4.sql
--  Lab Assignment: N/A
--  Program Author: Tony Moraes
--  Creation Date:  25-May-2018
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
--   sql> @apply_oracle_lab4.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab3/apply_oracle_lab3.sql
 
-- insert calls to other SQL script files here, in the order that they appear in the seeding.sql script ...
@@group_account1_lab.sql
@@group_account2.sql
@@group_account3.sql
@@item_inserts.sql
@@create_insert_contacts.sql
@@individual_accounts.sql
@@update_members.sql
@@rental_inserts.sql
@@create_view.sql
 
SPOOL apply_oracle_lab4.txt
 
-- insert your SQL statements here ... 
-- start with the validation scripts you find in the seeding.sql script.
-- copying the seeding.sql file and editing it to conform to this layout is the simplest approach to the lab. 
-- ------------------------------------------------------------------
--   Query to verify seven rows of chained inserts to the five
--   dependent tables.
-- ------------------------------------------------------------------
--    1. MEMBER
--    2. CONTACT
--    3. ADDRESS
--    4. STREET_ADDRESS
--    5. TELEPHONE
-- ------------------------------------------------------------------

COL member_id       FORMAT 9999 HEADING "Acct|ID #"
COL account_number  FORMAT A10  HEADING "Account|Number"
COL full_name       FORMAT A16  HEADING "Name|(Last, First MI)"
COL city            FORMAT A12  HEADING "City"
COL state_province  FORMAT A10  HEADING "State"
COL telephone       FORMAT A18  HEADING "Telephone"
SELECT   m.member_id
,        m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' ' || SUBSTR(c.middle_name,1,1)
         END AS full_name
,        a.city
,        a.state_province
,        t.country_code || '-(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM     member m INNER JOIN contact c ON m.member_id = c.member_id INNER JOIN
         address a ON c.contact_id = a.contact_id INNER JOIN
         street_address sa ON a.address_id = sa.address_id INNER JOIN
         telephone t ON c.contact_id = t.contact_id AND a.address_id = t.address_id
WHERE    last_name IN ('Sweeney','Vizquel','Winn');

-- ------------------------------------------------------------------
--  Display the 21 inserts into the item table.
-- ------------------------------------------------------------------
SET PAGESIZE 99
COL item_id                FORMAT 9999  HEADING "Item|ID #"
COL common_lookup_meaning  FORMAT A20  HEADING "Item Description"
COL item_title             FORMAT A30  HEADING "Item Title"
COL item_release_date      FORMAT A11  HEADING "Item|Release|Date"
SELECT   i.item_id
,        cl.common_lookup_meaning
,        i.item_title
,        i.item_release_date
FROM     item i INNER JOIN common_lookup cl ON i.item_type = cl.common_lookup_id;

-- ------------------------------------------------------------------
--   Query to verify five individual rows of chained inserts through
--   a procedure into the five dependent tables.
-- ------------------------------------------------------------------
COL account_number  FORMAT A10  HEADING "Account|Number"
COL full_name       FORMAT A20  HEADING "Name|(Last, First MI)"
COL city            FORMAT A12  HEADING "City"
COL state_province  FORMAT A10  HEADING "State"
COL telephone       FORMAT A18  HEADING "Telephone"
SELECT   m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' ' || SUBSTR(c.middle_name,1,1)
         END AS full_name
,        a.city
,        a.state_province
,        t.country_code || '-(' || t.area_code || ') ' || t.telephone_number AS telephone
FROM     member m INNER JOIN contact c ON m.member_id = c.member_id INNER JOIN
         address a ON c.contact_id = a.contact_id INNER JOIN
         street_address sa ON a.address_id = sa.address_id INNER JOIN
         telephone t ON c.contact_id = t.contact_id AND a.address_id = t.address_id
WHERE    m.member_type = (SELECT common_lookup_id
                          FROM   common_lookup
                          WHERE  common_lookup_context = 'MEMBER'
                          AND    common_lookup_type = 'INDIVIDUAL');

-- ------------------------------------------------------------------
--   Query to verify nine rental agreements, some with one and some
--   with more than one rental item.
-- ------------------------------------------------------------------
COL member_id       FORMAT 9999 HEADING "Member|ID #"
COL account_number  FORMAT A10  HEADING "Account|Number"
COL full_name       FORMAT A20  HEADING "Name|(Last, First MI)"
COL rental_id       FORMAT 9999 HEADING "Rent|ID #"
COL rental_item_id  FORMAT 9999 HEADING "Rent|Item|ID #"
COL item_title      FORMAT A26  HEADING "Item Title"
SELECT   m.member_id
,        m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' ' || SUBSTR(c.middle_name,1,1)
         END AS full_name
,        r.rental_id
,        ri.rental_item_id
,        i.item_title
FROM     member m INNER JOIN contact c ON m.member_id = c.member_id INNER JOIN
         rental r ON c.contact_id = r.customer_id INNER JOIN
         rental_item ri ON r.rental_id = ri.rental_id INNER JOIN
         item i ON ri.item_id = i.item_id
ORDER BY r.rental_id;
 
SPOOL OFF
 
-- ------------------------------------------------------------------
--  This is necessary to avoid a resource busy error. You can
--  inadvertently create a resource busy error when testing in two
--  concurrent SQL*Plus sessions unless you provide an explicit
--  COMMIT; statement. 
-- ------------------------------------------------------------------
COMMIT;
