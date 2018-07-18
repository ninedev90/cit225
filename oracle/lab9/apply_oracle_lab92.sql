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
--   sql> @apply_oracle_lab9.sql
--
-- ----------------------------------------------------------------------

-- Run the prior lab script.
@/home/student/Data/cit225/oracle/lab8/apply_oracle_lab8.sql

------------
CREATE TABLE transaction
( transaction_id              NUMBER
  , transaction_account         VARCHAR2(15) CONSTRAINT nn_transaction_1 NOT NULL
  , transaction_type            NUMBER       CONSTRAINT nn_transaction_2 NOT NULL
  , transaction_date            DATE         CONSTRAINT nn_transaction_3 NOT NULL
  , transaction_amount          NUMBER       CONSTRAINT nn_transaction_4 NOT NULL
  , rental_id                   NUMBER       CONSTRAINT nn_transaction_5 NOT NULL
  , payment_method_type         NUMBER       CONSTRAINT nn_transaction_6 NOT NULL
  , payment_account_number      VARCHAR(19)  CONSTRAINT nn_transaction_7 NOT NULL
  , created_by                  NUMBER       CONSTRAINT nn_transaction_8 NOT NULL
  , creation_date               DATE         CONSTRAINT nn_transaction_9 NOT NULL
  , last_updated_by             NUMBER       CONSTRAINT nn_transaction_10 NOT NULL
  , last_update_date            DATE         CONSTRAINT nn_transaction_11 NOT NULL
  , CONSTRAINT pk_transaction_id             PRIMARY KEY(transaction_id)
  , CONSTRAINT fk_transaction_1              FOREIGN KEY(transaction_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
  , CONSTRAINT fk_transaction_2              FOREIGN KEY(rental_id) REFERENCES rental_lab(rental_lab_id)
  , CONSTRAINT fk_transaction_3              FOREIGN KEY(payment_method_type) REFERENCES common_lookup_lab(common_lookup_lab_id)
  , CONSTRAINT fk_transaction_4              FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
  , CONSTRAINT fk_transaction_5              FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id));

------------------
CREATE UNIQUE INDEX natural_key
  ON transaction (
    rental_id
    , transaction_type
    , transaction_date
    , payment_method_type
    , payment_account_number
    , transaction_account
  );

------------------
CREATE SEQUENCE transaction_s1 START WITH 1 NOCACHE;


-----------------
INSERT INTO COMMON_LOOKUP_LAB VALUES
  ( common_lookup_lab_s1.nextval
    , 'CREDIT'
    , 'credit'
    , 1
    , SYSDATE
    , 1
    , SYSDATE
    , 'TRANSACTION'
    , 'TRANSACTION_TYPE'
    , 'CR'
  );

INSERT INTO COMMON_LOOKUP_LAB VALUES
  ( common_lookup_lab_s1.nextval
    , 'DEBIT'
    , 'debit'
    , 1
    , SYSDATE
    , 1
    , SYSDATE
    , 'TRANSACTION'
    , 'TRANSACTION_TYPE'
    , 'DR'
  );

INSERT INTO COMMON_LOOKUP_LAB VALUES
  ( common_lookup_lab_s1.nextval
    , 'DISCOVER_CARD'
    , 'Discover Card'
    , 1
    , SYSDATE
    , 1
    , SYSDATE
    , 'TRANSACTION'
    , 'PAYMENT_METHOD_TYPE'
    , NULL
  );

INSERT INTO COMMON_LOOKUP_LAB VALUES
  ( common_lookup_lab_s1.nextval
    , 'VISA_CARD'
    , 'Visa Card'
    , 1
    , SYSDATE
    , 1
    , SYSDATE
    , 'TRANSACTION'
    , 'PAYMENT_METHOD_TYPE'
    , NULL
  );

INSERT INTO COMMON_LOOKUP_LAB VALUES
  ( common_lookup_lab_s1.nextval
    , 'MASTER_CARD'
    , 'Master Card'
    , 1
    , SYSDATE
    , 1
    , SYSDATE
    , 'TRANSACTION'
    , 'PAYMENT_METHOD_TYPE'
    , NULL
  );

INSERT INTO COMMON_LOOKUP_LAB VALUES
  ( common_lookup_lab_s1.nextval
    , 'CASH'
    , 'cash'
    , 1
    , SYSDATE
    , 1
    , SYSDATE
    , 'TRANSACTION'
    , 'PAYMENT_METHOD_TYPE'
    , NULL
  );

------------

