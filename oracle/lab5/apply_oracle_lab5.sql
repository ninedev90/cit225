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

/*---------------------------------------------------------------------------------
4. [8 points] Display the RENTAL_ID column from the RENTAL table, the RENTAL_ID and
 ITEM_ID from the RENTAL_ITEM table, and ITEM_ID column from the ITEM table. You 
 should make a join from the RENTAL table to the RENTAL_ITEM table, and then the ITEM 
 table. Join the tables based on their respective primary and foreign key values.
 */

 SELECT r.rental_id, ri.rental_id, ri.item_id, i.item_id
 FROM rental r
 INNER JOIN rental_item ri USING (rental_id)
 INNER JOIN item i USING (item_id);

 /*
 ------------------------------------------------------------------------------------
 5. [10 points] Display the DEPARTMENT_NAME from the DEPARTMENT table and the average in 
 whole dollars of the SALARY column from the SALARY table grouped by and ordered by 
 the DEPARTMENT_NAME column for the last two months. (HINT: The lookup values and 
 range values with a BETWEEN operator must be not null values, and when the ending 
 date is null you should use an NVL(some_date, SYSDATE + 1) or tomorrow to get the 
 operator to return a value other than a null value.)
 */

/* Conditionally drop non-equijoin sample tables. */
BEGIN
  FOR i IN (SELECT   object_name
            ,        object_type
            FROM     user_objects
            WHERE    object_name IN ('DEPARTMENT','DEPARTMENT_S'
                                  ,'EMPLOYEE','EMPLOYEE_S'
                                  ,'SALARY','SALARY_S')
            ORDER BY object_type) LOOP
    IF i.object_type = 'TABLE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name||' CASCADE CONSTRAINTS';
    ELSIF i.object_type = 'SEQUENCE' THEN
      EXECUTE IMMEDIATE 'DROP '||i.object_type||' '||i.object_name;
    END IF;
  END LOOP;
END;
/
 
/* Create department table. */
CREATE TABLE department
( department_id    NUMBER  CONSTRAINT department_pk PRIMARY KEY
, department_name  VARCHAR2(20));
 
/* Create a department_s sequence. */
CREATE SEQUENCE department_s;
 
/* Create a salary table. */
CREATE TABLE salary
( salary_id             NUMBER  CONSTRAINT salary_pk   PRIMARY KEY
, effective_start_date  DATE    CONSTRAINT salary_nn1  NOT NULL
, effective_end_date    DATE
, salary                NUMBER  CONSTRAINT salary_nn2  NOT NULL);
 
/* Create a salary_s sequence. */
CREATE SEQUENCE salary_s;
 
/* Create an employee table. */
CREATE TABLE employee
( employee_id    NUMBER        CONSTRAINT employee_pk  PRIMARY KEY
, department_id  NUMBER        CONSTRAINT employee_nn1 NOT NULL
, salary_id      NUMBER        CONSTRAINT employee_nn2 NOT NULL
, first_name     VARCHAR2(20)  CONSTRAINT employee_nn3 NOT NULL
, last_name      VARCHAR2(20)  CONSTRAINT employee_nn4 NOT NULL
, CONSTRAINT employee_fk FOREIGN KEY(employee_id) REFERENCES employee(employee_id));
 
