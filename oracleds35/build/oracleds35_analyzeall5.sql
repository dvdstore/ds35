declare
begin
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'CATEGORIES5', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_CATEGORIES5', partname=> NULL );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'PRODUCTS5', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_PROD_ID5', partname=> NULL );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'INVENTORY5', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_INV_PROD_ID5', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_ACTOR_TEXT5', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_TITLE_TEXT5', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_PROD_CATEGORY5', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_PROD_SPECIAL5', partname=> NULL );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'CUSTOMERS5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_CUSTOMERS5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'CUST_HIST5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_CUST_HIST5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_CUST_USERNAME5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'ORDERS5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_ORDERS5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'ORDERLINES5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_ORDERLINES5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'REVIEWS5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'REVIEWS_HELPFULNESS5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'MEMBERSHIP5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_REVIEWS5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_REVIEWS_HELPFULNESS5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_MEMBERSHIP5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_HELP_CUSTID5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_HELP_REVID5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_PROD_ID5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_PRODSTARS5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_STARS5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_PROD_MEMBERSHIP5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REORDER_PRODID5', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'DERIVEDTABLE15', partname=> NULL );
end;
/
exit;

