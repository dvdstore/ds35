-- Reset sequences

\c ds3;



-- Reset Sequences after load

SELECT setval(CONCAT('categories10','_category_seq'),max(category)) FROM categories10;
SELECT setval(CONCAT('customers10', '_customerid_seq'),max(customerid)) FROM customers10;
SELECT setval(CONCAT('orders10','_orderid_seq'),max(orderid)) FROM orders10;
SELECT setval(CONCAT('products10','_prod_id_seq'),max(prod_id)) FROM products10;
SELECT setval(CONCAT('reviews10','_review_id_seq'),max(review_id)) from reviews10;
SELECT setval(CONCAT('reviews_helpfulness10','_review_helpfulness_id_seq'),max(review_helpfulness_id)) from reviews_helpfulness10;



