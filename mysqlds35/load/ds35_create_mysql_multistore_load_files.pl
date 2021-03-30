# ds3_create_mysql_multistore_load_files.pl
# Script to create a set of ds3 mysql load files for a given number of stores
# Syntax to run - perl ds3_create_mysql_multistore_load_files.pl <mysql_target> <number_of_stores> 

use strict;
use warnings;

my $mysqltarget = $ARGV[0];
my $numberofstores = $ARGV[1];

#customers 


foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">remote_mysqlds3_cust_load$k.sql") || die("Can't open remote_mysqlds3_cust_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE CUSTOMERS$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\cust\\\\us_cust.csv\" INTO TABLE CUSTOMERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\cust\\\\row_cust.csv\" INTO TABLE CUSTOMERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE CUSTOMERS$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;
\n";
	close $OUT;
	open (my $OUTBAT, ">remote_mysqlds3_cust_load$k.bat") || die("Can't open remote_mysqlds3_cust_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds3_cust_load$k.sql\n";
	print $OUTBAT "time /T > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	system ("move remote_mysqlds3_cust_load$k.bat cust\\");
	system ("move remote_mysqlds3_cust_load$k.sql cust\\");
}

# Orders 
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">remote_mysqlds3_orders_load$k.sql") || die("Can't open remote_mysqlds3_orders_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE ORDERS$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\jan_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\feb_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\mar_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\apr_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\may_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\jun_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\jul_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\aug_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\sep_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\oct_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\nov_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\dec_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE ORDERS$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;
	
\n";
	close $OUT;
	open (my $OUTBAT, ">remote_mysqlds3_orders_load$k.bat") || die("Can't open remote_mysqlds3_orders_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds3_orders_load$k.sql\n";
	#print $OUT "time /T > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	system ("move remote_mysqlds3_orders_load$k.bat orders\\");
	system ("move remote_mysqlds3_orders_load$k.sql orders\\");
}

# Orderlines 
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">remote_mysqlds3_orderlines_load$k.sql") || die("Can't open remote_mysqlds3_orderlines_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE ORDERLINES$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\jan_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\feb_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\mar_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\apr_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\may_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\jun_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\jul_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\aug_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\sep_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\oct_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\nov_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\dec_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE ORDERLINES$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;\n";
	close $OUT;
	open (my $OUTBAT, ">remote_mysqlds3_orderlines_load$k.bat") || die("Can't open remote_mysqlds3_orderlines_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds3_orderlines_load$k.sql\n";
	#print $OUTBAT "time /T > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	system ("move remote_mysqlds3_orderlines_load$k.bat orders\\");
	system ("move remote_mysqlds3_orderlines_load$k.sql orders\\");
}
# cust_hist 
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">remote_mysqlds3_cust_hist_load$k.sql") || die("Can't open remote_mysqlds3_cust_hist_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE CUST_HIST$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\jan_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\feb_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\mar_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\apr_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\may_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\jun_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\jul_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\aug_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\sep_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\oct_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\nov_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\orders\\\\dec_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE CUST_HIST$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;
\n";
	close $OUT;
	open (my $OUTBAT, ">remote_mysqlds3_cust_hist_load$k.bat") || die("Can't open remote_mysqlds3_cust_hist_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds3_cust_hist_load$k.sql\n";
	print $OUTBAT "time /T > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	system ("move remote_mysqlds3_cust_hist_load$k.bat orders\\");
	system ("move remote_mysqlds3_cust_hist_load$k.sql orders\\");
}
# prod
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">remote_mysqlds3_prod_load$k.sql") || die("Can't open remote_mysqlds3_prod_load$k.sql");
	print $OUT "use DS3;

SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE PRODUCTS$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\prod\\\\prod.csv\" INTO TABLE PRODUCTS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE PRODUCTS$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;\n";
	close $OUT;
	open (my $OUTBAT, ">remote_mysqlds3_prod_load$k.bat") || die("Can't open remote_mysqlds3_prod_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds3_prod_load$k.sql\n";
	print $OUTBAT "time /T > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	system ("move remote_mysqlds3_prod_load$k.bat prod\\");
	system ("move remote_mysqlds3_prod_load$k.sql prod\\");
}
# inv
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">remote_mysqlds3_inv_load$k.sql") || die("Can't open remote_mysqlds3_inv_load$k.sql");
	print $OUT "use DS3;

SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE INVENTORY$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\prod\\\\inv.csv\" INTO TABLE INVENTORY$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE INVENTORY$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;\n";
	close $OUT;
	open (my $OUTBAT, ">remote_mysqlds3_inv_load$k.bat") || die("Can't open remote_mysqlds3_inv_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds3_inv_load$k.sql\n";
	#print $OUTBAT "time /T > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	system ("move remote_mysqlds3_inv_load$k.bat prod\\");
	system ("move remote_mysqlds3_inv_load$k.sql prod\\");
}
#membership
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">remote_mysqlds3_membership_load$k.sql") || die("Can't open remote_mysqlds3_membership_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE MEMBERSHIP$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\membership\\\\membership.csv\" INTO TABLE MEMBERSHIP$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE MEMBERSHIP$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;\n";
	close $OUT;
	open (my $OUTBAT, ">remote_mysqlds3_membership_load$k.bat") || die("Can't open remote_mysqlds3_membership_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds3_membership_load$k.sql\n";
	print $OUTBAT "time /T > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	system ("move remote_mysqlds3_membership_load$k.sql membership\\");
	system ("move remote_mysqlds3_membership_load$k.bat membership\\");
}
#reviews
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">remote_mysqlds3_reviews_load$k.sql") || die("Can't open remote_mysqlds3_reviews_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE REVIEWS$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\reviews\\\\reviews.csv\" INTO TABLE REVIEWS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE REVIEWS$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;\n";
	close $OUT;
	open (my $OUTBAT, ">remote_mysqlds3_reviews_load$k.bat") || die("Can't open remote_mysqlds3_reviews_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds3_reviews_load$k.sql\n";
	print $OUTBAT "time /T > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	system ("move remote_mysqlds3_reviews_load$k.bat reviews\\");
	system ("move remote_mysqlds3_reviews_load$k.sql reviews\\");
}


#reviews helpfulness
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">remote_mysqlds3_reviewshelpful_load$k.sql") || die("Can't open remote_mysqlds3_reviewshelpful_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE REVIEWS_HELPFULNESS$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..\\\\..\\\\..\\\\data_files\\\\reviews\\\\review_helpfulness.csv\" INTO TABLE REVIEWS_HELPFULNESS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE REVIEWS_HELPFULNESS$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;\n";
	close $OUT;
	open (my $OUTBAT, ">remote_mysqlds3_reviewshelpful_load$k.bat") || die("Can't open remote_mysqlds3_reviewshelpful_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds3_reviewshelpful_load$k.sql\n";
	#print $OUTBAT "time /T > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	system ("move remote_mysqlds3_reviewshelpful_load$k.bat reviews\\");
	system ("move remote_mysqlds3_reviewshelpful_load$k.sql reviews\\");
}