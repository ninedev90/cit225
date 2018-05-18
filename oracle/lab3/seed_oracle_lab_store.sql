-- ------------------------------------------------------------------
--  Program Name:   create_oracle_lab_store.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  02-Mar-2010
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  08-Jun-2014    Update lab for weekly deliverables.
-- ------------------------------------------------------------------
-- This seeds data in the video store model. It requires that you run
-- the create_oracle_store.sql script.
-- ------------------------------------------------------------------

-- Open log file.
SPOOL seed_oracle__lab_store.log

-- Set SQL*Plus environment variables.
SET ECHO ON
SET FEEDBACK ON
SET NULL '<Null>'
SET PAGESIZE 999
SET SERVEROUTPUT ON

-- Insert statement demonstrates a mandatory-only column override signature.
-- ------------------------------------------------------------------
-- TIP: When a comment ends the last line, you must use a forward slash on
--      on the next line to run the statement rather than a semicolon.
-- ------------------------------------------------------------------
INSERT
INTO system_user_lab
( system_user_lab_id
, system_user_lab_name
, system_user_lab_group_id
, system_user_lab_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 2                 -- system_user_lab_id
,'DBA'              -- system_user_lab_name
, 2                 -- system_user_lab_group_id
, 2                 -- system_user_lab_type
,'Adams'            -- last_name
,'Samuel'           -- middle_name
, 1                 -- created_by
, SYSDATE           -- creation_date
, 1                 -- last_updated_by
, SYSDATE)          -- last_update_date
/

-- A variation on the override signature.
-- ------------------------------------------------------------------
-- TIP: When omitting column names for values, you may use the semicolon
--      on the last line to execute the query.
-- ------------------------------------------------------------------
INSERT
INTO system_user_lab
( system_user_lab_id
, system_user_lab_name
, system_user_lab_group_id
, system_user_lab_type
, last_name
, first_name
, created_by
, creation_date
, last_updated_by
, last_update_date)
VALUES
( 3,'DBA', 2, 2,'Henry','Patrick', 1, SYSDATE, 1, SYSDATE);

-- A default signatures must mirror the order of columns in the data catalog.
INSERT
INTO system_user_lab
VALUES
( 4
,'DBA'
, 2
, 2
,'Manmohan'
, NULL              -- Optional parameters must be provided a null value in a default signature.
,'Puri'
, 1
, SYSDATE
, 1
, SYSDATE);

-- ------------------------------------------------------------------
-- This seeds rows in a dependency chain, including the member_lab, contact_lab
-- address_lab, and telephone_lab tables.
-- ------------------------------------------------------------------
-- Insert record set #1.
-- ------------------------------------------------------------------
INSERT INTO member_lab VALUES
( member_lab_s1.nextval
, NULL
,'B293-71445'
,'1111-2222-3333-4444'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'member_lab'
  AND      common_lookup_lab_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact_lab VALUES
( contact_lab_s1.nextval
, member_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'contact_lab'
  AND      common_lookup_lab_type = 'CUSTOMER')
,'Randi','','Winn'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_lab_s1.nextval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_lab_s1.nextval
, address_lab_s1.currval
,'10 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_lab_s1.nextval
, address_lab_s1.currval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'USA','408','111-1111'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact_lab VALUES
( contact_lab_s1.nextval
, member_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'contact_lab'
  AND      common_lookup_lab_type = 'CUSTOMER')
,'Brian','','Winn'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_lab_s1.nextval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_lab_s1.nextval
, address_lab_s1.currval
,'10 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_lab_s1.nextval
, address_lab_s1.currval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'USA','408','111-1111'
, 2, SYSDATE, 2, SYSDATE);

