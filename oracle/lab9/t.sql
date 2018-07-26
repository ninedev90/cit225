SELECT   COUNT(*)
FROM    (SELECT   rental_item_lab_id
         ,        r.rental_lab_id
         ,        tu.item_lab_id
         ,        TRUNC(r.return_date) - TRUNC(r.check_out_date) AS rental_item_lab_price
         ,        cl.common_lookup_lab_id AS rental_item_lab_type
         ,        3 AS created_by
         ,        TRUNC(creation_date) AS creation_date
         ,        3 AS last_updated_by
         ,        TRUNC(last_update_date) AS last_update_date
         FROM member_lab m 
        INNER JOIN contact_lab c ON m.member_lab_id = c.member_lab_id 
        INNER JOIN transaction_upload tu ON c.first_name = tu.first_name
        AND  NVL(c.middle_name,'x') = NVL(tu.middle_name,'x')
        AND  c.last_name = tu.last_name
        AND  tu.account_number = m.account_number 
        LEFT JOIN rental_lab r ON c.contact_lab_id = r.customer_id
        AND  TRUNC(tu.check_out_date) = TRUNC(r.check_out_date)
        AND  TRUNC(tu.return_date) = TRUNC(r.return_date)) il;
