# ds3_execute_oracle_multistore_sqlldr.pl
# Script to execute sqlldr in parallel for a set of ds3 oracle sqlldr ctl files for a given number of stores
# Syntax to run - perl ds35_execute_oracle_multistore_sqlldr.pl <oracle_target> <number_of_stores> 

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

my $loadtimelogfile;

#Need seperate target directory so that mulitple DB Targets can be loaded at the same time
my $oracletargetdir;  

$oracletargetdir = $oracletarget;

# remove any backslashes from string to be used for directory name
$oracletargetdir =~ s/\\//;

my $num_finished = 0;

#Load data into tables using scripts created by ds3_create_oracle_multistore_ctl_files.pl

my $base_dir = getcwd;    #get the current working directory 

# Delete any finishedxx.txt files that might be around from previous loads

chdir ("$base_dir");
system ("del cust\\$oracletargetdir\\finished*.txt");
system ("del orders\\$oracletargetdir\\finished*.txt");
system ("del membership\\$oracletargetdir\\finished*.txt");
system ("del prod\\$oracletargetdir\\finished*.txt");
system ("del reviews\\$oracletargetdir\\finished*.txt");

print "Load started at ".(localtime), "\n";
my $startlocaltime = (localtime);
my $startloadtime = time;

chdir("$base_dir\\membership\\$oracletargetdir");
foreach my $k (1 .. $numberofstores){
	system ("start remote_oracleds35_membership_sqlldr$k.bat");
	}

chdir("$base_dir\\prod\\$oracletargetdir");
foreach my $k (1 .. $numberofstores){
	system ("start remote_oracleds35_prod_sqlldr$k.bat");
	system ("start remote_oracleds35_inv_sqlldr$k.bat");
	}
	
	chdir("$base_dir\\reviews\\$oracletargetdir");
foreach my $k (1 .. $numberofstores){
	system ("start remote_oracleds35_reviews_sqlldr$k.bat");
	}
	
	chdir("$base_dir\\orders\\$oracletargetdir");
foreach my $k (1 .. $numberofstores){
	system ("start remote_oracleds35_orders_sqlldr$k.bat");
	system ("start remote_oracleds35_orderlines_sqlldr$k.bat");
	system ("start remote_oracleds35_cust_hist_sqlldr$k.bat");
	}
	
	chdir("$base_dir\\cust\\$oracletargetdir");
foreach my $k (1 .. $numberofstores){
	system ("start remote_oracleds35_cust_sqlldr$k.bat");
	}
	
# Each load file creates a finishedxx.txt file after completing it's load.  The code
# here loops until there is a finished file for the last store in each directory.
# It assumes that becuase each set of loads will finish within 10 seconds of each
# other, then does a cleanup of the finished files.
	
my $cust_finished_file = "$base_dir\\cust\\$oracletargetdir\\finished$numberofstores.txt";
my $orders_finished_file = "$base_dir\\orders\\$oracletargetdir\\finished$numberofstores.txt";
my $reviews_finished_file = "$base_dir\\reviews\\$oracletargetdir\\finished$numberofstores.txt";
my $prod_finished_file = "$base_dir\\prod\\$oracletargetdir\\finished$numberofstores.txt";	
my $membership_finished_file = "$base_dir\\$oracletargetdir\\membership\\finished$numberofstores.txt";

chdir("$base_dir");
	
#while ($num_finished < 5)
#	{
#	sleep(1);
#	$num_finished =0;
#	if (-e $cust_finished_file) {++$num_finished;}
#	if (-e $orders_finished_file) {++$num_finished;}
#	if (-e $reviews_finished_file) {++$num_finished;}
#	if (-e $prod_finished_file) {++$num_finished;}
#	if (-e $membership_finished_file) {++$num_finished;}
#	}
#	
#print "Load finished at ".(localtime), "\n";


while ($num_finished < 5)
	{
	$num_finished =0;
	sleep(5);
	@custfiles = glob("cust\\$oracletargetdir\\finished*.txt");                            # glob gets an array of all the finished*.txt files
	@orderfiles = glob("orders\\$oracletargetdir\\finished*.txt");                         # The size of this array will tell us how many have finished
	@reviewfiles = glob("reviews\\$oracletargetdir\\finished*.txt"); 
	@prodfiles = glob("prod\\$oracletargetdir\\finished*.txt"); 
	@membershipfiles = glob("membership\\$oracletargetdir\\finished*.txt"); 
	if ($#custfiles == ($numberofstores-1)) {++$num_finished;}           #Compare size of array with number of stores being created, minus one due to array index starting at 0
	if ($#orderfiles == ($numberofstores-1)) {++$num_finished;}
	if ($#reviewfiles == ($numberofstores-1)) {++$num_finished;}
	if ($#prodfiles == ($numberofstores-1)) {++$num_finished;}
	if ($#membershipfiles == ($numberofstores-1)) {++$num_finished;}
	print "Num files complete in each category $#custfiles, $#orderfiles, $#reviewfiles, $#prodfiles, $#membershipfiles \n";
	print "current num_finished is $num_finished\n";
	}
	
print "Load finished at ".(localtime), "\n";
my $loadtime = time - $startloadtime;
print "Total Load Time: $loadtime s\n";

#Add loadtime to log file of load times 
$loadtimelogfile = 'LoadLog_' . $oracletarget . '_' . $numberofstores . 'stores.csv';
open (my $LOG, ">>$loadtimelogfile") || die("Can't open $loadtimelogfile");
print $LOG "$startlocaltime, " . (localtime) . ", $oracletargetdir, $numberofstores, $loadtime \n";


sleep(60);

# Delete the finishedxx.txt files

chdir ("$base_dir");
system ("del cust\\$oracletargetdir\\finished*.txt");
system ("del orders\\$oracletargetdir\\finished*.txt");
system ("del membership\\$oracletargetdir\\finished*.txt");
system ("del prod\\$oracletargetdir\\finished*.txt");
system ("del reviews\\$oracletargetdir\\finished*.txt");




	
	
	
