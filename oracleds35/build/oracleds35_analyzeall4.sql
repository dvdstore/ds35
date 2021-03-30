declare
begin
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'CATEGORIES4', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_CATEGORIES4', partname=> NULL );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'PRODUCTS4', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_PROD_ID4', partname=> NULL );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'INVENTORY4', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_INV_PROD_ID4', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_ACTOR_TEXT4', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_TITLE_TEXT4', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_PROD_CATEGORY4', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_PROD_SPECIAL4', partname=> NULL );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'CUSTOMERS4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_CUSTOMERS4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'CUST_HIST4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_CUST_HIST4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_CUST_USERNAME4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'ORDERS4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_ORDERS4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'ORDERLINES4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_ORDERLINES4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'REVIEWS4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'REVIEWS_HELPFULNESS4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'MEMBERSHIP4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_REVIEWS4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_REVIEWS_HELPFULNESS4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_MEMBERSHIP4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_HELP_CUSTID4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_HELP_REVID4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_PROD_ID4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_PRODSTARS4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_STARS4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_PROD_MEMBERSHIP4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REORDER_PRODID4', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'DERIVEDTABLE14', partname=> NULL );
end;
/
exit;

