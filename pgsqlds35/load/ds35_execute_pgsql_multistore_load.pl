# ds35_execute_psql_multistore_load.pl
# Script to execute psql data loads in parallel for a set of ds35 psql tables files for a given number of stores
# Syntax to run - perl ds35_execute_psql_multistore_load.pl <psql_target> <number_of_stores> 

use strict;
use warnings;
use Cwd qw(getcwd);

my $psqltarget = $ARGV[0];
my $numStores = $ARGV[1];

my $movecommand;
my $timecommand;
my $pathsep;

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
        system ("del cust\\finished*.txt");
        system ("del orders\\finished*.txt");
        system ("del membership\\finished*.txt");
        system ("del prod\\finished*.txt");
        system ("del reviews\\finished*.txt");

        print "Load started at ".(localtime), "\n";


        chdir("$base_dir\\membership");
        foreach my $k (1 .. $numStores){
                system ("start remote_pgsqlds35_membership_load$k.bat");
                }

        chdir("$base_dir\\prod");
        foreach my $k (1 .. $numStores){
                system ("start remote_pgsqlds35_prod_load$k.bat");
                system ("start remote_pgsqlds35_inv_load$k.bat");
                }

        chdir("$base_dir\\reviews");
        foreach my $k (1 .. $numStores){
                system ("start remote_pgsqlds35_reviews_load$k.bat");
                system ("start remote_pgsqlds35_reviewshelpful_load$k.bat");
                }

        chdir("$base_dir\\orders");
        foreach my $k (1 .. $numStores){
                system ("start remote_pgsqlds35_orders_load$k.bat");
                system ("start remote_pgsqlds35_orderlines_load$k.bat");
                system ("start remote_pgsqlds35_cust_hist_load$k.bat");
                }

        chdir("$base_dir\\cust");
        foreach my $k (1 .. $numStores){
		system ("start remote_pgsqlds35_cust_load$k.bat");
                }

        # Each load file creates a finishedxx.txt file after completing it's load.  The code
        # here loops until there is a finished file for the last store in each directory.
        # It assumes that becuase each set of loads will finish within 10 seconds of each
        # other, then does a cleanup of the finished files.

        my $cust_finished_file = "$base_dir\\cust\\finished$numStores.txt";
        my $orders_finished_file = "$base_dir\\orders\\finished$numStores.txt";
        my $reviews_finished_file = "$base_dir\\reviews\\finished$numStores.txt";
		my $reviewshelp_finished_file = "$base_dir\\reviews\\finishedhelp$numStores.txt";
        my $prod_finished_file = "$base_dir\\prod\\finished$numStores.txt";
        my $membership_finished_file = "$base_dir\\membership\\finished$numStores.txt";

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
        system ("del cust\\finished*.txt");
        system ("del orders\\finished*.txt");
        system ("del membership\\finished*.txt");
        system ("del prod\\finished*.txt");
        system ("del reviews\\finished*.txt");

}  # End Windows version











