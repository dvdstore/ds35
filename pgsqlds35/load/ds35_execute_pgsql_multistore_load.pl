# ds35_execute_psql_multistore_load.pl
# Script to execute psql data loads in parallel for a set of ds35 psql tables files for a given number of stores
# Syntax to run - perl ds35_execute_psql_multistore_load.pl <psql_target> <number_of_stores> 

use strict;
use warnings;
use Cwd qw(getcwd);

my $psqltarget = $ARGV[0];
my $numStores = $ARGV[1];

my @custfiles; 
my @orderfiles;  
my @reviewfiles;  
my @reviewshelpfiles;
my @prodfiles; 
my @membershipfiles;

my $movecommand;
my $timecommand;
my $pathsep;

#Need seperate target directory so that mulitple DB Targets can be loaded at the same time
my $pgsql_targetdir;  

$pgsql_targetdir = $psqltarget;

# remove any backslashes from string to be used for directory name
$pgsql_targetdir =~ s/\\//;

system ("mkdir $pgsql_targetdir");

print "$^0\n";

# This section enables support for Linux and Windows - detecting the type of OS, and then starting the executions in parallel
if ("$^O" eq "linux")
        {                    #Linux version
        my $num_finished = 0;

        #Load data into tables using scripts created by ds35_create_psql_multistore_load_files.pl

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
        foreach my $k (1 .. $numStores){
                system ("sh remote_pgsqlds35_membership_load$k.bat &");
                }

        chdir("$base_dir/prod");
        foreach my $k (1 .. $numStores){
                system ("sh remote_pgsqlds35_prod_load$k.bat &");
                system ("sh remote_pgsqlds35_inv_load$k.bat &");
                }

        chdir("$base_dir/reviews");
        foreach my $k (1 .. $numStores){
                system ("sh remote_pgsqlds35_reviews_load$k.bat &");
                system ("sh remote_pgsqlds35_reviewshelpful_load$k.bat &");
                }

        chdir("$base_dir/orders");
	foreach my $k (1 .. $numStores){
                system ("sh remote_pgsqlds35_orders_load$k.bat &");
                system ("sh remote_pgsqlds35_orderlines_load$k.bat &");
                system ("sh remote_pgsqlds35_cust_hist_load$k.bat &");
                }

        chdir("$base_dir/cust");
        foreach my $k (1 .. $numStores){
                system ("sh remote_pgsqlds35_cust_load$k.bat &");
                }

        # Each load file creates a finishedxx.txt file after completing it's load.  The code
        # here loops until there is a finished file for the last store in each directory.
        # It assumes that becuase each set of loads will finish within 10 seconds of each
        # other, then does a cleanup of the finished files.

        my $cust_finished_file = "$base_dir/cust/finished$numStores.txt";
        my $orders_finished_file = "$base_dir/orders/finished$numStores.txt";
        my $reviews_finished_file = "$base_dir/reviews/finished$numStores.txt";
		my $reviewshelp_finished_file = "$base_dir/reviews/finishedhelp$numStores.txt";
        my $prod_finished_file = "$base_dir/prod/finished$numStores.txt";
        my $membership_finished_file = "$base_dir/membership/finished$numStores.txt";

        while ($num_finished < 6)
                {
                sleep(1);
                $num_finished =0;
                if (-e $cust_finished_file) {++$num_finished;}
                if (-e $orders_finished_file) {++$num_finished;}
                if (-e $reviews_finished_file) {++$num_finished;}
				if (-e $reviewshelp_finished_file) {++$num_finished;}
                if (-e $prod_finished_file) {++$num_finished;}
                if (-e $membership_finished_file) {++$num_finished;}
                }

        print "Load finished at ".(localtime), "\n";

        sleep(30);

        # Delete the finishedxx.txt files


        chdir ("$base_dir");
        system ("rm -f cust/finished*.txt");
        system ("rm -f orders/finished*.txt");
        system ("rm -f membership/finished*.txt");
        system ("rm -f prod/finished*.txt");
        system ("rm -f reviews/finished*.txt");

        }  # End Linux version
