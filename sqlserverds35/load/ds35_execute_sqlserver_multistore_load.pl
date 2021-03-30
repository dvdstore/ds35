# ds3_execute_sqlserver_multistore_load.pl
# Script to execute bcp in parallel for a set of ds3 sqlserver tables files for a given number of stores
# Syntax to run - perl ds3_execute_sqlserver_multistore_load.pl <sqlserver_target> <number_of_stores> 

use strict;
use warnings;
use Cwd qw(getcwd);

my $oracletarget = $ARGV [0];
my $numberofstores = $ARGV[1];

my @custfiles; 
my @orderfiles;  
my @reviewfiles;  
my @prodfiles; 
my @membershipfiles;

my $num_finished = 0;

#Load data into tables using scripts created by ds3_create_sqlserver_multistore_load_files.pl

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
	system ("start remote_sqlserverds3_membership_load$k.bat");
	}

chdir("$base_dir\\prod");
foreach my $k (1 .. $numberofstores){
	system ("start remote_sqlserverds3_prod_load$k.bat");
	system ("start remote_sqlserverds3_inv_load$k.bat");
	}
	
	chdir("$base_dir\\reviews");
foreach my $k (1 .. $numberofstores){
	system ("start remote_sqlserverds3_reviews_load$k.bat");
	}
	
	chdir("$base_dir\\orders");
foreach my $k (1 .. $numberofstores){
	system ("start remote_sqlserverds3_orders_load$k.bat");
	system ("start remote_sqlserverds3_orderlines_load$k.bat");
	system ("start remote_sqlserverds3_cust_hist_load$k.bat");
	}
	
	chdir("$base_dir\\cust");
foreach my $k (1 .. $numberofstores){
	system ("start remote_sqlserverds3_cust_load$k.bat");
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

chdir("$base_dir");
	
while ($num_finished < 5)
	{
	$num_finished =0;
	sleep(5);
	@custfiles = glob("cust\\finished*.txt");                            # glob gets an array of all the finished*.txt files
	@orderfiles = glob("orders\\finished*.txt");                         # The size of this array will tell us how many have finished
	@reviewfiles = glob("reviews\\finished*.txt"); 
	@prodfiles = glob("prod\\finished*.txt"); 
	@membershipfiles = glob("membership\\finished*.txt"); 
	if ($#custfiles == ($numberofstores-1)) {++$num_finished;}           #Compare size of array with number of stores being created, minus one due to array index starting at 0
	if ($#orderfiles == ($numberofstores-1)) {++$num_finished;}
	if ($#reviewfiles == ($numberofstores-1)) {++$num_finished;}
	if ($#prodfiles == ($numberofstores-1)) {++$num_finished;}
	if ($#membershipfiles == ($numberofstores-1)) {++$num_finished;}
	print "size of the files is $#custfiles, $#orderfiles, $#reviewfiles, $#prodfiles, $#membershipfiles \n";
	print "current num_finished is $num_finished\n";
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




	
	
	
