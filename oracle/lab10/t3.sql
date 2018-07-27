INSERT INTO rental_lab
SELECT NVL(r.rental_lab_id,rental_lab_s1.NEXTVAL) AS rental_lab_id
,      r.contact_lab_id
,      r.check_out_date
,      r.return_date
,      r.created_by
,      r.creation_date
,      r.last_updated_by
,      r.last_update_date
FROM (SELECT DISTINCT r.rental_lab_id
        ,      c.contact_lab_id
        ,      TRUNC(tu.check_out_date) AS check_out_date
        ,      TRUNC(tu.return_date) AS return_date
        ,      3 AS created_by
        ,      TRUNC(SYSDATE) AS creation_date
        ,      3 AS last_updated_by
        ,      TRUNC(SYSDATE) AS last_update_date
        FROM member_lab m 
        INNER JOIN contact_lab c ON m.member_lab_id = c.member_lab_id 
        INNER JOIN transaction_upload tu ON c.first_name = tu.first_name
        AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
        AND  c.last_name = tu.last_name
        AND  tu.account_number = m.account_number 
        LEFT JOIN rental_lab r ON c.contact_lab_id = r.customer_id
        AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
        AND  TRUNC(tu.return_date) = TRUNC(r.return_date)
) r;