CREATE TABLE airport
( airport_id                  NUMBER
, airport_code                VARCHAR2(3)  CONSTRAINT nn_airport_1 NOT NULL
, airport_city                VARCHAR2(30) CONSTRAINT nn_airport_2 NOT NULL
, city                        VARCHAR2(30) CONSTRAINT nn_airport_3 NOT NULL
, state_province              VARCHAR2(30) CONSTRAINT nn_airport_4 NOT NULL
, created_by                  NUMBER       CONSTRAINT nn_airport_5 NOT NULL
, creation_date               DATE         CONSTRAINT nn_airport_6 NOT NULL
, last_updated_by             NUMBER       CONSTRAINT nn_airport_7 NOT NULL
, last_update_date            DATE         CONSTRAINT nn_airport_8 NOT NULL
, CONSTRAINT pk_airport_id             PRIMARY KEY(airport_id)
, CONSTRAINT fk_airport_1              FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
, CONSTRAINT fk_airport_2              FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id));

------------------
CREATE UNIQUE INDEX natural_key
  ON airport (
    airport_code
    , airport_city
    , city
    , state_province
  );

------------------
CREATE SEQUENCE airport_s1 START WITH 1 NOCACHE;

-----------------
INSERT INTO airport VALUES
  (
      airport_s1.nextval
      , 'LAX'
      , 'Los angeles'
      , 'Los angeles'
      , 'California'
      , 1
      , SYSDATE
      , 1
      , SYSDATE
  );

INSERT INTO airport VALUES
  (
    airport_s1.nextval
    , 'SLC'
    , 'Salt Lake City'
    , 'Provo'
    , 'Utah'
    , 1
    , SYSDATE
    , 1
    , SYSDATE
  );

INSERT INTO airport VALUES
  (
    airport_s1.nextval
    , 'SLC'
    , 'Salt Lake City'
    , 'Spanish Fork'
    , 'Utah'
    , 1
    , SYSDATE
    , 1
    , SYSDATE
  );

INSERT INTO airport VALUES
  (
    airport_s1.nextval
    , 'SFO'
    , 'San Francisco'
    , 'San Francisco'
    , 'California'
    , 1
    , SYSDATE
    , 1
    , SYSDATE
  );

INSERT INTO airport VALUES
  (
    airport_s1.nextval
    , 'SJC'
    , 'San Jose'
    , 'San Jose'
    , 'California'
    , 1
    , SYSDATE
    , 1
    , SYSDATE
  );

INSERT INTO airport VALUES
  (
    airport_s1.nextval
    , 'SJC'
    , 'San Jose'
    , 'San Carlos'
    , 'California'
    , 1
    , SYSDATE
    , 1
    , SYSDATE
  );

------------
CREATE TABLE account_list
( account_list_id               NUMBER
  , account_number              VARCHAR2(10) CONSTRAINT nn_account_list_1 NOT NULL
  , consumed_date               DATE
  , consumed_by                 NUMBER
  , created_by                  NUMBER       CONSTRAINT nn_account_list_2 NOT NULL
  , creation_date               DATE         CONSTRAINT nn_account_list_3 NOT NULL
  , last_updated_by             NUMBER       CONSTRAINT nn_account_list_4 NOT NULL
  , last_update_date            DATE         CONSTRAINT nn_account_list_5 NOT NULL
  , CONSTRAINT pk_airport_id             PRIMARY KEY(account_list_id)
  , CONSTRAINT fk_airport_1              FOREIGN KEY(consumed_by) REFERENCES system_user(system_user_id)
  , CONSTRAINT fk_airport_2              FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
  , CONSTRAINT fk_airport_3              FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id));

------------------
CREATE SEQUENCE account_list_s1 START WITH 1 NOCACHE;

------------

CREATE TABLE transaction_upload
( transaction_upload_id               NUMBER
  , account_number              VARCHAR2(10) CONSTRAINT nn_account_list_1 NOT NULL
  , consumed_date               DATE
  , consumed_by                 NUMBER
  , created_by                  NUMBER       CONSTRAINT nn_account_list_2 NOT NULL
  , creation_date               DATE         CONSTRAINT nn_account_list_3 NOT NULL
  , last_updated_by             NUMBER       CONSTRAINT nn_account_list_4 NOT NULL
  , last_update_date            DATE         CONSTRAINT nn_account_list_5 NOT NULL
  , CONSTRAINT pk_airport_id             PRIMARY KEY(transaction_upload_id)
  , CONSTRAINT fk_airport_1              FOREIGN KEY(consumed_by) REFERENCES system_user(system_user_id)
  , CONSTRAINT fk_airport_2              FOREIGN KEY(created_by) REFERENCES system_user(system_user_id)
  , CONSTRAINT fk_airport_3              FOREIGN KEY(last_updated_by) REFERENCES system_user(system_user_id));

------------------
CREATE SEQUENCE transaction_upload_s1 START WITH 1 NOCACHE;