-- ------------------------------------------------------------------
--  Program Name:   seeding.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  30-Jan-2018
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  
-- ------------------------------------------------------------------
--  This seeds data in the video store model.
--   - Inserts the data in the rental table for 5 records and
--     then inserts 9 dependent records in a non-sequential 
--     order.
--   - A non-sequential order requires that you use subqueries
--     to discover the foreign key values for the inserts.
-- ------------------------------------------------------------------

@@group_account1.sql
@@group_account2.sql
@@group_account3.sql
@@item_inserts.sql
@@create_insert_contact_labs.sql
@@individual_accounts.sql
@@update_member_labs.sql
@@rental_inserts.sql
@@create_view.sql

SPOOL seeding2.txt

-- ------------------------------------------------------------------
--   Query to verify seven rows of chained inserts to the five
--   dependent tables.
-- ------------------------------------------------------------------
--    1. member_lab
--    2. contact_lab
--    3. address_lab
--    4. STREET_address_lab
--    5. telephone_lab
-- ------------------------------------------------------------------

COL member_lab_id       FORMAT 9999 HEADING "Acct|ID #"
COL account_number  FORMAT A10  HEADING "Account|Number"
COL full_name       FORMAT A16  HEADING "Name|(Last, First MI)"
COL city            FORMAT A12  HEADING "City"
COL state_province  FORMAT A10  HEADING "State"
COL telephone_lab       FORMAT A18  HEADING "telephone_lab"
SELECT   m.member_lab_id
,        m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' ' || SUBSTR(c.middle_name,1,1)
         END AS full_name
,        a.city
,        a.state_province
,        t.country_code || '-(' || t.area_code || ') ' || t.telephone_lab_number AS telephone_lab
FROM     member_lab m INNER JOIN contact_lab c ON m.member_lab_id = c.member_lab_id INNER JOIN
         address_lab a ON c.contact_lab_id = a.contact_lab_id INNER JOIN
         street_address_lab sa ON a.address_lab_id = sa.address_lab_id INNER JOIN
         telephone_lab t ON c.contact_lab_id = t.contact_lab_id AND a.address_lab_id = t.address_lab_id
WHERE    last_name IN ('Sweeney','Vizquel','Winn');

-- ------------------------------------------------------------------
--  Display the 21 inserts into the item table.
-- ------------------------------------------------------------------
SET PAGESIZE 99
COL item_id                FORMAT 9999  HEADING "Item|ID #"
COL common_lookup_lab_meaning  FORMAT A20  HEADING "Item Description"
COL item_title             FORMAT A30  HEADING "Item Title"
COL item_release_date      FORMAT A11  HEADING "Item|Release|Date"
SELECT   i.item_id
,        cl.common_lookup_lab_meaning
,        i.item_title
,        i.item_release_date
FROM     item i INNER JOIN common_lookup_lab cl ON i.item_type = cl.common_lookup_lab_id;

-- ------------------------------------------------------------------
--   Query to verify five individual rows of chained inserts through
--   a procedure into the five dependent tables.
-- ------------------------------------------------------------------
COL account_number  FORMAT A10  HEADING "Account|Number"
COL full_name       FORMAT A20  HEADING "Name|(Last, First MI)"
COL city            FORMAT A12  HEADING "City"
COL state_province  FORMAT A10  HEADING "State"
COL telephone_lab       FORMAT A18  HEADING "telephone_lab"
SELECT   m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' ' || SUBSTR(c.middle_name,1,1)
         END AS full_name
,        a.city
,        a.state_province
,        t.country_code || '-(' || t.area_code || ') ' || t.telephone_lab_number AS telephone_lab
FROM     member_lab m INNER JOIN contact_lab c ON m.member_lab_id = c.member_lab_id INNER JOIN
         address_lab a ON c.contact_lab_id = a.contact_lab_id INNER JOIN
         street_address_lab sa ON a.address_lab_id = sa.address_lab_id INNER JOIN
         telephone_lab t ON c.contact_lab_id = t.contact_lab_id AND a.address_lab_id = t.address_lab_id
WHERE    m.member_lab_type = (SELECT common_lookup_lab_id
                          FROM   common_lookup_lab
                          WHERE  common_lookup_lab_context = 'member_lab'
                          AND    common_lookup_lab_type = 'INDIVIDUAL');

-- ------------------------------------------------------------------
--   Query to verify nine rental agreements, some with one and some
--   with more than one rental item.
-- ------------------------------------------------------------------
COL member_lab_id       FORMAT 9999 HEADING "member_lab|ID #"
COL account_number  FORMAT A10  HEADING "Account|Number"
COL full_name       FORMAT A20  HEADING "Name|(Last, First MI)"
COL rental_id       FORMAT 9999 HEADING "Rent|ID #"
COL rental_item_id  FORMAT 9999 HEADING "Rent|Item|ID #"
COL item_title      FORMAT A26  HEADING "Item Title"
SELECT   m.member_lab_id
,        m.account_number
,        c.last_name || ', ' || c.first_name
||       CASE
           WHEN c.middle_name IS NOT NULL THEN ' ' || SUBSTR(c.middle_name,1,1)
         END AS full_name
,        r.rental_id
,        ri.rental_item_id
,        i.item_title
FROM     member_lab m INNER JOIN contact_lab c ON m.member_lab_id = c.member_lab_id INNER JOIN
         rental r ON c.contact_lab_id = r.customer_id INNER JOIN
         rental_item ri ON r.rental_id = ri.rental_id INNER JOIN
         item i ON ri.item_id = i.item_id
ORDER BY r.rental_id;

SPOOL OFF