/* Create an employee_s sequence. */
CREATE SEQUENCE employee_s;
 
 
/* Create an anonymous program to insert data. */
SET SERVEROUTPUT ON SIZE UNLIMITED
DECLARE
  /* Declare a collection of strings. */
  TYPE xname IS TABLE OF VARCHAR2(20);
 
  /* Declare a collection of numbers. */
  TYPE xsalary IS TABLE OF NUMBER;
 
  /* Local variable generated by a random foreign key. */
  lv_department_id  NUMBER;
  lv_salary_id      NUMBER;
 
  /* A collection of first names. */
  lv_first XNAME := xname('Ann','Abbey','Amanda','Archie','Antonio','Arnold'
                         ,'Barbara','Basil','Bernie','Beth','Brian','Bryce'
                         ,'Carl','Carrie','Charlie','Christine','Corneilus','Crystal'
                         ,'Dana','Darlene','Darren','Dave','Davi','Deidre'
                         ,'Eamonn','Eberhard','Ecaterina','Ebony','Elana','Eric'
                         ,'Fabian','Faith','Fernando','Farris','Fiana','Francesca'
                         ,'Gabe','Gayle','Geoffrey','Gertrude','Grayson','Guy'
                         ,'Harry','Harriet','Henry','Henrica','Herman','Hesper'
                         ,'Ian','Ida','Iggy','Iliana','Imogene','Issac'
                         ,'Jan','Jack','Jennifer','Jerry','Julian','June'
                         ,'Kacey','Karen','Kaitlyn','Keith','Kevin','Kyle'
                         ,'Laney','Lawrence','Leanne','Liam','Lois','Lynne'
                         ,'Marcel','Marcia','Mark','Meagan','Mina','Michael'
                         ,'Nancy','Naomi','Narcissa','Nasim','Nathaniel','Neal'
                         ,'Obadiah','Odelia','Ohanna','Olaf','Olive','Oscar'
                         ,'Paige','Palmer','Paris','Pascal','Patricia','Peter'
                         ,'Qadir','Qasim','Quaid','Quant','Quince','Quinn'
                         ,'Rachelle','Rafael','Raj','Randy','Ramona','Raven'
                         ,'Savina','Sadie','Sally','Samuel','Saul','Santino'
                         ,'Tabitha','Tami','Tanner','Thomas','Timothy','Tina'
                         ,'Ugo','Ululani','Umberto','Una','Urbi','Ursula'
                         ,'Val','Valerie','Valiant','Vanessa','Vaughn','Verna'
                         ,'Wade','Wagner','Walden','Wanda','Wendy','Wilhelmina'
                         ,'Xander','Xavier','Xena','Xerxes','Xia','Xylon'
                         ,'Yana','Yancy','Yasmina','Yasmine','Yepa','Yeva'
                         ,'Zacarias','Zach','Zahara','Zander','Zane');
 
  /* A collection of last names. */
  lv_last  XNAME := xname('Abernathy','Anderson','Baker','Barney'
                         ,'Christensen','Cafferty','Davis','Donaldson'
                         ,'Eckhart','Eidelman','Fern','Finkel','Frank','Frankel','Fromm'
                         ,'Garfield','Geary','Harvey','Hamilton','Harwood'
                         ,'Ibarguen','Imbezi','Lindblom','Lynstrom'
                         ,'Martel','McKay','McLellen','Nagata','Noonan','Nunes'
                         ,'O''Brien','Oakey','Patterson','Petersen','Pratel','Preston'
                         ,'Qian','Queen','Ricafort','Richards','Roberts','Robertson'
                         ,'Sampson','Simon','Tabacchi','Travis','Trevor','Tower'
                         ,'Ubel','Urie','Vassen','Vanderbosch'
                         ,'Wacha','Walcott','West','Worley','Xian','Xiang'
                         ,'Yackley','Yaguchi','Zarbarsky','Zambelli');
 
  /* A collection of department names. */
  lv_dept  XNAME := xname('Accounting','Operations','Sales','Factory','Manufacturing');
 
  /* A colleciton of possible salaries. */
  lv_salary  XSALARY := xsalary( 36000, 42000, 48000, 52000, 64000 );
 
  /* Define a local function. */
  FUNCTION random_foreign_key RETURN INTEGER IS
    /* Declare a return variable. */
    lv_return_value  NUMBER;
  BEGIN
    /* Select a random number between 1 and 5 and assign it to a local variable. */
    SELECT CASE
             WHEN num = 0 THEN 5 ELSE num
           END AS random_key
    INTO   lv_return_value
    FROM   (SELECT ROUND(dbms_random.VALUE(1,1000)/100/2,0) num FROM dual) il;
 
    /* Return the random number. */
    RETURN lv_return_value;
  END random_foreign_key;
 
BEGIN
  /* Insert departments. */
  FOR i IN 1..lv_dept.LAST LOOP
    INSERT INTO department
    ( department_id
    , department_name )
    VALUES
    ( department_s.NEXTVAL
    , lv_dept(i));
  END LOOP;
 
  /* Insert salary. */
  FOR i IN 1..lv_salary.LAST LOOP
    INSERT INTO salary
    ( salary_id
    , effective_start_date
    , salary )
    VALUES
    ( salary_s.NEXTVAL
    , TRUNC(SYSDATE) - 30
    , lv_salary(i));
  END LOOP;
 
  /* Insert random employees. */
  FOR i IN 1..lv_first.LAST LOOP
    FOR j IN 1..lv_last.LAST LOOP
      /* Assign a random values to a local variable. */
      lv_department_id := random_foreign_key;
      lv_salary_id := random_foreign_key;
 
      /* Insert values into the employee table. */
      INSERT INTO employee
      ( employee_id
      , department_id
      , salary_id
      , first_name
      , last_name )
      VALUES
      ( employee_s.NEXTVAL
      , lv_department_id
      , lv_salary_id
      , lv_first(i)
      , lv_last(j));   
    END LOOP;
  END LOOP;
 
  /* Commit the writes. */
  COMMIT;  
END;

/* Set output parameters. */
SET PAGESIZE 16
 
/* Format column output. */
COL short_month FORMAT A5 HEADING "Short|Month"
COL long_month  FORMAT A9 HEADING "Long|Month"
COL start_date  FORMAT A9 HEADING "Start|Date"
COL end_date    FORMAT A9 HEADING "End|Date" 
 
/* Query the results from the table. */
SELECT * FROM mock_calendar;

SELECT   d.department_name
,        ROUND(AVG(s.salary),0) AS salary
FROM     employee e INNER JOIN department d
ON       e.department_id = d.department_id INNER JOIN salary s
ON       e.salary_id = s.salary_id
WHERE    ...
GROUP BY d.department_name
ORDER BY d.department_name;

SPOOL OFF