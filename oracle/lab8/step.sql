alter table rental_item_lab
modify (rental_item_lab_price Number constraint nn_rental_item_lab_7 not null);

COLUMN CONSTRAINT FORMAT A10
SELECT   TABLE_NAME
,        column_name
,        CASE
           WHEN NULLABLE = 'N' THEN 'NOT NULL'
           ELSE 'NULLABLE'
         END AS CONSTRAINT
FROM     user_tab_columns
WHERE    TABLE_NAME = 'RENTAL_ITEM_LAB'
AND      column_name = 'RENTAL_ITEM_LAB_PRICE';
