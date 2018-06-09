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
-- @/home/student/Data/cit225/oracle/lib/cleanup_oracle.sql
-- @/home/student/Data/cit225/oracle/lib2/create/create_oracle_store2.sql
-- @/home/student/Data/cit225/oracle/lib2/preseed/preseed_oracle_store.sql
-- @/home/student/Data/cit225/oracle/lib2/seed/seeding.sql
 
SPOOL apply_oracle_lab5.txt
 
 /*-------------------------------------------------------------------------
  1 [16 points] Write INNER JOIN queries that use the USING subclause 
    and return the following results:

  a.  Display the  member_lab_ID and  contact_lab_ID in the SELECT clause from a join
      of the  member_lab and  contact_lab tables. You should make the join with the
      USING subclause based on the  member_lab_ID column, which is the 
      primary and foreign key of the respective tables. 
*/
SELECT m. member_lab_id, c. contact_lab_id
FROM  member_lab m 
INNER JOIN  contact_lab c USING (member_lab_id);

/**
b. Display the  member_lab_ID and  contact_lab_ID in the SELECT clause from a join of the 
 member_lab and  contact_lab tables. You should put the join in the WHERE clause and base 
the join on the  member_lab_ID column, which is the primary and foreign key of the
respective tables.
*/
SELECT m. member_lab_id, c. contact_lab_id
FROM  member_lab m,  contact_lab c
WHERE m. member_lab_id = c. member_lab_id;

/*
c. Display the  contact_lab_ID and address_lab_ID in the SELECT clause from a join of the 
 contact_lab and address_lab tables. You should put the join in the WHERE clause and base
the join on the  contact_lab_ID column, which is the primary and foreign key of the
respective tables.
*/
SELECT c.contact_lab_id, a.address_lab_id
FROM  contact_lab c
INNER JOIN address_lab a USING (contact_lab_id);

/*
d. Display the  contact_lab_ID and address_lab_ID in the SELECT clause from a join of the 
 contact_lab and address_lab tables. You should put the join in the WHERE clause and base
the join on the  contact_lab_ID column, which is the primary and foreign key of the
respective tables.
*/
SELECT c.contact_lab_id, a.address_lab_id
FROM  contact_lab c, address_lab a
where c.contact_lab_id = a.contact_lab_id;

/*
e. Display the address_lab_ID and STREET_address_lab_ID in the SELECT clause from a join 
of the address_lab and STREET_address_lab tables. You should make the join between the 
tables with the USING subclause based on the address_lab_ID column, which is the 
primary and foreign key of the respective tables.
*/
 
 SELECT a.address_lab_id, s.street_address_lab_id
 FROM address_lab a 
 INNER JOIN street_address_lab s USING (address_lab_id);

 /*
 f. Display the address_lab_ID and STREET_address_lab_ID in the SELECT clause from a join 
 of the address_lab and STREET_address_lab tables. You should put the join in the WHERE 
 clause and base the join on the address_lab_ID column, which is the primary and 
 foreign key of the respective tables.
 */
 SELECT a.address_lab_id, s.street_address_lab_id
 FROM address_lab a, street_address_lab s
 WHERE s.address_lab_id = a.address_lab_id;

 /**
 g. Display the  contact_lab_ID and telephone_lab_ID in the SELECT clause from a join of 
 the  contact_lab and telephone_lab tables. You should make the join between the tables 
 with the USING subclause based on the  contact_lab_ID column, which is the primary 
 and foreign key of the respect tables.
 */
SELECT c.contact_lab_id, t.telephone_lab_id
FROM  contact_lab c
INNER JOIN telephone_lab t USING(contat_id);

 /*
 h.Display the  contact_lab_ID and telephone_lab_ID in the SELECT clause from a join of 
 the  contact_lab and telephone_lab tables. You should put the join in the WHERE clause 
 and base the join on the  contact_lab_ID column, which is the primary and foreign 
 key of the respective tables.
 */
 SELECT c.contact_lab_id, t.telephone_lab_id
 FROM  contact_lab c, telephone_lab t 
 WHERE c.contat_id = t.contat_id;

---------------------------------------------------------------------------------------------
 --2. [8 points] Write INNER JOIN queries that use the ON subclause and return the following results:

 /*
 a. Display the CONTACT_ID and SYSTEM_USER_ID columns in the SELECT clause from a join of the
 CONTACT and SYSTEM_USER tables. You should make the join with the ON subclause based on the 
 CREATED_BY and SYSTEM_USER_ID columns, which are the foreign and primary key respectively.
*/
COL contact_id        FORMAT 999999  HEADING "Contact|ID #|--------|Table #1"
COL system_user_id    FORMAT 999999  HEADING "System|User|ID #|--------|Table #2"
SELECT 
  c.contact_lab_id contact_id, 
  s.system_user_lab_id system_user_id
FROM contact_lab c 
INNER JOIN system_user_lab s ON s.system_user_lab_id = c.created_by

