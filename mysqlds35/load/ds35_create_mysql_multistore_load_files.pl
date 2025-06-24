# ds3_create_mysql_multistore_load_files.pl
# Script to create a set of ds3 mysql load files for a given number of stores
# Syntax to run - perl ds3_create_mysql_multistore_load_files.pl <mysql_target> <number_of_stores> 

use strict;
use warnings;

my $mysqltarget = $ARGV[0];
my $numberofstores = $ARGV[1];

my $movecommand;
my $timecommand;
my $pathsep;
my $pathsep2 = "\\\\";

#Need seperate target directory so that mulitple DB Targets can be loaded at the same time
my $mysql_targetdir;  

$mysql_targetdir = $mysqltarget;

# remove any backslashes from string to be used for directory name
$mysql_targetdir =~ s/\\//;

print "$^O\n";

# This section enables support for Linux and Windows - detecting the type of OS, and then using the proper commands 
if ("$^O" eq "linux")
	{
	$movecommand = "mv";
	$timecommand = "date";
	$pathsep = "/";
	}
else
	{
	$movecommand = "move";
	$timecommand = "time /T";
        $pathsep = "\\\\";
	};

system ("mkdir cust${pathsep}$mysql_targetdir");
system ("mkdir orders${pathsep}$mysql_targetdir");
system ("mkdir reviews${pathsep}$mysql_targetdir");
system ("mkdir prod${pathsep}$mysql_targetdir");
system ("mkdir membership${pathsep}$mysql_targetdir");

#customers 


foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">cust$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_cust_load$k.sql") || die("Can't open cust$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_cust_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE CUSTOMERS$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}cust${pathsep}us_cust.csv\" INTO TABLE CUSTOMERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}cust${pathsep}row_cust.csv\" INTO TABLE CUSTOMERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE CUSTOMERS$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;
\n";
	close $OUT;
	open (my $OUTBAT, ">cust$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_cust_load$k.bat") || die("Can't open cust$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_cust_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds35_cust_load$k.sql\n";
	print $OUTBAT "$timecommand > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	#system ("$movecommand remote_mysqlds35_cust_load$k.bat cust$pathsep");
	#system ("$movecommand remote_mysqlds35_cust_load$k.sql cust$pathsep");
}

# Orders 
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">orders$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_orders_load$k.sql") || die("Can't open orders$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_orders_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE ORDERS$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jan_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}feb_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}mar_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}apr_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}may_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jun_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jul_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}aug_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}sep_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}oct_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}nov_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}dec_orders.csv\" INTO TABLE ORDERS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE ORDERS$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;
	
\n";
	close $OUT;
	open (my $OUTBAT, ">orders$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_orders_load$k.bat") || die("Can't open orders$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_orders_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds35_orders_load$k.sql\n";
	#print $OUT "$timecommand > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	#system ("$movecommand remote_mysqlds35_orders_load$k.bat orders$pathsep");
	#system ("$movecommand remote_mysqlds35_orders_load$k.sql orders$pathsep");
}

# Orderlines 
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">orders$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_orderlines_load$k.sql") || die("Can't open orders$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_orderlines_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE ORDERLINES$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jan_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}feb_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}mar_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}apr_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}may_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jun_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jul_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}aug_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}sep_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}oct_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}nov_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}dec_orderlines.csv\" INTO TABLE ORDERLINES$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE ORDERLINES$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;\n";
	close $OUT;
	open (my $OUTBAT, ">orders$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_orderlines_load$k.bat") || die("Can't open orders$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_orderlines_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds35_orderlines_load$k.sql\n";
	#print $OUTBAT "$timecommand > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	#system ("$movecommand remote_mysqlds35_orderlines_load$k.bat orders$pathsep");
	#system ("$movecommand remote_mysqlds35_orderlines_load$k.sql orders$pathsep");
}
# cust_hist 
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">orders$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_cust_hist_load$k.sql") || die("Can't open orders$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_cust_hist_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE CUST_HIST$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jan_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}feb_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}mar_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}apr_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}may_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jun_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jul_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}aug_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}sep_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}oct_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}nov_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';
LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}dec_cust_hist.csv\" INTO TABLE CUST_HIST$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE CUST_HIST$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;
\n";
	close $OUT;
	open (my $OUTBAT, ">orders$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_cust_hist_load$k.bat") || die("Can't open orders$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_cust_hist_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds35_cust_hist_load$k.sql\n";
	print $OUTBAT "$timecommand > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	#system ("$movecommand remote_mysqlds35_cust_hist_load$k.bat orders$pathsep");
	#system ("$movecommand remote_mysqlds35_cust_hist_load$k.sql orders$pathsep");
}
# prod
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">prod$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_prod_load$k.sql") || die("Can't open prod$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_prod_load$k.sql");
	print $OUT "use DS3;

SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE PRODUCTS$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}prod${pathsep}prod.csv\" INTO TABLE PRODUCTS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE PRODUCTS$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;\n";
	close $OUT;
	open (my $OUTBAT, ">prod$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_prod_load$k.bat") || die("Can't open prod$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_prod_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds35_prod_load$k.sql\n";
	print $OUTBAT "$timecommand > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	#system ("$movecommand remote_mysqlds35_prod_load$k.bat prod$pathsep");
	#system ("$movecommand remote_mysqlds35_prod_load$k.sql prod$pathsep");
}
# inv
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">prod$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_inv_load$k.sql") || die("Can't open prod$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_inv_load$k.sql");
	print $OUT "use DS3;

SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE INVENTORY$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}prod${pathsep}inv.csv\" INTO TABLE INVENTORY$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE INVENTORY$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;\n";
	close $OUT;
	open (my $OUTBAT, ">prod$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_inv_load$k.bat") || die("Can't open prod$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_inv_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds35_inv_load$k.sql\n";
	#print $OUTBAT "$timecommand > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	#system ("$movecommand remote_mysqlds35_inv_load$k.bat prod$pathsep");
	#system ("$movecommand remote_mysqlds35_inv_load$k.sql prod$pathsep");
}
#membership
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">membership$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_membership_load$k.sql") || die("Can't open membership$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_membership_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE MEMBERSHIP$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}membership${pathsep}membership.csv\" INTO TABLE MEMBERSHIP$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE MEMBERSHIP$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;\n";
	close $OUT;
	open (my $OUTBAT, ">membership$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_membership_load$k.bat") || die("Can't open membership$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_membership_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds35_membership_load$k.sql\n";
	print $OUTBAT "$timecommand > finished$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	#system ("$movecommand remote_mysqlds35_membership_load$k.sql membership$pathsep");
	#system ("$movecommand remote_mysqlds35_membership_load$k.bat membership$pathsep");
}
#reviews
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">reviews$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_reviews_load$k.sql") || die("Can't open reviews$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_reviews_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE REVIEWS$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}reviews${pathsep}reviews.csv\" INTO TABLE REVIEWS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE REVIEWS$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;\n";
	close $OUT;
	open (my $OUTBAT, ">reviews$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_reviews_load$k.bat") || die("Can't open reviews$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_reviews_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds35_reviews_load$k.sql\n";
	print $OUTBAT "$timecommand > finishedreview$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	#system ("$movecommand remote_mysqlds35_reviews_load$k.bat reviews$pathsep");
	#system ("$movecommand remote_mysqlds35_reviews_load$k.sql reviews$pathsep");
}


#reviews helpfulness
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">reviews$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_reviewshelpful_load$k.sql") || die("Can't open reviews$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_reviewshelpful_load$k.sql");
	print $OUT "use DS3;
SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;
ALTER TABLE REVIEWS_HELPFULNESS$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}reviews${pathsep}review_helpfulness.csv\" INTO TABLE REVIEWS_HELPFULNESS$k FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '\"';

ALTER TABLE REVIEWS_HELPFULNESS$k ENABLE KEYS;
SET UNIQUE_CHECKS=1;
SET FOREIGN_KEY_CHECKS=1;\n";
	close $OUT;
	open (my $OUTBAT, ">reviews$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_reviewshelpful_load$k.bat") || die("Can't open reviews$pathsep$mysql_targetdir${pathsep}remote_mysqlds35_reviewshelpful_load$k.bat");
	print $OUTBAT "mysql -h $mysqltarget -u web --password=web --local_infile DS3 < remote_mysqlds35_reviewshelpful_load$k.sql\n";
	print $OUTBAT "$timecommand > finishedhelp$k.txt\n";
	print $OUTBAT "exit\n";
	close $OUTBAT;
	sleep(.1);
	#system ("$movecommand remote_mysqlds35_reviewshelpful_load$k.bat reviews$pathsep");
	#system ("$movecommand remote_mysqlds35_reviewshelpful_load$k.sql reviews$pathsep");
}
