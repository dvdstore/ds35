# ds3_execute_mysql_multistore_load.pl
# Script to execute mysql data loads in parallel for a set of ds3 sqlserver tables files for a given number of stores
# Syntax to run - perl ds3_execute_mysql_multistore_load.pl <mysql_target> <number_of_stores> 

use strict;
use warnings;
use Cwd qw(getcwd);

my $mysqltarget = $ARGV [0];
my $numberofstores = $ARGV[1];

my @custfiles; 
my @orderfiles;  
my @reviewfiles;  
my @reviewshelpfiles;
my @prodfiles; 
my @membershipfiles;

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

system ("mysql -h $mysqltarget -u web --password=web --local_infile DS3 < mysqlds35_disable_redo_log.sql");

# This section enables support for Linux and Windows - detecting the type of OS, and then starting the executions in parallel 
if ("$^O" eq "linux")
	{                    #Linux version
	my $num_finished = 0;

	#Load data into tables using scripts created by ds3_create_mysql_multistore_load_files.pl

	my $base_dir = getcwd;    #get the current working directory 

	# Delete any finishedxx.txt files that might be present from previous runs

	chdir ("$base_dir");
	system ("rm -f cust/finished*.txt");
	system ("rm -f orders/finished*.txt");
	system ("rm -f membership/finished*.txt");
	system ("rm -f prod/finished*.txt");
	system ("rm -f reviews/finished*.txt");
	
	print "Load started at ".(localtime), "\n";

	chdir("$base_dir/membership");
	foreach my $k (1 .. $numberofstores){
		system ("sh remote_mysqlds35_membership_load$k.bat &");
		}

	chdir("$base_dir/prod");
	foreach my $k (1 .. $numberofstores){
		system ("sh remote_mysqlds35_prod_load$k.bat &");
		system ("sh remote_mysqlds35_inv_load$k.bat &");
		}
	
	chdir("$base_dir/reviews");
	foreach my $k (1 .. $numberofstores){
		system ("sh remote_mysqlds35_reviews_load$k.bat &");
		system ("sh remote_mysqlds35_reviewshelpful_load$k.bat &");
		}
	
	chdir("$base_dir/orders");
	foreach my $k (1 .. $numberofstores){
		system ("sh remote_mysqlds35_orders_load$k.bat &");
		system ("sh remote_mysqlds35_orderlines_load$k.bat &");
		system ("sh remote_mysqlds35_cust_hist_load$k.bat &");
		}
	
	chdir("$base_dir/cust");
	foreach my $k (1 .. $numberofstores){
		system ("sh remote_mysqlds35_cust_load$k.bat &");
		}
	
	# Each load file creates a finishedxx.txt file after completing it's load.  The code
	# here loops until there is a finished file for the last store in each directory.
	# It assumes that becuase each set of loads will finish within 10 seconds of each
	# other, then does a cleanup of the finished files.
	
	my $cust_finished_file = "$base_dir/cust/finished$numberofstores.txt";
	my $orders_finished_file = "$base_dir/orders/finished$numberofstores.txt";
	my $reviews_finished_file = "$base_dir/reviews/finished$numberofstores.txt";
	my $reviewshelp_finished_file = "$base_dir/reviews/finishedhelp$numberofstores.txt";
	my $prod_finished_file = "$base_dir/prod/finished$numberofstores.txt";	
	my $membership_finished_file = "$base_dir/membership/finished$numberofstores.txt";
	
	while ($num_finished < 6)
		{
		sleep(5);
		$num_finished =0;
		if (-e $cust_finished_file) {++$num_finished;}
		if (-e $orders_finished_file) {++$num_finished;}
		if (-e $reviews_finished_file) {++$num_finished;}
		if (-e $reviewshelp_finished_file) {++$num_finished;}
		if (-e $prod_finished_file) {++$num_finished;}
		if (-e $membership_finished_file) {++$num_finished;}
		#print "current num_finished is $num_finished\n";
		}
	
	print "Load finished at ".(localtime), "\n";

	sleep(30);

	# Delete the finishedxx.txt files


	chdir ("$base_dir");
	system ("rm -f cust/finished*.txt");
	system ("rm -f orders/finished*.txt");
	system ("rm -f membership/finished*.txt");
	system ("rm -f prod/finished*.txt");
	system ("rm -f  reviews/finished*.txt");

	}  # End Linux version
