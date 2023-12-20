# ds35_create_pgsql_multistore_load_files.pl
# Script to create a set of ds35 pgsql load files for a given number of stores
# Syntax to run - perl ds35_create_pgsql_multistore_load_files.pl <psql_target> <number_of_stores> 

use strict;
use warnings;

my $psqltarget = $ARGV[0];
my $numStores = $ARGV[1];

my $SYSDBA = "ds3";
my $DBNAME = "ds3";
my $PGPASSWORD = "ds3";

my $movecommand;
my $timecommand;
my $pathsep;

#Need seperate target directory so that mulitple DB Targets can be loaded at the same time
my $pgsql_targetdir;  

$pgsql_targetdir = $psqltarget;

# remove any backslashes from string to be used for directory name
$pgsql_targetdir =~ s/\\//;

system ("mkdir cust\\$pgsql_targetdir");
system ("mkdir orders\\$pgsql_targetdir");
system ("mkdir reviews\\$pgsql_targetdir");
system ("mkdir prod\\$pgsql_targetdir");
system ("mkdir membership\\$pgsql_targetdir");

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

# Customers

foreach my $k (1 .. $numStores){
open (my $OUT, ">cust$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_cust_load$k.sql") || die("Can't open remote_pgsqlds35_cust_load$k.sql");
	print $OUT "\\c ds3;

ALTER TABLE CUSTOMERS$k DISABLE TRIGGER ALL;

\\COPY CUSTOMERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}cust${pathsep}us_cust.csv' WITH DELIMITER ','
\\COPY CUSTOMERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}cust${pathsep}row_cust.csv' WITH DELIMITER ','

ALTER TABLE CUSTOMERS$k ENABLE TRIGGER ALL;
\n";
	close $OUT;
        open (my $OUTBAT, ">cust$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_cust_load$k.bat") || die("Can't open remote_pgsqlds35_cust_load$k.bat");
		print $OUTBAT "set PGPASSWORD=ds3\n";
		print $OUTBAT "psql -h $psqltarget -U $SYSDBA -d $DBNAME -f remote_pgsqlds35_cust_load$k.sql\n";
        print $OUTBAT "$timecommand > finished$k.txt\n";
        print $OUTBAT "exit\n";
        close $OUTBAT;
}

# Orders

foreach my $k (1 .. $numStores){
	open (my $OUT, ">orders$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_orders_load$k.sql") || die("Can't open remote_pgsqlds35_orders_load$k.sql");
	print $OUT "\\c ds3;

ALTER TABLE ORDERS$k DISABLE TRIGGER ALL;

\\COPY ORDERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jan_orders.csv' WITH DELIMITER ','
\\COPY ORDERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}feb_orders.csv' WITH DELIMITER ','
\\COPY ORDERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}mar_orders.csv' WITH DELIMITER ','
\\COPY ORDERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}apr_orders.csv' WITH DELIMITER ','
\\COPY ORDERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}may_orders.csv' WITH DELIMITER ','
\\COPY ORDERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jun_orders.csv' WITH DELIMITER ','
\\COPY ORDERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jul_orders.csv' WITH DELIMITER ','
\\COPY ORDERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}aug_orders.csv' WITH DELIMITER ','
\\COPY ORDERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}sep_orders.csv' WITH DELIMITER ','
\\COPY ORDERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}oct_orders.csv' WITH DELIMITER ','
\\COPY ORDERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}nov_orders.csv' WITH DELIMITER ','
\\COPY ORDERS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}dec_orders.csv' WITH DELIMITER ','

ALTER TABLE ORDERS$k ENABLE TRIGGER ALL;

\n";
	close $OUT;
        open (my $OUTBAT, ">orders$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_orders_load$k.bat") || die("Can't open remote_pgsqlds35_orders_load$k.bat");
		print $OUTBAT "set PGPASSWORD=ds3\n";
        print $OUTBAT "psql -h $psqltarget -U $SYSDBA -d $DBNAME -f remote_pgsqlds35_orders_load$k.sql\n";
        #print $OUT "$timecommand > finished$k.txt\n";
        print $OUTBAT "exit\n";
        close $OUTBAT;
}

# Orderlines

