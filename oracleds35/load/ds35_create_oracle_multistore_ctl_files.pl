# ds35_create_oracle_multistore_ctl_files.pl
# Script to create a set of ds3 oracle sqlldr ctl files for a given number of stores
# Syntax to run - perl ds3_create_oracle_multistore_ctl_files.pl <oracle_target> <number_of_stores> 

use strict;
use warnings;

my $oracletarget = $ARGV [0];
my $numberofstores = $ARGV[1];

#Create customer tables scripts to call sqlldr and the ctl files that define the import

#Need seperate target directory so that mulitple DB Targets can be loaded at the same time
my $oracletargetdir;  

$oracletargetdir = $oracletarget;

# remove any backslashes from string to be used for directory name
$oracletargetdir =~ s/\\//;


system ("mkdir cust\\$oracletargetdir");
system ("mkdir orders\\$oracletargetdir");
system ("mkdir reviews\\$oracletargetdir");
system ("mkdir prod\\$oracletargetdir");
system ("mkdir membership\\$oracletargetdir");


foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">cust\\$oracletargetdir\\remote_oracleds35_cust_sqlldr$k.bat") || die("Can't open remote_oracleds35_cust_sqlldr$k.bat");
	print $OUT "sqlldr ds3/ds3\@$oracletarget CONTROL=us_cust$k.ctl, LOG=us$k.log, BAD=us$k.bad, DATA=..\\..\\..\\..\\data_files\\cust\\us_cust.csv\n";
	print $OUT "sqlldr ds3/ds3\@$oracletarget CONTROL=row_cust$k.ctl, LOG=row$k.log, BAD=row$k.bad, DATA=..\\..\\..\\..\\data_files\\cust\\row_cust.csv\n"; 
	print $OUT "finish > finished$k.txt\n";
	print $OUT "exit\n";
	close $OUT;

	system ("perl ds35_create_oracle_sqlldr_ctl.pl customers$k CUST cust\\$oracletargetdir\\us_cust$k.ctl US_PART");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl customers$k CUST cust\\$oracletargetdir\\row_cust$k.ctl ROW_PART");
    #sleep(.1);
	#system ("move remote_oracleds35_cust_sqlldr$k.bat $oracletargetdir/cust\\");
	#system ("move us_cust$k.ctl $oracletargetdir/cust\\");
	#system ("move row_cust$k.ctl $oracletargetdir/cust\\");
	
}

