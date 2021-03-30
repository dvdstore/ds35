# ds3_execute_mysql_cleanup.pl
# Script to execute mysql cleanup in parallel for a set of ds3 sqlserver tables files for a given number of stores
# Syntax to run - perl ds3_execute_mysql_cleanup.pl <mysql_target> <number_of_stores> 

use strict;
use warnings;
use Cwd qw(getcwd);

my $mysqltarget = $ARGV [0];
my $numberofstores = $ARGV[1];

my $num_finished = 0;

#Load data into tables using scripts created by ds3_create_mysql_multistore_load_files.pl


print "Cleanup started at ".(localtime), "\n";
system ("mysql -h $mysqltarget -u web --password=web --local_infile DS3 < mysqlds35_cleanuptables.sql");
print "Cleanup finished at ".(localtime), "\n";