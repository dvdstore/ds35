# ds3_perl_rebuild_instances.pl
# Script to rebuild DVD Store 3.5 instances
# Syntax to run - perl ds3_perl_rebuild_instances.pl <sqlserver_target> <number_of_stores> 

use strict;
use warnings;
use Cwd qw(getcwd);

my $sqltarget = $ARGV [0];
my $numberofstores = $ARGV[1];

my @instance_name_list = ("10.133.255.188","10.133.255.188\\TWO","10.133.255.188\\THREE","10.133.255.188\\FOUR");
my @filepath_name_list = ("e:\\dbfiles\\","e:\\dbfiles2\\","e:\\dbfiles3\\","e:\\dbfiles4\\");
my @logpath_name_list = ("f:\\dbfiles\\","f:\\dbfiles2\\","f:\\dbfiles3\\","f:\\dbfiles4\\");

my $num_finished = 0;

my $start_time;

my $base_dir = getcwd;    #get the current working directory 

# Delete any finishedxx.txt files that might be present from previous runs

print "Instance rebuild started at ".(localtime), "\n";
$start_time = localtime;

chdir ("$base_dir");
system ("sqlserverds35_create_all_concurrent_5GB_DB1.bat ${instance_name_list[0]} $numberofstores");
system ("sqlserverds35_create_all_concurrent_5GB_DB2.bat ${instance_name_list[1]} $numberofstores");
system ("sqlserverds35_create_all_concurrent_5GB_DB3.bat ${instance_name_list[2]} $numberofstores");
system ("sqlserverds35_create_all_concurrent_5GB_DB4.bat ${instance_name_list[3]} $numberofstores");

print "Instance rebuild started at $start_time \n";
print "Instance rebuild finished at ".(localtime), "\n";