-- ------------------------------------------------------------------
-- Insert record set #2.
-- ------------------------------------------------------------------
INSERT INTO member_lab VALUES
( member_lab_s1.nextval
, NULL
,'B293-71446'
,'2222-3333-4444-5555'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'member_lab'
  AND      common_lookup_lab_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact_lab VALUES
( contact_lab_s1.nextval
, member_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'contact_lab'
  AND      common_lookup_lab_type = 'CUSTOMER')
,'Oscar','','Vizquel'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_lab_s1.nextval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_lab_s1.nextval
, address_lab_s1.currval
,'12 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_lab_s1.nextval
, address_lab_s1.currval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'USA','408','222-2222'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact_lab VALUES
( contact_lab_s1.nextval
, member_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'contact_lab'
  AND      common_lookup_lab_type = 'CUSTOMER')
,'Doreen','','Vizquel'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_lab_s1.nextval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_lab_s1.nextval
, address_lab_s1.currval
,'12 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_lab_s1.nextval
, address_lab_s1.currval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'USA','408','222-2222'
, 2, SYSDATE, 2, SYSDATE);

-- ------------------------------------------------------------------
-- Insert record set #3.
-- ------------------------------------------------------------------
INSERT INTO member_lab VALUES
( member_lab_s1.nextval
, NULL
,'B293-71447'
,'3333-4444-5555-6666'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'member_lab'
  AND      common_lookup_lab_type = 'DISCOVER_CARD')
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact_lab VALUES
( contact_lab_s1.nextval
, member_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'contact_lab'
  AND      common_lookup_lab_type = 'CUSTOMER')
,'Meaghan','','Sweeney'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_lab_s1.nextval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_lab_s1.nextval
, address_lab_s1.currval
,'14 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_lab_s1.nextval
, address_lab_s1.currval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'USA','408','333-3333'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact_lab VALUES
( contact_lab_s1.nextval
, member_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'contact_lab'
  AND      common_lookup_lab_type = 'CUSTOMER')
,'Matthew','','Sweeney'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_lab_s1.nextval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_lab_s1.nextval
, address_lab_s1.currval
,'14 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_lab_s1.nextval
, address_lab_s1.currval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'USA','408','333-3333'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO contact_lab VALUES
( contact_lab_s1.nextval
, member_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_context = 'contact_lab'
  AND      common_lookup_lab_type = 'CUSTOMER')
,'Ian','M','Sweeney'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO address_lab VALUES
( address_lab_s1.nextval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'San Jose','CA','95192'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO street_address_lab VALUES
( street_address_lab_s1.nextval
, address_lab_s1.currval
,'14 El Camino Real'
, 2, SYSDATE, 2, SYSDATE);

INSERT INTO telephone_lab VALUES
( telephone_lab_s1.nextval
, address_lab_s1.currval
, contact_lab_s1.currval
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'HOME')
,'USA','408','333-3333'
, 2, SYSDATE, 2, SYSDATE);

-- ------------------------------------------------------------------
-- Insert 21 rows in the item_lab table.
-- ------------------------------------------------------------------
INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'9736-05640-4'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'DVD_WIDE_SCREEN')
,'The Hunt for Red October','Special Collector''s Edition','PG'
,'02-MAR-90'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'24543-02392'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'DVD_WIDE_SCREEN')
,'Star Wars I','Phantom Menace','PG'
,'04-MAY-99'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'24543-5615'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'DVD_FULL_SCREEN')
,'Star Wars II','Attack of the Clones','PG'
,'16-MAY-02'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'24543-05539'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'DVD_WIDE_SCREEN')
,'Star Wars II','Attack of the Clones','PG'
,'16-MAY-02'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'24543-20309'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'DVD_WIDE_SCREEN')
,'Star Wars III','Revenge of the Sith','PG13'
,'19-MAY-05'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'86936-70380'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'DVD_WIDE_SCREEN')
,'The Chronicles of Narnia'
,'The Lion, the Witch and the Wardrobe','PG'
,'16-MAY-02'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'91493-06475'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'XBOX')
,'RoboCop','','Mature'
,'24-JUL-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'93155-11810'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'XBOX')
,'Pirates of the Caribbean','','Teen','30-JUN-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'12725-00173'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'XBOX')
,'The Chronicles of Narnia'
,'The Lion, the Witch and the Wardrobe','Everyone','30-JUN-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'45496-96128'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'NINTENDO_GAMECUBE')
,'MarioKart','Double Dash','Everyone','17-NOV-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'08888-32214'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'PLAYSTATION2')
,'Splinter Cell','Chaos Theory','Teen','08-APR-03'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'14633-14821'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'PLAYSTATION2')
,'Need for Speed','Most Wanted','Everyone','15-NOV-04'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'10425-29944'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'XBOX')
,'The DaVinci Code','','Teen','19-MAY-06'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'52919-52057'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'XBOX')
,'Cars','','Everyone','28-APR-06'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'9689-80547-3'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'BLU-RAY')
,'Beau Geste','','PG','01-MAR-92'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'53939-64103'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'BLU-RAY')
,'I Remember_lab Mama','','NR','05-JAN-98'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'24543-01292'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'BLU-RAY')
,'Tora! Tora! Tora!','The Attack on Pearl Harbor','G','02-NOV-99'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'43396-60047'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'BLU-RAY')
,'A Man for All Seasons','','G','28-JUN-94'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'43396-70603'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'BLU-RAY')
,'Hook','','PG','11-DEC-91'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'85391-13213'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'BLU-RAY')
,'Around the World in 80 Days','','G','04-DEC-92'
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO item_lab VALUES
( item_lab_s1.nextval
,'85391-10843'
,(SELECT   common_lookup_lab_id
  FROM     common_lookup_lab
  WHERE    common_lookup_lab_type = 'BLU-RAY')
,'Camelot','','G','15-MAY-98'
, 3, SYSDATE, 3, SYSDATE);