# Orders 
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">orders\\$oracletargetdir\\remote_oracleds35_orders_sqlldr$k.bat") || die("Can't open remote_oracleds35_orders_sqlldr$k.bat");
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=jan_orders$k.ctl, LOG=jan_orders$k.log, BAD=jan_orders$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\jan_orders.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=feb_orders$k.ctl, LOG=feb_orders$k.log, BAD=feb_orders$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\feb_orders.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=mar_orders$k.ctl, LOG=mar_orders$k.log, BAD=mar_orders$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\mar_orders.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=apr_orders$k.ctl, LOG=apr_orders$k.log, BAD=apr_orders$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\apr_orders.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=may_orders$k.ctl, LOG=may_orders$k.log, BAD=may_orders$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\may_orders.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=jun_orders$k.ctl, LOG=jun_orders$k.log, BAD=jun_orders$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\jun_orders.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=jul_orders$k.ctl, LOG=jul_orders$k.log, BAD=jul_orders$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\jul_orders.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=aug_orders$k.ctl, LOG=aug_orders$k.log, BAD=aug_orders$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\aug_orders.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=sep_orders$k.ctl, LOG=sep_orders$k.log, BAD=sep_orders$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\sep_orders.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=oct_orders$k.ctl, LOG=oct_orders$k.log, BAD=oct_orders$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\oct_orders.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=nov_orders$k.ctl, LOG=nov_orders$k.log, BAD=nov_orders$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\nov_orders.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=dec_orders$k.ctl, LOG=dec_orders$k.log, BAD=dec_orders$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\dec_orders.csv\n"; 
	print $OUT "exit\n";
	close $OUT;
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orders$k ORDERS orders\\$oracletargetdir\\jan_orders$k.ctl JAN2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orders$k ORDERS orders\\$oracletargetdir\\feb_orders$k.ctl FEB2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orders$k ORDERS orders\\$oracletargetdir\\mar_orders$k.ctl MAR2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orders$k ORDERS orders\\$oracletargetdir\\apr_orders$k.ctl APR2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orders$k ORDERS orders\\$oracletargetdir\\may_orders$k.ctl MAY2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orders$k ORDERS orders\\$oracletargetdir\\jun_orders$k.ctl JUN2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orders$k ORDERS orders\\$oracletargetdir\\jul_orders$k.ctl JUL2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orders$k ORDERS orders\\$oracletargetdir\\aug_orders$k.ctl AUG2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orders$k ORDERS orders\\$oracletargetdir\\sep_orders$k.ctl SEP2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orders$k ORDERS orders\\$oracletargetdir\\oct_orders$k.ctl OCT2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orders$k ORDERS orders\\$oracletargetdir\\nov_orders$k.ctl NOV2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orders$k ORDERS orders\\$oracletargetdir\\dec_orders$k.ctl DEC2013");
    #sleep(.1);
	#system ("move remote_oracleds35_orders_sqlldr$k.bat $oracletargetdir/orders\\");
	#system ("move *orders$k.ctl $oracletargetdir/orders\\");
}

