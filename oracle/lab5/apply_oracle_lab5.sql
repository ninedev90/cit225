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
--   sql> @apply_oracle_lab5.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab4/apply_oracle_lab4.sql

-- Add your lab here:
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lib/cleanup_oracle.sql
@/home/student/Data/cit225/oracle/lib2/create/create_oracle_store2.sql
@/home/student/Data/cit225/oracle/lib2/preseed/preseed_oracle_store.sql
@/home/student/Data/cit225/oracle/lib2/seed/seeding.sql
 
SPOOL apply_oracle_lab5.txt
 
 /*-------------------------------------------------------------------------
  1 [16 points] Write INNER JOIN queries that use the USING subclause 
    and return the following results:

  a.  Display the MEMBER_ID and CONTACT_ID in the SELECT clause from a join
      of the MEMBER and CONTACT tables. You should make the join with the
      USING subclause based on the MEMBER_ID column, which is the 
      primary and foreign key of the respective tables. 
*/
SELECT m.member_id, c.contact_id
FROM member as m 
INNER JOIN contact as c USING(member_id);

/**
b. Display the MEMBER_ID and CONTACT_ID in the SELECT clause from a join of the 
MEMBER and CONTACT tables. You should put the join in the WHERE clause and base 
the join on the MEMBER_ID column, which is the primary and foreign key of the
respective tables.
*/
SELECT m.member_id, c.contact_id
FROM member as m, contact as c
WHERE m.member_id = c.member_id;

/*
c. Display the CONTACT_ID and ADDRESS_ID in the SELECT clause from a join of the 
CONTACT and ADDRESS tables. You should put the join in the WHERE clause and base
the join on the CONTACT_ID column, which is the primary and foreign key of the
respective tables.
*/
SELECT c.contact_id, a.address_id
FROM contact as c
INNER JOIN adress as a USING(contact_id);

/*
d. Display the CONTACT_ID and ADDRESS_ID in the SELECT clause from a join of the 
CONTACT and ADDRESS tables. You should put the join in the WHERE clause and base
the join on the CONTACT_ID column, which is the primary and foreign key of the
respective tables.
*/
SELECT c.contact_id, a.address_id
FROM contact as c, adress as a
where c.contact_id = a.contact.id;

/*
e. Display the ADDRESS_ID and STREET_ADDRESS_ID in the SELECT clause from a join 
of the ADDRESS and STREET_ADDRESS tables. You should make the join between the 
tables with the USING subclause based on the ADDRESS_ID column, which is the 
primary and foreign key of the respective tables.
*/
 
 SELECT a.address_id, s.street_address_id
 FROM adress as a 
 INNER JOIN street_address as s USING (address_id);

 /*
 f. Display the ADDRESS_ID and STREET_ADDRESS_ID in the SELECT clause from a join 
 of the ADDRESS and STREET_ADDRESS tables. You should put the join in the WHERE 
 clause and base the join on the ADDRESS_ID column, which is the primary and 
 foreign key of the respective tables.
 */
 SELECT a.address_id, s.street_address_id
 FROM adress as a, street_address as s
 WHERE s.address_id = a.address_id;

 /**
 g. Display the CONTACT_ID and TELEPHONE_ID in the SELECT clause from a join of 
 the CONTACT and TELEPHONE tables. You should make the join between the tables 
 with the USING subclause based on the CONTACT_ID column, which is the primary 
 and foreign key of the respect tables.
 */
SELECT c.contact_id, t.telephone_id
FROM contact as id
INNER JOIN telephone as t USING(contat_id);
 /*
 h.Display the CONTACT_ID and TELEPHONE_ID in the SELECT clause from a join of 
 the CONTACT and TELEPHONE tables. You should put the join in the WHERE clause 
 and base the join on the CONTACT_ID column, which is the primary and foreign 
 key of the respective tables.
 */
 SELECT c.contact_id, t.telephone_id
 FROM contact as id, telephone as t 
 WHERE c.contat_id = t.contat_id;

---------------------------------------------------------------------------------------------
 --2. [8 points] Write INNER JOIN queries that use the ON subclause and return the following results:

 /*
 a. [2 points]Display the SYSTEM_USER_ID and CREATED_BY columns from one row, 
 and the SYSTEM_USER_ID column from a row where it is also the primary key. 
 You should make the join with the ON subclause based on the CREATED_BY and 
 SYSTEM_USER_ID columns, which are the foreign and primary key respectively. 
 In a self-join, these columns may be in the same or different rows in the table.
*/
COL system_user_id  FORMAT 999999  HEADING "System|User|ID #|--------|Table #1"
COL created_by      FORMAT 999999  HEADING "Created|By|ID #|--------|Table #1"
COL system_user_pk  FORMAT 999999  HEADING "System|User|ID #|--------|Table #2"
SELECT su_t1.system_user_id, su_t1.created_by, su_t2.system_user_id as system_user_pk
FROM system_user as su_t1 
INNER JOIN system_user as su_t2 ON su_t1.created_by = su_t2.system_user_id;

/*
b. [2 points]Display the SYSTEM_USER_ID and LAST_UPDATED_BY columns from one row, 
and the SYSTEM_USER_ID column from a row where it is also the primary key. You 
should make the join with the ON subclause based on the LAST_UPDATED_BY and 
SYSTEM_USER_ID columns, which are the foreign and primary key respectively. 
In a self-join, these columns may be in the same or different rows in the table.
*/
COL system_user_id   FORMAT 999999  HEADING "System|User|ID #|--------|Table #1"
COL last_updated_by  FORMAT 999999  HEADING "Last|Updated|By|ID #|--------|Table #1"
COL system_user_pk   FORMAT 999999  HEADING "System|User|ID #|--------|Table #2"
SELECT su_t1.system_user_id, su_t1.last_updated_by, su_t2.system_user_id as system_user_pk
FROM system_user as su_t1 
INNER JOIN system_user as su_t2 ON su_t1.last_updated_by = su_t2.system_user_id;

/*
c. [4 points] Display the SYSTEM_USER_ID and SYSTEM_USER_NAME columns from the 
first copy of the SYSTEM_USER table, then the following from the second copy of 
the SYSTEM_USER table:
*/
COL user_id        FORMAT 999999  HEADING "System|User|ID #|--------|Table #1"
COL user_name      FORMAT A8      HEADING "System|User|Name|--------|Table #1"
COL cby_user_id    FORMAT 999999  HEADING "System|User|ID #|--------|Table #2"
COL cby_user_name  FORMAT A8      HEADING "System|User|Name|--------|Table #2"
COL lby_user_id    FORMAT 999999  HEADING "System|User|ID #|--------|Table #3"
COL lby_user_name  FORMAT A8      HEADING "System|User|Name|--------|Table #3"
SELECT 
   su_t1.system_user_id as user_id, 
   su_t1.system_user_name as user_name, 
   su_t2.system_user_id as cby_user_id,
   su_t2.system_user_name as cby_user_name,
   su_t3.system_user_id as lby_user_id,
   su_t3.system_user_name as lby_user_name
FROM system_user as su_t1 
INNER JOIN system_user as su_t2 ON su_t1.created_by = su_t2.system_user_id
INNER JOIN system_user as su_t3 ON su_t1.last_updated_by = su_t3.system_user_id;

SPOOL OFF