-- ------------------------------------------------------------------
-- Inserts 5 rental_labs with 9 dependent rental_lab item_labs.  This section inserts
-- 5 rows in the rental_lab table, then 9 rows in the rental_item_lab table. The
-- inserts into the rental_item_lab tables use scalar subqueries to find the
-- proper foreign key values by querying the rental_lab table primary keys. 
-- ------------------------------------------------------------------
-- Insert 5 records in the rental_lab table.
-- ------------------------------------------------------------------
INSERT INTO rental_lab VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Vizquel'
  AND      first_name = 'Oscar')
, TRUNC(SYSDATE), TRUNC(SYSDATE) + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_lab VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Vizquel'
  AND      first_name = 'Doreen')
, TRUNC(SYSDATE), TRUNC(SYSDATE) + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_lab VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Sweeney'
  AND      first_name = 'Meaghan')
, TRUNC(SYSDATE), TRUNC(SYSDATE) + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_lab VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Sweeney'
  AND      first_name = 'Ian')
, TRUNC(SYSDATE), TRUNC(SYSDATE) + 5
, 3, SYSDATE, 3, SYSDATE);

INSERT INTO rental_lab VALUES
( rental_lab_s1.nextval
,(SELECT   contact_lab_id
  FROM     contact_lab
  WHERE    last_name = 'Winn'
  AND      first_name = 'Brian')
, TRUNC(SYSDATE), TRUNC(SYSDATE) + 5
, 3, SYSDATE, 3, SYSDATE);

-- ------------------------------------------------------------------
-- Insert 9 records in the rental_item_lab table.
-- ------------------------------------------------------------------
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
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   i.item_lab_id
  FROM     item_lab i
  ,        common_lookup_lab cl
  WHERE    i.item_lab_title = 'Star Wars I'
  AND      i.item_lab_subtitle = 'Phantom Menace'
  AND      i.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

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
,(SELECT   r.rental_lab_id
  FROM     rental_lab r inner join contact_lab c
  ON       r.customer_id = c.contact_lab_id
  WHERE    c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   d.item_lab_id
  FROM     item_lab d join common_lookup_lab cl
  ON       d.item_lab_title = 'Star Wars II'
  WHERE    d.item_lab_subtitle = 'Attack of the Clones'
  AND      d.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

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
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Oscar')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_lab_title = 'Star Wars III'
  AND      d.item_lab_subtitle = 'Revenge of the Sith'
  AND      d.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

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
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Doreen')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_lab_title = 'I Remember_lab Mama'
  AND      d.item_lab_subtitle IS NULL
  AND      d.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'BLU-RAY')
, 3, SYSDATE, 3, SYSDATE);

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
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Vizquel'
  AND      c.first_name = 'Doreen')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_lab_title = 'Camelot'
  AND      d.item_lab_subtitle IS NULL
  AND      d.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'BLU-RAY')