# Orderlines 
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">orders\\$oracletargetdir\\remote_oracleds35_orderlines_sqlldr$k.bat") || die("Can't open remote_oracleds35_orderlines_sqlldr$k.bat");
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=jan_orderlines$k.ctl, LOG=jan_orderlines$k.log, BAD=jan_orderlines$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\jan_orderlines.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=feb_orderlines$k.ctl, LOG=feb_orderlines$k.log, BAD=feb_orderlines$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\feb_orderlines.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=mar_orderlines$k.ctl, LOG=mar_orderlines$k.log, BAD=mar_orderlines$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\mar_orderlines.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=apr_orderlines$k.ctl, LOG=apr_orderlines$k.log, BAD=apr_orderlines$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\apr_orderlines.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=may_orderlines$k.ctl, LOG=may_orderlines$k.log, BAD=may_orderlines$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\may_orderlines.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=jun_orderlines$k.ctl, LOG=jun_orderlines$k.log, BAD=jun_orderlines$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\jun_orderlines.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=jul_orderlines$k.ctl, LOG=jul_orderlines$k.log, BAD=jul_orderlines$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\jul_orderlines.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=aug_orderlines$k.ctl, LOG=aug_orderlines$k.log, BAD=aug_orderlines$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\aug_orderlines.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=sep_orderlines$k.ctl, LOG=sep_orderlines$k.log, BAD=sep_orderlines$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\sep_orderlines.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=oct_orderlines$k.ctl, LOG=oct_orderlines$k.log, BAD=oct_orderlines$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\oct_orderlines.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=nov_orderlines$k.ctl, LOG=nov_orderlines$k.log, BAD=nov_orderlines$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\nov_orderlines.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=dec_orderlines$k.ctl, LOG=dec_orderlines$k.log, BAD=dec_orderlines$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\dec_orderlines.csv\n"; 
	print $OUT "exit\n";
	close $OUT;
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orderlines$k ORDERLINES orders\\$oracletargetdir\\jan_orderlines$k.ctl JAN2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orderlines$k ORDERLINES orders\\$oracletargetdir\\feb_orderlines$k.ctl FEB2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orderlines$k ORDERLINES orders\\$oracletargetdir\\mar_orderlines$k.ctl MAR2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orderlines$k ORDERLINES orders\\$oracletargetdir\\apr_orderlines$k.ctl APR2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orderlines$k ORDERLINES orders\\$oracletargetdir\\may_orderlines$k.ctl MAY2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orderlines$k ORDERLINES orders\\$oracletargetdir\\jun_orderlines$k.ctl JUN2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orderlines$k ORDERLINES orders\\$oracletargetdir\\jul_orderlines$k.ctl JUL2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orderlines$k ORDERLINES orders\\$oracletargetdir\\aug_orderlines$k.ctl AUG2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orderlines$k ORDERLINES orders\\$oracletargetdir\\sep_orderlines$k.ctl SEP2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orderlines$k ORDERLINES orders\\$oracletargetdir\\oct_orderlines$k.ctl OCT2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orderlines$k ORDERLINES orders\\$oracletargetdir\\nov_orderlines$k.ctl NOV2013");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl orderlines$k ORDERLINES orders\\$oracletargetdir\\dec_orderlines$k.ctl DEC2013");
    #sleep(.1);
	#system ("move remote_oracleds35_orderlines_sqlldr$k.bat $oracletargetdir/orders\\");
	#system ("move *orderlines$k.ctl $oracletargetdir/orders\\");
}
# cust_hist 
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">orders\\$oracletargetdir\\remote_oracleds35_cust_hist_sqlldr$k.bat") || die("Can't open remote_oracleds35_cust_hist_sqlldr$k.bat");
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=cust_hist$k.ctl, LOG=jan_cust_hist$k.log, BAD=jan_cust_hist$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\jan_cust_hist.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=cust_hist$k.ctl, LOG=feb_cust_hist$k.log, BAD=feb_cust_hist$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\feb_cust_hist.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=cust_hist$k.ctl, LOG=mar_cust_hist$k.log, BAD=mar_cust_hist$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\mar_cust_hist.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=cust_hist$k.ctl, LOG=apr_cust_hist$k.log, BAD=apr_cust_hist$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\apr_cust_hist.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=cust_hist$k.ctl, LOG=may_cust_hist$k.log, BAD=may_cust_hist$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\may_cust_hist.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=cust_hist$k.ctl, LOG=jun_cust_hist$k.log, BAD=jun_cust_hist$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\jun_cust_hist.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=cust_hist$k.ctl, LOG=jul_cust_hist$k.log, BAD=jul_cust_hist$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\jul_cust_hist.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=cust_hist$k.ctl, LOG=aug_cust_hist$k.log, BAD=aug_cust_hist$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\aug_cust_hist.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=cust_hist$k.ctl, LOG=sep_cust_hist$k.log, BAD=sep_cust_hist$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\sep_cust_hist.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=cust_hist$k.ctl, LOG=oct_cust_hist$k.log, BAD=oct_cust_hist$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\oct_cust_hist.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=cust_hist$k.ctl, LOG=nov_cust_hist$k.log, BAD=nov_cust_hist$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\nov_cust_hist.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=cust_hist$k.ctl, LOG=dec_cust_hist$k.log, BAD=dec_cust_hist$k.bad, DATA=..\\..\\..\\..\\data_files\\orders\\dec_cust_hist.csv\n"; 
	print $OUT "finish > finished$k.txt\n";
	print $OUT "exit\n";
	close $OUT;
	system ("perl ds35_create_oracle_sqlldr_ctl.pl cust_hist$k CUST_HIST orders\\$oracletargetdir\\cust_hist$k.ctl");
	#sleep(.1);
	#system ("move remote_oracleds35_cust_hist_sqlldr$k.bat $oracletargetdir/orders\\");
	#system ("move cust_hist$k.ctl $oracletargetdir/orders\\");
}

