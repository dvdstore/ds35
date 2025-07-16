# ds35_execute_sqlserver_multistore_load.pl
# Script to execute bcp in parallel for a set of ds35 sqlserver tables files for a given number of stores
# Syntax to run - perl ds35_execute_sqlserver_multistore_load.pl <sqlserver_target> <number_of_stores> <password>

use strict;
use warnings;
use Cwd qw(getcwd);

my $sqlservertarget = $ARGV [0];
my $numberofstores = $ARGV[1];
my $password = $ARGV[2] || 'password';

my @custfiles; 
my @orderfiles;  
my @reviewfiles;  
my @prodfiles; 
my @membershipfiles;

my $num_finished = 0;

my $sqlservertargetdir;

$sqlservertargetdir = $sqlservertarget;

# remove any backslashes from string to be used for directory name
$sqlservertargetdir =~ s/\\//;

#Load data into tables using scripts created by ds3_create_sqlserver_multistore_load_files.pl

my $base_dir = getcwd;    #get the current working directory 

# Delete any finishedxx.txt files that might be present from previous runs

chdir ("$base_dir");
system ("rm -f cust/$sqlservertargetdir/finished*.txt");
system ("rm -f orders/$sqlservertargetdir/finished*.txt");
system ("rm -f membership/$sqlservertargetdir/finished*.txt");
system ("rm -f prod/$sqlservertargetdir/finished*.txt");
system ("rm -f reviews/$sqlservertargetdir/finished*.txt");

print "Load started at ".(localtime), "\n";
my $startloadtime = time;


chdir("$base_dir/membership/$sqlservertargetdir");
foreach my $k (1 .. $numberofstores){
	print "executing remote_sqlserverds35_membership_load$k.sh\n";
	system ("sh remote_sqlserverds35_membership_load$k.sh");
	}

chdir("$base_dir/prod/$sqlservertargetdir");
foreach my $k (1 .. $numberofstores){
	print "starting remote_sqlserverds35_prod_load$k.sh\n";
	system ("sh remote_sqlserverds35_prod_load$k.sh");
	print "starting remote_sqlserverds35_inv_load$k.sh\n";
	system ("sh remote_sqlserverds35_inv_load$k.sh");
	}
	
	chdir("$base_dir/reviews/$sqlservertargetdir");
foreach my $k (1 .. $numberofstores){
	print "running remote_sqlserverds35_reviews_load$k.sh\n";
	system ("sh remote_sqlserverds35_reviews_load$k.sh");
	}
	
	chdir("$base_dir/orders/$sqlservertargetdir");
foreach my $k (1 .. $numberofstores){
	print "Running:\n  remote_sqlserverds35_orders_load$k.sh\n";
	system ("sh remote_sqlserverds35_orders_load$k.sh");
	print "  remote_sqlserverds35_orderlines_load$k.sh\n";
	system ("sh remote_sqlserverds35_orderlines_load$k.sh");
	print "  remote_sqlserverds35_cust_hist_load$k.sh\n";
	system ("sh remote_sqlserverds35_cust_hist_load$k.sh");
	}
	
	chdir("$base_dir/cust/$sqlservertargetdir");
foreach my $k (1 .. $numberofstores){
	print "Executing remote_sqlserverds35_cust_load$k.sh\n";
	system ("sh remote_sqlserverds35_cust_load$k.sh");
	}
	
# Each load file creates a finishedxx.txt file after completing it's load.  The code
# here loops until there is a finished file for the last store in each directory.
# It assumes that becuase each set of loads will finish within 10 seconds of each
# other, then does a cleanup of the finished files.
	
my $cust_finished_file = "$base_dir/cust/$sqlservertargetdir/finished$numberofstores.txt";
my $orders_finished_file = "$base_dir/orders/$sqlservertargetdir/finished$numberofstores.txt";
my $reviews_finished_file = "$base_dir/reviews/$sqlservertargetdir/finished$numberofstores.txt";
my $prod_finished_file = "$base_dir/prod/$sqlservertargetdir/finished$numberofstores.txt";	
my $membership_finished_file = "$base_dir/membership/$sqlservertargetdir/finished$numberofstores.txt";

chdir("$base_dir");
	
while ($num_finished < 5)
	{
	$num_finished =0;
	sleep(5);
	@custfiles = glob("cust/$sqlservertargetdir/finished*.txt");                            # glob gets an array of all the finished*.txt files
	@orderfiles = glob("orders/$sqlservertargetdir/finished*.txt");                         # The size of this array will tell us how many have finished
	@reviewfiles = glob("reviews/$sqlservertargetdir/finished*.txt"); 
	@prodfiles = glob("prod/$sqlservertargetdir/finished*.txt"); 
	@membershipfiles = glob("membership/$sqlservertargetdir/finished*.txt"); 
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

sleep(10);

# Delete the finishedxx.txt files

chdir ("$base_dir");
system ("rm -f cust/$sqlservertargetdir/finished*.txt");
system ("rm -f orders/$sqlservertargetdir/finished*.txt");
system ("rm -f membership/$sqlservertargetdir/finished*.txt");
system ("rm -f prod/$sqlservertargetdir/finished*.txt");
system ("rm -f reviews/$sqlservertargetdir/finished*.txt");