, 3, SYSDATE, 3, SYSDATE);

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
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Sweeney'
  AND      c.first_name = 'Meaghan')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_lab_title = 'Hook'
  AND      d.item_lab_subtitle IS NULL
  AND      d.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'BLU-RAY')
, 3, SYSDATE, 3, SYSDATE);

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
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Sweeney'
  AND      c.first_name = 'Ian')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_lab_title = 'Cars'
  AND      d.item_lab_subtitle IS NULL
  AND      d.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'XBOX')
, 3, SYSDATE, 3, SYSDATE);

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
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Winn'
  AND      c.first_name = 'Brian')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_lab_title = 'RoboCop'
  AND      d.item_lab_subtitle IS NULL
  AND      d.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'XBOX')
, 3, SYSDATE, 3, SYSDATE);

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
,(SELECT   r.rental_lab_id
  FROM     rental_lab r
  ,        contact_lab c
  WHERE    r.customer_id = c.contact_lab_id
  AND      c.last_name = 'Winn'
  AND      c.first_name = 'Brian')
,(SELECT   d.item_lab_id
  FROM     item_lab d
  ,        common_lookup_lab cl
  WHERE    d.item_lab_title = 'The Hunt for Red October'
  AND      d.item_lab_subtitle = 'Special Collector''s Edition'
  AND      d.item_lab_type = cl.common_lookup_lab_id
  AND      cl.common_lookup_lab_type = 'DVD_WIDE_SCREEN')
, 3, SYSDATE, 3, SYSDATE);

-- ------------------------------------------------------------------
-- These steps modify the member_lab table created during Lab #2, by adding
-- a member_lab_TYPE column and seeding an appropriate group or individual 
-- account on the basis of how many contact_labs belong to a member_lab.
-- ------------------------------------------------------------------
-- Update all member_lab_TYPE values based on number of dependent contact_lab rows.
UPDATE member_lab m
SET    member_lab_type = (SELECT   common_lookup_lab_id
                      FROM     common_lookup_lab
                      WHERE    common_lookup_lab_context = 'member_lab'
                      AND      common_lookup_lab_type =
                                (SELECT  dt.member_lab_type
                                 FROM   (SELECT   c.member_lab_id
                                         ,        CASE
                                                    WHEN COUNT(c.member_lab_id) > 1 THEN
                                                     'GROUP'
                                                    ELSE
                                                     'INDIVIDUAL'
                                                  END AS member_lab_type
                                         FROM     contact_lab c
                                         GROUP BY c.member_lab_id) dt
                                 WHERE   dt.member_lab_id = m.member_lab_id));

-- Modify the member_lab table to add a NOT NULL constraint to the member_lab_TYPE column.
ALTER TABLE member_lab
ADD CONSTRAINT nn_member_lab_1 CHECK(member_lab_type IS NOT NULL);

-- Use SQL*Plus report formatting commands.
COLUMN member_lab_id          FORMAT 999999 HEADING "member_lab|ID"
COLUMN member_labs            FORMAT 999999 HEADING "member_lab|QTY #"
COLUMN member_lab_type        FORMAT 999999 HEADING "member_lab|TYPE|ID #"
COLUMN common_lookup_lab_id   FORMAT 999999 HEADING "member_lab|LOOKUP|ID #"
COLUMN common_lookup_lab_type FORMAT A12    HEADING "COMMON|LOOKUP|TYPE"
                                 
-- Verify member_lab_TYPE values, confirms preceding UPDATE statement.
SELECT   m.member_lab_id
,        COUNT(contact_lab_id) AS member_labS
,        m.member_lab_type
,        cl.common_lookup_lab_id
,        cl.common_lookup_lab_type
FROM     member_lab m INNER JOIN contact_lab c
ON       m.member_lab_id = c.member_lab_id INNER JOIN common_lookup_lab cl
ON       m.member_lab_type = cl.common_lookup_lab_id
GROUP BY m.member_lab_id
,        m.member_lab_type
,        cl.common_lookup_lab_id
,        cl.common_lookup_lab_type
ORDER BY m.member_lab_id;                            
                      
