# ds35_create_osqlserver_multistore_ctl_files.pl
# Script to create a set of ds35 sqlserver load files for a given number of stores
# Syntax to run - perl ds35_create_sqlserver_multistore_load_files.pl <sqlserver_target> <number_of_stores> <password>

use strict;
use warnings;
use Cwd qw(getcwd);

my $sqlservertarget = $ARGV[0];
my $numberofstores = $ARGV[1];
my $password = $ARGV[2] || 'password';

my $sqlservertargetdir;

$sqlservertargetdir = $sqlservertarget;

# remove any backslashes from string to be used for directory name
$sqlservertargetdir =~ s/\\//;


my $base_dir = getcwd;    #get the current working directory 

#create subdirectories for temporary load files 

system ("mkdir -p cust/$sqlservertargetdir");
system ("mkdir -p orders/$sqlservertargetdir");
system ("mkdir -p prod/$sqlservertargetdir");
system ("mkdir -p membership/$sqlservertargetdir");
system ("mkdir -p reviews/$sqlservertargetdir");

#customers 

foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">cust/$sqlservertargetdir/remote_sqlserverds35_cust_load$k.sh") || die("Can't open remote_sqlserverds35_cust_load$k.sh");
	print $OUT "bcp ds3..customers$k in ../../../../data_files/cust/us_cust.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > us_cust$k.log\n";
	print $OUT "bcp ds3..customers$k in ../../../../data_files/cust/row_cust.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > row_cust$k.log\n";	
	print $OUT "date > finished$k.txt\n";
	print $OUT "exit\n";
	close $OUT;
    sleep(.1);
	
}

# Orders 
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">orders/$sqlservertargetdir/remote_sqlserverds35_orders_load$k.sh") || die("Can't open remote_sqlserverds35_orders_load$k.sh");
	print $OUT "bcp ds3..orders$k in ../../../../data_files/orders/jan_orders.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > jan_orders$k.log\n"; 
	print $OUT "bcp ds3..orders$k in ../../../../data_files/orders/feb_orders.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > feb_orders$k.log\n"; 
	print $OUT "bcp ds3..orders$k in ../../../../data_files/orders/mar_orders.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > mar_orders$k.log\n"; 
	print $OUT "bcp ds3..orders$k in ../../../../data_files/orders/apr_orders.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > apr_orders$k.log\n"; 
	print $OUT "bcp ds3..orders$k in ../../../../data_files/orders/may_orders.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > may_orders$k.log\n"; 
	print $OUT "bcp ds3..orders$k in ../../../../data_files/orders/jun_orders.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > jun_orders$k.log\n"; 
	print $OUT "bcp ds3..orders$k in ../../../../data_files/orders/jul_orders.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > jul_orders$k.log\n"; 
	print $OUT "bcp ds3..orders$k in ../../../../data_files/orders/aug_orders.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > aug_orders$k.log\n"; 
	print $OUT "bcp ds3..orders$k in ../../../../data_files/orders/sep_orders.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > sep_orders$k.log\n"; 
	print $OUT "bcp ds3..orders$k in ../../../../data_files/orders/oct_orders.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > oct_orders$k.log\n"; 
	print $OUT "bcp ds3..orders$k in ../../../../data_files/orders/nov_orders.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > nov_orders$k.log\n"; 
	print $OUT "bcp ds3..orders$k in ../../../../data_files/orders/dec_orders.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t , > dec_orders$k.log\n"; 
	print $OUT "exit\n";
	close $OUT;
	sleep(.1);
	
}

