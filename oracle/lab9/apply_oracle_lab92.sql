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