-- Transaction Management Example.
CREATE OR REPLACE PROCEDURE contact_lab_insert
( pv_member_lab_type         VARCHAR2
, pv_account_number      VARCHAR2
, pv_credit_card_number  VARCHAR2
, pv_credit_card_type    VARCHAR2
, pv_first_name          VARCHAR2
, pv_middle_name         VARCHAR2 := ''
, pv_last_name           VARCHAR2
, pv_contact_lab_type        VARCHAR2
, pv_address_lab_type        VARCHAR2
, pv_city                VARCHAR2
, pv_state_province      VARCHAR2
, pv_postal_code         VARCHAR2
, pv_street_address_lab      VARCHAR2
, pv_telephone_lab_type      VARCHAR2
, pv_country_code        VARCHAR2
, pv_area_code           VARCHAR2
, pv_telephone_lab_number    VARCHAR2
, pv_created_by          NUMBER   := 1
, pv_creation_date       DATE     := SYSDATE
, pv_last_updated_by     NUMBER   := 1
, pv_last_update_date    DATE     := SYSDATE) IS

  -- Local variables, to leverage subquery assignments in INSERT statements.
  lv_address_lab_type        VARCHAR2(30);
  lv_contact_lab_type        VARCHAR2(30);
  lv_credit_card_type    VARCHAR2(30);
  lv_member_lab_type         VARCHAR2(30);
  lv_telephone_lab_type      VARCHAR2(30);
  
