declare
begin
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'CATEGORIES3', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_CATEGORIES3', partname=> NULL );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'PRODUCTS3', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_PROD_ID3', partname=> NULL );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'INVENTORY3', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_INV_PROD_ID3', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_ACTOR_TEXT3', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_TITLE_TEXT3', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_PROD_CATEGORY3', partname=> NULL );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_PROD_SPECIAL3', partname=> NULL );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'CUSTOMERS3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_CUSTOMERS3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'CUST_HIST3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_CUST_HIST3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_CUST_USERNAME3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'ORDERS3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_ORDERS3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'ORDERLINES3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_ORDERLINES3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'REVIEWS3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'REVIEWS_HELPFULNESS3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'MEMBERSHIP3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_REVIEWS3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_REVIEWS_HELPFULNESS3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'PK_MEMBERSHIP3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_HELP_CUSTID3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_HELP_REVID3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_PROD_ID3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_PRODSTARS3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REVIEWS_STARS3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_PROD_MEMBERSHIP3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_index_stats(ownname=> 'DS3', indname=> 'IX_REORDER_PRODID3', partname=> NULL , estimate_percent=> 18 );
dbms_stats.gather_table_stats(ownname=> 'DS3', tabname=> 'DERIVEDTABLE13', partname=> NULL );
end;
/
exit;