# Orderlines 
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">orders/$sqlservertargetdir/remote_sqlserverds35_orderlines_load$k.sh") || die("Can't open remote_sqlserverds35_orderlines_load$k.sh");
	print $OUT "bcp ds3..orderlines$k in ../../../../data_files/orders/jan_orderlines.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> jan_orderlines$k.log\n"; 
	print $OUT "bcp ds3..orderlines$k in ../../../../data_files/orders/feb_orderlines.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> feb_orderlines$k.log\n"; 
	print $OUT "bcp ds3..orderlines$k in ../../../../data_files/orders/mar_orderlines.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> mar_orderlines$k.log\n"; 
	print $OUT "bcp ds3..orderlines$k in ../../../../data_files/orders/apr_orderlines.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> apr_orderlines$k.log\n"; 
	print $OUT "bcp ds3..orderlines$k in ../../../../data_files/orders/may_orderlines.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> may_orderlines$k.log\n"; 
	print $OUT "bcp ds3..orderlines$k in ../../../../data_files/orders/jun_orderlines.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> jun_orderlines$k.log\n"; 
	print $OUT "bcp ds3..orderlines$k in ../../../../data_files/orders/jul_orderlines.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> jul_orderlines$k.log\n"; 
	print $OUT "bcp ds3..orderlines$k in ../../../../data_files/orders/aug_orderlines.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> aug_orderlines$k.log\n"; 
	print $OUT "bcp ds3..orderlines$k in ../../../../data_files/orders/sep_orderlines.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> sep_orderlines$k.log\n"; 
	print $OUT "bcp ds3..orderlines$k in ../../../../data_files/orders/oct_orderlines.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> oct_orderlines$k.log\n"; 
	print $OUT "bcp ds3..orderlines$k in ../../../../data_files/orders/nov_orderlines.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> nov_orderlines$k.log\n"; 
	print $OUT "bcp ds3..orderlines$k in ../../../../data_files/orders/dec_orderlines.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> dec_orderlines$k.log\n"; 
	print $OUT "exit\n";
	close $OUT;
	
}
# cust_hist 
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">orders/$sqlservertargetdir/remote_sqlserverds35_cust_hist_load$k.sh") || die("Can't open remote_sqlserverds35_cust_hist_load$k.sh");
	print $OUT "bcp ds3..cust_hist$k in ../../../../data_files/orders/jan_cust_hist.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> jan_cust_hist$k.log\n"; 
	print $OUT "bcp ds3..cust_hist$k in ../../../../data_files/orders/feb_cust_hist.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> feb_cust_hist$k.log\n"; 
	print $OUT "bcp ds3..cust_hist$k in ../../../../data_files/orders/mar_cust_hist.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> mar_cust_hist$k.log\n"; 
	print $OUT "bcp ds3..cust_hist$k in ../../../../data_files/orders/apr_cust_hist.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> apr_cust_hist$k.log\n"; 
	print $OUT "bcp ds3..cust_hist$k in ../../../../data_files/orders/may_cust_hist.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> may_cust_hist$k.log\n"; 
	print $OUT "bcp ds3..cust_hist$k in ../../../../data_files/orders/jun_cust_hist.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> jun_cust_hist$k.log\n"; 
	print $OUT "bcp ds3..cust_hist$k in ../../../../data_files/orders/jul_cust_hist.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> jul_cust_hist$k.log\n"; 
	print $OUT "bcp ds3..cust_hist$k in ../../../../data_files/orders/aug_cust_hist.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> aug_cust_hist$k.log\n"; 
	print $OUT "bcp ds3..cust_hist$k in ../../../../data_files/orders/sep_cust_hist.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> sep_cust_hist$k.log\n"; 
	print $OUT "bcp ds3..cust_hist$k in ../../../../data_files/orders/oct_cust_hist.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> oct_cust_hist$k.log\n"; 
	print $OUT "bcp ds3..cust_hist$k in ../../../../data_files/orders/nov_cust_hist.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> nov_cust_hist$k.log\n"; 
	print $OUT "bcp ds3..cust_hist$k in ../../../../data_files/orders/dec_cust_hist.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> dec_cust_hist$k.log\n"; 
	print $OUT "date > finished$k.txt\n";
	print $OUT "exit\n";
	close $OUT;
	sleep(.1);
	
}
# prod
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">prod/$sqlservertargetdir/remote_sqlserverds35_prod_load$k.sh") || die("Can't open remote_sqlserverds35_prod_load$k.sh");
	print $OUT "bcp ds3..products$k in ../../../../data_files/prod/prod.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> prod$k.log\n";
	print $OUT "date > finished$k.txt\n";
	print $OUT "exit\n";
	close $OUT;
	sleep(.1);
	
}
# inv
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">prod/$sqlservertargetdir/remote_sqlserverds35_inv_load$k.sh") || die("Can't open remote_sqlserverds35_inv_load$k.sh");
	print $OUT "bcp ds3..inventory$k in ../../../../data_files/prod/inv.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> inv$k.log\n"; 
	print $OUT "exit\n";
	close $OUT;
	sleep(.1);
	
}
#membership
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">membership/$sqlservertargetdir/remote_sqlserverds35_membership_load$k.sh") || die("Can't open remote_sqlserverds35_membership_load$k.sh");
	print $OUT "bcp ds3..membership$k in ../../../../data_files/membership/membership.csv -b 10000 -h TABLOCK -S $sqlservertarget -u -U sa -P $password -c -t ,> membership$k.log\n";
	print $OUT "date > finished$k.txt\n";
	print $OUT "exit\n";
	close $OUT;
	sleep(.1);
	
}
#reviews
foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">reviews/$sqlservertargetdir/remote_sqlserverds35_reviews_load$k.sh") || die("Can't open remote_sqlserverds35_reviews_load$k.sh");
	print $OUT "bcp ds3..reviews$k in ../../../../data_files/reviews/reviews.csv -b 10000 -h TABLOCK -S $sqlservertarget -U sa -P $password -c -t ,> reviews$k.log\n"; 
	print $OUT "bcp ds3..reviews_helpfulness$k in ../../../../data_files/reviews/review_helpfulness.csv -b 10000 -h TABLOCK -S $sqlservertarget -U sa -P $password -c -t ,> review_helpfulness$k.log\n"; 
	print $OUT "date > finished$k.txt\n";
	print $OUT "exit\n";
	close $OUT;
	sleep(.1);
	
}

