INSERT INTO transaction
   SELECT NVL(r.transaction_id,transaction_s1.nextval) AS transaction_id
   ,      r.transaction_account
   ,      r.transaction_type
   ,      r.transaction_date
   ,      r.transaction_amount
   ,      r.rental_lab_id
   ,      r.payment_method_type
   ,      r.payment_account_number
   ,      r.created_by
   ,      r.creation_date
   ,      r.last_updated_by
   ,      r.last_update_date
   FROM (SELECT t.transaction_id AS transaction_id
         ,      tu.account_number AS transaction_account
         ,      cl1.common_lookup_lab_id AS transaction_type
         ,      TRUNC(tu.transaction_date) AS transaction_date
         ,      SUM(tu.transaction_amount) AS transaction_amount
         ,      r.rental_lab_id
         ,      cl2.common_lookup_lab_id AS payment_method_type
         ,      tu.payment_account_number
         ,      1 AS created_by
         ,      TRUNC(SYSDATE) AS creation_date
         ,      1 AS last_updated_by
         ,      TRUNC(SYSDATE) AS last_update_date
         FROM member_lab m INNER JOIN contact_lab c
         ON   m.member_lab_id = c.member_lab_id INNER JOIN transaction_upload tu
         ON   c.first_name = tu.first_name
         AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
         AND  c.last_name = tu.last_name
         AND  tu.account_number = m.account_number INNER JOIN rental_lab r
         ON   c.contact_lab_id = r.customer_id
         AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
         AND  TRUNC(tu.return_date) = TRUNC(r.return_date)INNER JOIN common_lookup_lab cl1
   ON      cl1.common_lookup_lab_table = 'TRANSACTION'
   AND     cl1.common_lookup_lab_column = 'TRANSACTION_TYPE'
   AND     cl1.common_lookup_lab_type = tu.transaction_type INNER JOIN common_lookup_lab cl2
   ON      cl2.common_lookup_lab_table = 'TRANSACTION'
   AND     cl2.common_lookup_lab_column = 'PAYMENT_METHOD_TYPE'
   AND     cl2.common_lookup_lab_type = tu.payment_method_type LEFT JOIN transaction t
   ON t.TRANSACTION_ACCOUNT = tu.payment_account_number
   AND t.TRANSACTION_TYPE = cl1.common_lookup_lab_id
   AND t.TRANSACTION_DATE = tu.transaction_date
   AND t.TRANSACTION_AMOUNT = tu.TRANSACTION_AMOUNT
   AND t.PAYMENT_METHOD_type = cl2.common_lookup_lab_id
   AND t.PAYMENT_ACCOUNT_NUMBER = tu.payment_account_number
   GROUP BY t.transaction_id, tu.account_number, cl1.common_lookup_lab_id, tu.transaction_date,
   r.rental_lab_id, cl2.common_lookup_lab_id, tu.payment_account_number
) r;