# prod
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">prod\\$oracletargetdir\\remote_oracleds35_prod_sqlldr$k.bat") || die("Can't open remote_oracleds35_prod_sqlldr$k.bat");
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=prod$k.ctl, LOG=prod$k.log, BAD=prod$k.bad, DATA=..\\..\\..\\..\\data_files\\prod\\prod.csv\n"; 
	print $OUT "finish > finished$k.txt\n";
	print $OUT "exit\n";
	close $OUT;
	system ("perl ds35_create_oracle_sqlldr_ctl.pl products$k PROD prod\\$oracletargetdir\\prod$k.ctl");
	#sleep(.1);
	#system ("move remote_oracleds35_prod_sqlldr$k.bat $oracletargetdir/prod\\");
	#system ("move prod$k.ctl $oracletargetdir/prod\\");
}

# inv
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">prod\\$oracletargetdir\\remote_oracleds35_inv_sqlldr$k.bat") || die("Can't open remote_oracleds35_inv_sqlldr$k.bat");
	print $OUT "sqlldr ds3/ds3\@$oracletarget  CONTROL=inv$k.ctl, LOG=inv$k.log, BAD=inv$k.bad, DATA=..\\..\\..\\..\\data_files\\prod\\inv.csv\n"; 
	print $OUT "exit\n";
	close $OUT;
	system ("perl ds35_create_oracle_sqlldr_ctl.pl inventory$k INV prod\\$oracletargetdir\\inv$k.ctl");
	#sleep(.1);
	#system ("move remote_oracleds35_inv_sqlldr$k.bat $oracletargetdir/prod\\");
	#system ("move inv$k.ctl $oracletargetdir/prod\\");
}
#membership
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">membership\\$oracletargetdir\\remote_oracleds35_membership_sqlldr$k.bat") || die("Can't open remote_oracleds35_membership_sqlldr$k.bat");
	print $OUT "sqlldr ds3/ds3\@$oracletarget CONTROL=membership$k.ctl, LOG=membership$k.log, BAD=membership$k.bad, DATA=..\\..\\..\\..\\data_files\\membership\\membership.csv\n"; 
	print $OUT "finish > finished$k.txt\n";
	print $OUT "exit\n";
	close $OUT;
	system ("perl ds35_create_oracle_sqlldr_ctl.pl membership$k MEMBERS membership\\$oracletargetdir\\membership$k.ctl");
	#sleep(.1);
	#system ("move remote_oracleds35_membership_sqlldr$k.bat $oracletargetdir/membership\\");
	#system ("move membership$k.ctl $oracletargetdir/membership\\");
}

#reviews
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">reviews\\$oracletargetdir\\remote_oracleds35_reviews_sqlldr$k.bat") || die("Can't open remote_oracleds35_reviews_sqlldr$k.bat");
	print $OUT "sqlldr ds3/ds3\@$oracletarget CONTROL=reviews$k.ctl, LOG=reviews$k.log, BAD=reviews$k.bad, DATA=..\\..\\..\\..\\data_files\\reviews\\reviews.csv\n"; 
	print $OUT "sqlldr ds3/ds3\@$oracletarget CONTROL=reviewhelpfulness$k.ctl, LOG=reviewhelp$k.log, BAD=reviewhelp$k.bad, DATA=..\\..\\..\\..\\data_files\\reviews\\review_helpfulness.csv\n"; 
	print $OUT "finish > finished$k.txt\n";
	print $OUT "exit\n";
	close $OUT;
	system ("perl ds35_create_oracle_sqlldr_ctl.pl reviews$k REVIEWS reviews\\$oracletargetdir\\reviews$k.ctl");
	system ("perl ds35_create_oracle_sqlldr_ctl.pl reviews_helpfulness$k REVIEWHELPFULNESS reviews\\$oracletargetdir\\reviewhelpfulness$k.ctl");
	#sleep(.1);
	#system ("move remote_oracleds35_reviews_sqlldr$k.bat $oracletargetdir/reviews\\");
	#system ("move reviews$k.ctl $oracletargetdir/reviews\\");
	#system ("move reviewhelpfulness$k.ctl $oracletargetdir/reviews\\");
}
