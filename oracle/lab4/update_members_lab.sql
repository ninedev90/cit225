-- ------------------------------------------------------------------
--  Program Name:   update_member_labs.sql
--  Lab Assignment: N/A
--  Program Author: Michael McLaughlin
--  Creation Date:  25-Jan-2018
-- ------------------------------------------------------------------
--  Change Log:
-- ------------------------------------------------------------------
--  Change Date    Change Reason
-- -------------  ---------------------------------------------------
--  
-- ------------------------------------------------------------------
-- These steps modify the member_lab table created during Lab #2, by adding
-- a member_lab_TYPE column and seeding an appropriate group or individual 
-- account on the basis of how many contact_labs belong to a member_lab.
-- ------------------------------------------------------------------

-- ------------------------------------------------------------------
--  Open log file.
-- ------------------------------------------------------------------
SPOOL update_member_labs.txt

-- Update all member_lab_TYPE values based on number of dependent contact_lab rows.
UPDATE member_lab m
SET    member_lab_type =
        (SELECT   common_lookup_lab_id
         FROM     common_lookup_lab
         WHERE    common_lookup_lab_context = 'member_lab'
         AND      common_lookup_lab_type =
                   (SELECT  dt.member_lab_type
                    FROM   (SELECT   c.member_lab_id
                            ,        CASE
                                       WHEN COUNT(c.member_lab_id) > 1 THEN 'GROUP'
                                       ELSE 'INDIVIDUAL'
                                     END AS member_lab_type
                            FROM     contact_lab c
                            GROUP BY c.member_lab_id) dt
                    WHERE    dt.member_lab_id = m.member_lab_id));

-- Modify the member_lab table to add a NOT NULL constraint to the member_lab_TYPE column.
ALTER TABLE member_lab
  MODIFY (member_lab_type  NUMBER  CONSTRAINT nn_member_lab_1  NOT NULL);

-- Use SQL*Plus report formatting commands.
COLUMN member_lab_id          FORMAT 999999 HEADING "member_lab|ID"
COLUMN member_labs            FORMAT 999999 HEADING "member_lab|QTY #"
COLUMN member_lab_type        FORMAT 999999 HEADING "member_lab|TYPE|ID #"
COLUMN common_lookup_lab_id   FORMAT 999999 HEADING "member_lab|LOOKUP|ID #"
COLUMN common_lookup_lab_type FORMAT A12    HEADING "COMMON|LOOKUP|TYPE"
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

-- Commit changes.
COMMIT;

-- ------------------------------------------------------------------
--  Close log file.
-- ------------------------------------------------------------------
SPOOL OFF
                            
