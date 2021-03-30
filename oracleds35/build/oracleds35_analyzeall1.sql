declare
begin
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'CATEGORIES1', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_CATEGORIES1', partname=> NULL );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'PRODUCTS1', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_PROD_ID1', partname=> NULL );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'INVENTORY1', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_INV_PROD_ID1', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_ACTOR_TEXT1', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_TITLE_TEXT1', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_PROD_CATEGORY1', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_PROD_SPECIAL1', partname=> NULL );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'CUSTOMERS1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_CUSTOMERS1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'CUST_HIST1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_CUST_HIST1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_CUST_USERNAME1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'ORDERS1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_ORDERS1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'ORDERLINES1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_ORDERLINES1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'REVIEWS1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'REVIEWS_HELPFULNESS1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'MEMBERSHIP1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_REVIEWS1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_REVIEWS_HELPFULNESS1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_MEMBERSHIP1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_HELP_CUSTID1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_HELP_REVID1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_PROD_ID1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_PRODSTARS1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_STARS1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_PROD_MEMBERSHIP1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REORDER_PRODID1', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'DERIVEDTABLE11', partname=> NULL );
end;
/
exit;