else         # Windows Version
	{
	my $num_finished = 0;

	#Load data into tables using scripts created by ds3_create_mysql_multistore_load_files.pl

	my $base_dir = getcwd;    #get the current working directory 

	# Delete any finishedxx.txt files that might be present from previous runs

	chdir ("$base_dir");
	system ("del cust\\$mysql_targetdir\\finished*.txt");
	system ("del orders\\$mysql_targetdir\\finished*.txt");
	system ("del membership\\$mysql_targetdir\\finished*.txt");
	system ("del prod\\$mysql_targetdir\\finished*.txt");
	system ("del reviews\\$mysql_targetdir\\finished*.txt");
	
	print "Load started at ".(localtime), "\n";


	chdir("$base_dir\\membership\\$mysql_targetdir");
	foreach my $k (1 .. $numberofstores){
		system ("start remote_mysqlds35_membership_load$k.bat");
		}

	chdir("$base_dir\\prod\\$mysql_targetdir");
	foreach my $k (1 .. $numberofstores){
		system ("start remote_mysqlds35_prod_load$k.bat");
		system ("start remote_mysqlds35_inv_load$k.bat");
		}
	
	chdir("$base_dir\\reviews\\$mysql_targetdir");
	foreach my $k (1 .. $numberofstores){
		system ("start remote_mysqlds35_reviews_load$k.bat");
		system ("start remote_mysqlds35_reviewshelpful_load$k.bat");
		}
	
	chdir("$base_dir\\orders\\$mysql_targetdir");
	foreach my $k (1 .. $numberofstores){
		system ("start remote_mysqlds35_orders_load$k.bat");
		system ("start remote_mysqlds35_orderlines_load$k.bat");
		system ("start remote_mysqlds35_cust_hist_load$k.bat");
		}
	
	chdir("$base_dir\\cust\\$mysql_targetdir");
	foreach my $k (1 .. $numberofstores){
		system ("start remote_mysqlds35_cust_load$k.bat");
		}
	
	# Each load file creates a finishedxx.txt file after completing it's load.  The code
	# here loops until there is a finished file for the last store in each directory.
	# It assumes that becuase each set of loads will finish within 10 seconds of each
	# other, then does a cleanup of the finished files.
	
	my $cust_finished_file = "$base_dir\\cust\\$mysql_targetdir\\finished$numberofstores.txt";
	my $orders_finished_file = "$base_dir\\orders\\$mysql_targetdir\\finished$numberofstores.txt";
	my $reviews_finished_file = "$base_dir\\reviews\\$mysql_targetdir\\finishedreview$numberofstores.txt";
	my $reviewshelp_finished_file = "$base_dir\\reviews\\$mysql_targetdir\\finishedhelp$numberofstores.txt";
	my $prod_finished_file = "$base_dir\\prod\\$mysql_targetdir\\finished$numberofstores.txt";	
	my $membership_finished_file = "$base_dir\\membership\\$mysql_targetdir\\finished$numberofstores.txt";
	
	chdir("$base_dir");
	
	while ($num_finished < 6)
			{
			$num_finished =0;
			sleep(5);
			@custfiles = glob("cust\\$mysql_targetdir\\finished*.txt");                            # glob gets an array of all the finished*.txt files
			@orderfiles = glob("orders\\$mysql_targetdir\\finished*.txt");                         # The size of this array will tell us how many have finished
			@reviewfiles = glob("reviews\\$mysql_targetdir\\finishedreview*.txt"); 
			@reviewshelpfiles = glob("reviews\\$mysql_targetdir\\finishedhelp*.txt");
			@prodfiles = glob("prod\\$mysql_targetdir\\finished*.txt"); 
			@membershipfiles = glob("membership\\$mysql_targetdir\\finished*.txt"); 
			if ($#custfiles == ($numberofstores-1)) {++$num_finished;}           #Compare size of array with number of stores being created, minus one due to array index starting at 0
			if ($#orderfiles == ($numberofstores-1)) {++$num_finished;}
			if ($#reviewfiles == ($numberofstores-1)) {++$num_finished;}
			if ($#reviewshelpfiles == ($numberofstores-1)) {++$num_finished;}
			if ($#prodfiles == ($numberofstores-1)) {++$num_finished;}
			if ($#membershipfiles == ($numberofstores-1)) {++$num_finished;}
			print "Num files complete in each category $#custfiles, $#orderfiles, $#reviewfiles, $#reviewshelpfiles, $#prodfiles, $#membershipfiles \n";
			print "current num_finished is $num_finished\n";
			}
	
	print "Load finished at ".(localtime), "\n";

	sleep(30);

	# Delete the finishedxx.txt files


	chdir ("$base_dir");
	system ("del cust\\$mysql_targetdir\\finished*.txt");
	system ("del orders\\$mysql_targetdir\\finished*.txt");
	system ("del membership\\$mysql_targetdir\\finished*.txt");
	system ("del prod\\$mysql_targetdir\\finished*.txt");
	system ("del reviews\\$mysql_targetdir\\finished*.txt");

}  # End Windows version

system ("mysql -h $mysqltarget -u web --password=web --local_infile DS3 < mysqlds35_enable_redo_log.sql");


	
	
	
