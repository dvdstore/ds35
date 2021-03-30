# ds3_execute_mysql_multistore_load.pl
# Script to execute mysql data loads in parallel for a set of ds3 sqlserver tables files for a given number of stores
# Syntax to run - perl ds3_execute_mysql_multistore_load.pl <mysql_target> <number_of_stores> 

use strict;
use warnings;
use Cwd qw(getcwd);

my $oracletarget = $ARGV [0];
my $numberofstores = $ARGV[1];

my $num_finished = 0;

#Load data into tables using scripts created by ds3_create_mysql_multistore_load_files.pl

my $base_dir = getcwd;    #get the current working directory 

# Delete any finishedxx.txt files that might be present from previous runs

chdir ("$base_dir");
system ("del cust\\finished*.txt");
system ("del orders\\finished*.txt");
system ("del membership\\finished*.txt");
system ("del prod\\finished*.txt");
system ("del reviews\\finished*.txt");

print "Load started at ".(localtime), "\n";


chdir("$base_dir\\membership");
foreach my $k (1 .. $numberofstores){
	system ("start remote_mysqlds3_membership_load$k.bat");
	}

chdir("$base_dir\\prod");
foreach my $k (1 .. $numberofstores){
	system ("start remote_mysqlds3_prod_load$k.bat");
	system ("start remote_mysqlds3_inv_load$k.bat");
	}
	
	chdir("$base_dir\\reviews");
foreach my $k (1 .. $numberofstores){
	system ("start remote_mysqlds3_reviews_load$k.bat");
	system ("start remote_mysqlds3_reviewshelpful_load$k.bat");
	}
	
	chdir("$base_dir\\orders");
foreach my $k (1 .. $numberofstores){
	system ("start remote_mysqlds3_orders_load$k.bat");
	system ("start remote_mysqlds3_orderlines_load$k.bat");
	system ("start remote_mysqlds3_cust_hist_load$k.bat");
	}
	
	chdir("$base_dir\\cust");
foreach my $k (1 .. $numberofstores){
	system ("start remote_mysqlds3_cust_load$k.bat");
	}
	
# Each load file creates a finishedxx.txt file after completing it's load.  The code
# here loops until there is a finished file for the last store in each directory.
# It assumes that becuase each set of loads will finish within 10 seconds of each
# other, then does a cleanup of the finished files.
	
my $cust_finished_file = "$base_dir\\cust\\finished$numberofstores.txt";
my $orders_finished_file = "$base_dir\\orders\\finished$numberofstores.txt";
my $reviews_finished_file = "$base_dir\\reviews\\finished$numberofstores.txt";
my $prod_finished_file = "$base_dir\\prod\\finished$numberofstores.txt";	
my $membership_finished_file = "$base_dir\\membership\\finished$numberofstores.txt";
	
while ($num_finished < 5)
	{
	sleep(1);
	$num_finished =0;
	if (-e $cust_finished_file) {++$num_finished;}
	if (-e $orders_finished_file) {++$num_finished;}
	if (-e $reviews_finished_file) {++$num_finished;}
	if (-e $prod_finished_file) {++$num_finished;}
	if (-e $membership_finished_file) {++$num_finished;}
	}
	
print "Load finished at ".(localtime), "\n";

sleep(30);

# Delete the finishedxx.txt files


chdir ("$base_dir");
system ("del cust\\finished*.txt");
system ("del orders\\finished*.txt");
system ("del membership\\finished*.txt");
system ("del prod\\finished*.txt");
system ("del reviews\\finished*.txt");




	
	
	
