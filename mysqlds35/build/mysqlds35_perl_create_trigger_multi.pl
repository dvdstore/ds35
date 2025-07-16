# mysqlds35_perl_create_trigger_multi.pl
# Script to create a ds35 store triggers in MySQL with a provided number of copies - supporting multiple stores
# Syntax to run - perl mysqlds35_perl_create_trigger_multi.pl <mysql_target> <number_of_stores> 

use strict;
use warnings;

my $mysqltarget = $ARGV[0];
my $numberofstores = $ARGV[1];

my $pathsep;

#Need seperate target directory so that mulitple DB Targets can be loaded at the same time
my $mysql_targetdir;  

$mysql_targetdir = $mysqltarget;

# remove any backslashes from string to be used for directory name
$mysql_targetdir =~ s/\\//;

system ("mkdir -p $mysql_targetdir");

# print "$^O\n";

# This section enables support for Linux and Windows - detecting the type of OS, and then using the proper commands
if ("$^O" eq "linux")
        {
        $pathsep = "/";
        }
else
        {
        $pathsep = "\\\\";
        };

foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">$mysql_targetdir${pathsep}mysqlds35_create_trigger.sql") || die("Can't open $mysql_targetdir${pathsep}mysqlds35_create_trigger.sql");
	print $OUT  "Delimiter $$
DROP TRIGGER IF EXISTS DS3.RESTOCK$k;
CREATE TRIGGER DS3.RESTOCK$k BEFORE UPDATE ON DS3.INVENTORY$k
FOR EACH ROW
BEGIN
 IF ( NEW.QUAN_IN_STOCK < 3 ) THEN
    INSERT INTO DS3.REORDER$k(PROD_ID, DATE_LOW, QUAN_LOW) VALUES(NEW.PROD_ID, CURDATE(), NEW.QUAN_IN_STOCK) ;
    SET NEW.QUAN_IN_STOCK = (NEW.QUAN_IN_STOCK + 5) ;
 END IF;
END; $$
\n";
  close $OUT;
  sleep(1);
  print ("mysql -h $mysqltarget -u web --password=web < $mysql_targetdir${pathsep}mysqlds35_create_trigger.sql\n");
  system ("mysql -h $mysqltarget -u web --password=web < $mysql_targetdir${pathsep}mysqlds35_create_trigger.sql");
  #system ("del $mysql_targetdir${pathsep}mysqlds35_create_trigger.sql");
  }