foreach my $k (1 .. $numStores){
	open (my $OUT, ">orders$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_orderlines_load$k.sql") || die("Can't open remote_pgsqlds35_orderlines_load$k.sql");
        print $OUT "\\c ds3;

ALTER TABLE ORDERLINES$k DISABLE TRIGGER ALL;

\\COPY ORDERLINES$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jan_orderlines.csv' WITH DELIMITER ','
\\COPY ORDERLINES$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}feb_orderlines.csv' WITH DELIMITER ','
\\COPY ORDERLINES$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}mar_orderlines.csv' WITH DELIMITER ','
\\COPY ORDERLINES$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}apr_orderlines.csv' WITH DELIMITER ','
\\COPY ORDERLINES$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}may_orderlines.csv' WITH DELIMITER ','
\\COPY ORDERLINES$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jun_orderlines.csv' WITH DELIMITER ','
\\COPY ORDERLINES$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jul_orderlines.csv' WITH DELIMITER ','
\\COPY ORDERLINES$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}aug_orderlines.csv' WITH DELIMITER ','
\\COPY ORDERLINES$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}sep_orderlines.csv' WITH DELIMITER ','
\\COPY ORDERLINES$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}oct_orderlines.csv' WITH DELIMITER ','
\\COPY ORDERLINES$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}nov_orderlines.csv' WITH DELIMITER ','
\\COPY ORDERLINES$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}dec_orderlines.csv' WITH DELIMITER ','

ALTER TABLE ORDERLINES$k ENABLE TRIGGER ALL;

\n";
	close $OUT;
        open (my $OUTBAT, ">orders$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_orderlines_load$k.bat") || die("Can't open remote_pgsqlds35_orderlines_load$k.bat");
		print $OUTBAT "set PGPASSWORD=ds3\n";
        print $OUTBAT "psql -h $psqltarget -U $SYSDBA -d $DBNAME -f remote_pgsqlds35_orderlines_load$k.sql\n";
        print $OUTBAT "exit\n";
        close $OUTBAT;
}
# cust_hist

foreach my $k (1 .. $numStores){
        open (my $OUT, ">orders$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_cust_hist_load$k.sql") || die("Can't open remote_pgsqlds35_cust_hist_load$k.sql");
        print $OUT "\\c ds3;

ALTER TABLE CUST_HIST$k DISABLE TRIGGER ALL;

\\COPY CUST_HIST$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jan_cust_hist.csv' WITH DELIMITER ','
\\COPY CUST_HIST$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}feb_cust_hist.csv' WITH DELIMITER ','
\\COPY CUST_HIST$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}mar_cust_hist.csv' WITH DELIMITER ','
\\COPY CUST_HIST$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}apr_cust_hist.csv' WITH DELIMITER ','
\\COPY CUST_HIST$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}may_cust_hist.csv' WITH DELIMITER ','
\\COPY CUST_HIST$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jun_cust_hist.csv' WITH DELIMITER ','
\\COPY CUST_HIST$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}jul_cust_hist.csv' WITH DELIMITER ','
\\COPY CUST_HIST$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}aug_cust_hist.csv' WITH DELIMITER ','
\\COPY CUST_HIST$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}sep_cust_hist.csv' WITH DELIMITER ','
\\COPY CUST_HIST$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}oct_cust_hist.csv' WITH DELIMITER ','
\\COPY CUST_HIST$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}nov_cust_hist.csv' WITH DELIMITER ','
\\COPY CUST_HIST$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}orders${pathsep}dec_cust_hist.csv' WITH DELIMITER ','

ALTER TABLE CUST_HIST$k ENABLE TRIGGER ALL;

\n";
	close $OUT;
        open (my $OUTBAT, ">orders$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_cust_hist_load$k.bat") || die("Can't open remote_pgsqlds35_cust_hist_load$k.bat");
		print $OUTBAT "set PGPASSWORD=ds3\n";
		print $OUTBAT "psql -h $psqltarget -U $SYSDBA -d $DBNAME -f remote_pgsqlds35_cust_hist_load$k.sql\n";
        print $OUTBAT "$timecommand > finished$k.txt\n";
        print $OUTBAT "exit\n";
        close $OUTBAT;
}

#prod

foreach my $k (1 .. $numStores){
	open (my $OUT, ">prod$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_prod_load$k.sql") || die("Can't open remote_pgsqlds35_prod_load$k.sql");
        print $OUT "\\c ds3;

ALTER TABLE PRODUCTS$k DISABLE TRIGGER ALL;

\\COPY PRODUCTS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}prod${pathsep}prod.csv' WITH DELIMITER ','

ALTER TABLE PRODUCTS$k ENABLE TRIGGER ALL;
\n";
	close $OUT;
        open (my $OUTBAT, ">prod$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_prod_load$k.bat") || die("Can't open remote_pgsqlds35_prod_load$k.bat");
		print $OUTBAT "set PGPASSWORD=ds3\n";
        print $OUTBAT "psql -h $psqltarget -U $SYSDBA -d $DBNAME -f remote_pgsqlds35_prod_load$k.sql\n";
        print $OUTBAT "$timecommand > finished$k.txt\n";
        print $OUTBAT "exit\n";
        close $OUTBAT;
}