/*
b. Display the CONTACT_ID and SYSTEM_USER_ID columns in the SELECT clause from a 
join of the CONTACT and SYSTEM_USER tables. You should put the join in the WHERE 
clause and base the join on the CREATED_BY column, which is the primary and 
foreign key of the respective tables.
*/
COL contact_id        FORMAT 999999  HEADING "Contact|ID #|--------|Table #1"
COL system_user_id    FORMAT 999999  HEADING "System|User|ID #|--------|Table #2"
SELECT 
  c.contact_lab_id contact_id, 
  s.system_user_lab_id system_user_id
FROM contact_lab c, system_user_lab s
WHERE s.system_user_lab_id = c.created_by

/*
c.Display the CONTACT_ID and SYSTEM_USER_ID columns in the SELECT clause from a 
join of the CONTACT and SYSTEM_USER tables. You should make the join with the 
ON subclause based on the LAST_UPDATED_BY and SYSTEM_USER_ID columns, which are 
the foreign and primary key respectively.:
*/
COL contact_id        FORMAT 999999  HEADING "Contact|ID #|--------|Table #1"
COL system_user_id    FORMAT 999999  HEADING "System|User|ID #|--------|Table #2"
SELECT 
  c.contact_lab_id contact_id, 
  s.system_user_lab_id system_user_id
FROM contact_lab c
INNER JOIN system_user_lab s ON s.system_user_lab_id = c.last_updated_by

/*
d. Display the CONTACT_ID and SYSTEM_USER_ID columns in the SELECT clause from a 
join of the CONTACT and SYSTEM_USER tables. You should put the join in the WHERE 
clause and base the join on the LAST_UPDATED_BY and SYSTEM_USER_ID columns, which 
are the foreign and primary key respectively.:
*/
COL contact_id        FORMAT 999999  HEADING "Contact|ID #|--------|Table #1"
COL system_user_id    FORMAT 999999  HEADING "System|User|ID #|--------|Table #2"
SELECT 
  c.contact_lab_id contact_id, 
  s.system_user_lab_id system_user_id
FROM contact_lab c, system_user_lab s
WHERE s.system_user_lab_id = c.last_updated_by;

/*
3. [8 points] Write INNER JOIN queries that use the ON subclause to perform a self-join
  on the SYSTEM_USER table. The solution requires that you create three copies of the 
  SYSTEM_USER table by using aliases like su1, su2, and su3. Please note that joining two
  tables is like matching two sets, while joining three table is like joining two tables
  into a temporary result set (or pseudo table) and then joining the third table to the
  temporary result set if it were a table.
*/

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
SELECT 
  su_t1.system_user_id, 
  su_t1.created_by, 
  su_t2.system_user_id system_user_pk
FROM system_user_lab su_t1 
INNER JOIN system_user_lab su_t2 ON su_t1.created_by = su_t2.system_user_id;

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
SELECT 
  su_t1.system_user_lab_id system_user_id, 
  su_t1.last_updated_by, 
  su_t2.system_user_lab_id system_user_pk
FROM system_user_lab su_t1 
INNER JOIN system_user_lab su_t2 ON su_t1.last_updated_by = su_t2.system_user_lab_id;

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
   su_t1.system_user_lab_id user_id, 
   su_t1.system_user_ab_name user_name, 
   su_t2.system_user_lab_id cby_user_id,
   su_t2.system_user_lab_name cby_user_name,
   su_t3.system_user_lab_id lby_user_id,
   su_t3.system_user_lab_name lby_user_name
FROM system_user_lab su_t1 
INNER JOIN system_user_lab su_t2 ON su_t1.created_by = su_t2.system_user_lab_id
INNER JOIN system_user_lab su_t3 ON su_t1.last_updated_by = su_t3.system_user_lab_id;

/*---------------------------------------------------------------------------------
4. [8 points] Display the rental_lab_ID column from the rental_lab table, the rental_lab_ID and
 item_lab_ID from the rental_item_lab table, and item_lab_ID column from the item_lab table. You 
 should make a join from the rental_lab table to the rental_item_lab table, and then the item_lab 
 table. Join the tables based on their respective primary and foreign key values.
 */
COL rental_lab_id     FORMAT 999999  HEADING "Rental|Table|--------|Rental|ID #|--------|Table #1"
COL rental_lab_id_fk  FORMAT 999999  HEADING "Rental Item|Table|--------|Rental|ID #|--------|Table #2"
COL item_lab_id_fk    FORMAT 999999  HEADING "Rental Item|Table|--------|Rental|ID #|--------|Table #2"
COL item_lab_id       FORMAT 999999  HEADING "Item|Table|--------|Rental|ID #|--------|Table #3"
SELECT 
  r.rental_lab_id, 
  ri.rental_lab_id, 
  ri.item_lab_id, 
  i.item_lab_id
FROM rental_lab r
INNER JOIN rental_item_lab ri USING (rental_lab_id)
INNER JOIN item_lab i USING (item_lab_id);

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
           END random_key
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
,        ROUND(AVG(s.salary),0) salary
FROM     employee e INNER JOIN department d
ON       e.department_id = d.department_id INNER JOIN salary s
ON       e.salary_id = s.salary_id
WHERE    ...
GROUP BY d.department_name
ORDER BY d.department_name;

SPOOL OFF