else         # Windows Version
        {
        my $num_finished = 0;

        #Load data into tables using scripts created by ds35_create_psql_multistore_load_files.pl

        my $base_dir = getcwd;    #get the current working directory 

        # Delete any finishedxx.txt files that might be present from previous runs

        chdir ("$base_dir");
        system ("del cust\\$pgsql_targetdir\\finished*.txt");
        system ("del orders\\$pgsql_targetdir\\finished*.txt");
        system ("del membership\\$pgsql_targetdir\\finished*.txt");
        system ("del prod\\$pgsql_targetdir\\finished*.txt");
        system ("del reviews\\$pgsql_targetdir\\finished*.txt");

        print "Load started at ".(localtime), "\n";


        chdir("$base_dir\\membership\\$pgsql_targetdir");
        foreach my $k (1 .. $numStores){
                system ("start remote_pgsqlds35_membership_load$k.bat");
                }

        chdir("$base_dir\\prod\\$pgsql_targetdir");
        foreach my $k (1 .. $numStores){
                system ("start remote_pgsqlds35_prod_load$k.bat");
                system ("start remote_pgsqlds35_inv_load$k.bat");
                }

        chdir("$base_dir\\reviews\\$pgsql_targetdir");
        foreach my $k (1 .. $numStores){
                system ("start remote_pgsqlds35_reviews_load$k.bat");
                system ("start remote_pgsqlds35_reviewshelpful_load$k.bat");
                }

        chdir("$base_dir\\orders\\$pgsql_targetdir");
        foreach my $k (1 .. $numStores){
                system ("start remote_pgsqlds35_orders_load$k.bat");
                system ("start remote_pgsqlds35_orderlines_load$k.bat");
                system ("start remote_pgsqlds35_cust_hist_load$k.bat");
                }

        chdir("$base_dir\\cust\\$pgsql_targetdir");
        foreach my $k (1 .. $numStores){
		system ("start remote_pgsqlds35_cust_load$k.bat");
                }

        # Each load file creates a finishedxx.txt file after completing it's load.  The code
        # here loops until there is a finished file for the last store in each directory.
        # It assumes that becuase each set of loads will finish within 10 seconds of each
        # other, then does a cleanup of the finished files.

        my $cust_finished_file = "$base_dir\\cust\\$pgsql_targetdir\\finished$numStores.txt";
        my $orders_finished_file = "$base_dir\\orders\\$pgsql_targetdir\\finished$numStores.txt";
        my $reviews_finished_file = "$base_dir\\reviews\\$pgsql_targetdir\\finished$numStores.txt";
		my $reviewshelp_finished_file = "$base_dir\\reviews\\$pgsql_targetdir\\finishedhelp$numStores.txt";
        my $prod_finished_file = "$base_dir\\prod\\$pgsql_targetdir\\finished$numStores.txt";
        my $membership_finished_file = "$base_dir\\membership\\$pgsql_targetdir\\finished$numStores.txt";
		
		chdir("$base_dir");

        #while ($num_finished < 6)
        #        {
        #        sleep(1);
        #        $num_finished =0;
        #        if (-e $cust_finished_file) {++$num_finished;}
        #        if (-e $orders_finished_file) {++$num_finished;}
        #        if (-e $reviews_finished_file) {++$num_finished;}
		#        if (-e $reviewshelp_finished_file) {++$num_finished;}
        #        if (-e $prod_finished_file) {++$num_finished;}
        #        if (-e $membership_finished_file) {++$num_finished;}
        #        }

		while ($num_finished < 6)
			{
			$num_finished =0;
			sleep(5);
			@custfiles = glob("cust\\$pgsql_targetdir\\finished*.txt");                            # glob gets an array of all the finished*.txt files
			@orderfiles = glob("orders\\$pgsql_targetdir\\finished*.txt");                         # The size of this array will tell us how many have finished
			@reviewfiles = glob("reviews\\$pgsql_targetdir\\finishedreview*.txt"); 
			@reviewshelpfiles = glob("reviews\\$pgsql_targetdir\\finishedhelp*.txt");
			@prodfiles = glob("prod\\$pgsql_targetdir\\finished*.txt"); 
			@membershipfiles = glob("membership\\$pgsql_targetdir\\finished*.txt"); 
			if ($#custfiles == ($numStores-1)) {++$num_finished;}           #Compare size of array with number of stores being created, minus one due to array index starting at 0
			if ($#orderfiles == ($numStores-1)) {++$num_finished;}
			if ($#reviewfiles == ($numStores-1)) {++$num_finished;}
			if ($#reviewshelpfiles == ($numStores-1)) {++$num_finished;}
			if ($#prodfiles == ($numStores-1)) {++$num_finished;}
			if ($#membershipfiles == ($numStores-1)) {++$num_finished;}
			print "Num files complete in each category $#custfiles, $#orderfiles, $#reviewfiles, $#reviewshelpfiles, $#prodfiles, $#membershipfiles \n";
			print "current num_finished is $num_finished\n";
			}

        print "Load finished at ".(localtime), "\n";

        sleep(30);

        # Delete the finishedxx.txt files


        chdir ("$base_dir");
        system ("del cust\\$pgsql_targetdir\\finished*.txt");
        system ("del orders\\$pgsql_targetdir\\finished*.txt");
        system ("del membership\\$pgsql_targetdir\\finished*.txt");
        system ("del prod\\$pgsql_targetdir\\finished*.txt");
        system ("del reviews\\$pgsql_targetdir\\finished*.txt");

}  # End Windows version