# inv
foreach my $k (1 .. $numStores){
	open (my $OUT, ">prod$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_inv_load$k.sql") || die("Can't open remote_pgsqlds35_inv_load$k.sql");
        print $OUT "\\c ds3;

ALTER TABLE INVENTORY$k DISABLE TRIGGER ALL;

\\COPY INVENTORY$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}prod${pathsep}inv.csv' WITH DELIMITER ','

ALTER TABLE INVENTORY$k ENABLE TRIGGER ALL;
\n";
	close $OUT;
        open (my $OUTBAT, ">prod$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_inv_load$k.bat") || die("Can't open remote_pgsqlds35_inv_load$k.bat");
		print $OUTBAT "set PGPASSWORD=ds3\n";
        print $OUTBAT "psql -h $psqltarget -U $SYSDBA -d $DBNAME -f remote_pgsqlds35_inv_load$k.sql\n";
        #print $OUTBAT "$timecommand > finished$k.txt\n";
        print $OUTBAT "exit\n";
        close $OUTBAT;
}

# membership

foreach my $k (1 .. $numStores){
        open (my $OUT, ">membership$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_membership_load$k.sql") || die("Can't open remote_pgsqlds35_membership_load$k.sql");
        print $OUT "\\c ds3;

ALTER TABLE MEMBERSHIP$k DISABLE TRIGGER ALL;

\\COPY MEMBERSHIP$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}membership${pathsep}membership.csv' WITH DELIMITER ','

ALTER TABLE MEMBERSHIP$k ENABLE TRIGGER ALL;
	
\n";
        close $OUT;
        open (my $OUTBAT, ">membership$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_membership_load$k.bat") || die("Can't open remote_pgsqlds35_membership_load$k.bat");
		print $OUTBAT "set PGPASSWORD=ds3\n";
		print $OUTBAT "psql -h $psqltarget -U $SYSDBA -d $DBNAME -f remote_pgsqlds35_membership_load$k.sql\n";
		print $OUTBAT "$timecommand > finished$k.txt\n";
        print $OUTBAT "exit\n";
        close $OUTBAT;
}

# Reviews

foreach my $k (1 .. $numStores){
        open (my $OUT, ">reviews$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_reviews_load$k.sql") || die("Can't open remote_pgsqlds35_reviews_load$k.sql");
        print $OUT "\\c ds3;

ALTER TABLE REVIEWS$k DISABLE TRIGGER ALL;

\\COPY REVIEWS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}reviews${pathsep}reviews.csv' WITH DELIMITER ','

ALTER TABLE REVIEWS$k ENABLE TRIGGER ALL;
\n";
        close $OUT;
        open (my $OUTBAT, ">reviews$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_reviews_load$k.bat") || die("Can't open remote_pgsqlds35_reviews_load$k.bat");
		print $OUTBAT "set PGPASSWORD=ds3\n";
        print $OUTBAT "psql -h $psqltarget -U $SYSDBA -d $DBNAME -f remote_pgsqlds35_reviews_load$k.sql\n";
        print $OUTBAT "$timecommand > finishedreview$k.txt\n";
        print $OUTBAT "exit\n";
        close $OUTBAT;
}

# reviews helpfulness

foreach my $k (1 .. $numStores){
        open (my $OUT, ">reviews$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_reviewshelpful_load$k.sql") || die("Can't open remote_pgsqlds35_reviewshelpful_load$k.sql");
        print $OUT "\\c ds3;

ALTER TABLE REVIEWS_HELPFULNESS$k DISABLE TRIGGER ALL;

\\COPY REVIEWS_HELPFULNESS$k FROM '..$pathsep..$pathsep..$pathsep..${pathsep}data_files${pathsep}reviews${pathsep}review_helpfulness.csv' WITH DELIMITER ','

ALTER TABLE REVIEWS_HELPFULNESS$k ENABLE TRIGGER ALL;
\n";
        close $OUT;
        open (my $OUTBAT, ">reviews$pathsep$pgsql_targetdir${pathsep}remote_pgsqlds35_reviewshelpful_load$k.bat") || die("Can't open remote_pgsqlds35_reviewshelpful_load$k.bat");
		print $OUTBAT "set PGPASSWORD=ds3\n";
        print $OUTBAT "psql -h $psqltarget -U $SYSDBA -d $DBNAME -f remote_pgsqlds35_reviewshelpful_load$k.sql\n";
        print $OUTBAT "$timecommand > finishedhelp$k.txt\n";
        print $OUTBAT "exit\n";
        close $OUTBAT;
}