BEGIN
  -- Assign parameter values to local variables for nested assignments to DML subqueries.
  lv_address_lab_type := pv_address_lab_type;
  lv_contact_lab_type := pv_contact_lab_type;
  lv_credit_card_type := pv_credit_card_type;
  lv_member_lab_type := pv_member_lab_type;
  lv_telephone_lab_type := pv_telephone_lab_type;
  
  -- Create a SAVEPOINT as a starting point.
  SAVEPOINT starting_point;
  
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
  ( member_lab_s1.NEXTVAL
  ,(SELECT   common_lookup_lab_id
    FROM     common_lookup_lab
    WHERE    common_lookup_lab_context = 'member_lab'
    AND      common_lookup_lab_type = lv_member_lab_type)
  , pv_account_number
  , pv_credit_card_number
  ,(SELECT   common_lookup_lab_id
    FROM     common_lookup_lab
    WHERE    common_lookup_lab_context = 'member_lab'
    AND      common_lookup_lab_type = lv_credit_card_type)
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );

  INSERT INTO contact_lab
  VALUES
  ( contact_lab_s1.NEXTVAL
  , member_lab_s1.CURRVAL
  ,(SELECT   common_lookup_lab_id
    FROM     common_lookup_lab
    WHERE    common_lookup_lab_context = 'contact_lab'
    AND      common_lookup_lab_type = lv_contact_lab_type)
  , pv_first_name
  , pv_middle_name
  , pv_last_name
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  INSERT INTO address_lab
  VALUES
  ( address_lab_s1.NEXTVAL
  , contact_lab_s1.CURRVAL
  ,(SELECT   common_lookup_lab_id
    FROM     common_lookup_lab
    WHERE    common_lookup_lab_context = 'MULTIPLE'
    AND      common_lookup_lab_type = lv_address_lab_type)
  , pv_city
  , pv_state_province
  , pv_postal_code
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  

  INSERT INTO street_address_lab
  VALUES
  ( street_address_lab_s1.NEXTVAL
  , address_lab_s1.CURRVAL
  , pv_street_address_lab
  , pv_created_by
  , pv_creation_date
  , pv_last_updated_by
  , pv_last_update_date );  
  dbms_output.put_line('c5');
  INSERT INTO telephone_lab
  VALUES
  ( telephone_lab_s1.NEXTVAL                              -- telephone_lab_ID
  , contact_lab_s1.CURRVAL                                -- contact_lab_ID
  , address_lab_s1.CURRVAL                                -- address_lab_ID
  ,(SELECT   common_lookup_lab_id                         -- address_lab_TYPE
    FROM     common_lookup_lab
    WHERE    common_lookup_lab_context = 'MULTIPLE'
    AND      common_lookup_lab_type = lv_telephone_lab_type)
  , pv_country_code                                   -- COUNTRY_CODE
  , pv_area_code                                      -- AREA_CODE
  , pv_telephone_lab_number                               -- telephone_lab_NUMBER
  , pv_created_by                                     -- CREATED_BY
  , pv_creation_date                                  -- CREATION_DATE
  , pv_last_updated_by                                -- LAST_UPDATED_BY
  , pv_last_update_date);                             -- LAST_UPDATE_DATE

  COMMIT;
EXCEPTION 
  WHEN OTHERS THEN
    ROLLBACK TO starting_point;
    RETURN;
END contact_lab_insert;
/

-- Display any compilation errors.
SHOW ERRORS

-- Insert complete contact_lab information using stored procedure.
EXECUTE contact_lab_insert('INDIVIDUAL','R11-514-34','1111-1111-1111-1111','VISA_CARD','Goeffrey','Ward','Clinton','CUSTOMER','HOME','Provo','Utah','84606','118 South 9th East','HOME','011','801','423-1234');
EXECUTE contact_lab_insert('INDIVIDUAL','R11-514-35','1111-2222-1111-1111','VISA_CARD','Wendy','','Moss','CUSTOMER','HOME','Provo','Utah','84606','1218 South 10th East','HOME','011','801','423-1234');
EXECUTE contact_lab_insert('INDIVIDUAL','R11-514-36','1111-1111-2222-1111','VISA_CARD','Simon','Jonah','Gretelz','CUSTOMER','HOME','Provo','Utah','84606','2118 South 7th East','HOME','011','801','423-1234');
EXECUTE contact_lab_insert('INDIVIDUAL','R11-514-37','1111-1111-1111-2222','MASTER_CARD','Elizabeth','Jane','Royal','CUSTOMER','HOME','Provo','Utah','84606','2228 South 14th East','HOME','011','801','423-1234');
EXECUTE contact_lab_insert('INDIVIDUAL','R11-514-38','1111-1111-3333-1111','VISA_CARD','Brian','Nathan','Smith','CUSTOMER','HOME','Spanish Fork','Utah','84606','333 North 2nd East','HOME','011','801','423-1234');

-- Verify member_lab_TYPE values.
SELECT   m.member_lab_id
,        COUNT(contact_lab_id) AS member_labS
,        m.member_lab_type
,        cl.common_lookup_lab_id
,        cl.common_lookup_lab_type
FROM     member_lab m INNER JOIN contact_lab c
ON       m.member_lab_id = c.member_lab_id INNER JOIN common_lookup_lab cl
ON       m.member_lab_type = cl.common_lookup_lab_id
GROUP BY m.member_lab_id
,        m.member_lab_type
,        cl.common_lookup_lab_id
,        cl.common_lookup_lab_type
ORDER BY m.member_lab_id;

-- Create a transaction view.
CREATE OR REPLACE VIEW current_rental_lab AS
  SELECT   m.account_number
  ,        c.first_name
  ||       DECODE(c.middle_name,NULL,' ',' '||c.middle_name||' ')
  ||       c.last_name FULL_NAME
  ,        i.item_lab_title TITLE
  ,        i.item_lab_subtitle SUBTITLE
  ,        SUBSTR(cl.common_lookup_lab_meaning,1,3) PRODUCT
  ,        r.check_out_date
  ,        r.return_date
  FROM     common_lookup_lab cl
  ,        contact_lab c
  ,        item_lab i
  ,        member_lab m
  ,        rental_lab r
  ,        rental_item_lab ri
  WHERE    r.customer_id = c.contact_lab_id
  AND      r.rental_lab_id = ri.rental_lab_id
  AND      ri.item_lab_id = i.item_lab_id
  AND      i.item_lab_type = cl.common_lookup_lab_id
  AND      c.member_lab_id = m.member_lab_id
  ORDER BY 1,2,3;

COL full_name FORMAT A16
COL title     FORMAT A30
COL subtitle  FORMAT A4

SELECT   cr.full_name
,        cr.title
,        cr.product
,        cr.check_out_date
,        cr.return_date
FROM     current_rental_lab cr;
       
SPOOL OFF