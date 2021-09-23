# mysqlds35_perl_cleanup_multi.pl
# Script to cleanup or reset ds35 tables in MySQL with a provided number of copies - supporting multiple stores
# Syntax to run - perl mysqlds3_perl_cleanup_multi.pl <mysql_target> <number_of_stores> <DB Size - example 10> <DB Size Units - MB or GB>

use strict;
use warnings;

my $mysqltarget = $ARGV[0];
my $numberofstores = $ARGV[1];
my $database_size = $ARGV[2];
my $database_size_str = $ARGV[3];

#print "$ARGV[0] $ARGV[1] $ARGV[2] $ARGV[3]\n";

#my $database_size;                                     #Database Size
#my $database_size_str;
my $is_GB_Size_S = "gb";
my $is_MB_Size_S = "mb";
my $bln_is_Large_DB = 0;
my $bln_is_Small_DB = 0;
my $bln_is_Medium_DB = 0;
my $str_is_Small_DB = "";
my $str_is_Medium_DB = "";
my $str_is_Large_DB = "";
my $str_file_name = "";

#Interactive prompts for size
#print "Please enter following parameters: \n";
#print "***********************************\n";
#print "Please enter database size (integer expected) : ";
#chomp($database_size = <STDIN>);
#print "Please enter whether above database size is in (MB / GB) : ";
#chomp($database_size_str = <STDIN>);
#print "***********************************\n";
#***************************************************************************************

#Set the flags according to parameters passed. These flags will be used further
if(lc($database_size_str) eq lc($is_GB_Size_S))
{
        if($database_size == 1)
        {
                $bln_is_Medium_DB = 1;
                $str_is_Medium_DB = "M";
        }
        elsif($database_size > 1 && $database_size < 1024)
        {
                $bln_is_Large_DB = 1;
                $str_is_Large_DB = "L";
        }
}
elsif(lc($database_size_str) eq lc($is_MB_Size_S))
{
        if($database_size >= 1 && $database_size < 1024)
        {
                $bln_is_Small_DB = 1;
                $str_is_Small_DB = "S";
        }
}


#First we need to calculate ratio which will determine number of rows in Major tables
# Customer, Orders and Products

my $i_Cust_Rows = 0;
my $i_Ord_Rows = 0;
my $i_Prod_Rows = 0;
my $i_Membership_Rows = 0;
my $i_Review_Rows = 0;

my $mult_Cust_Rows = 0;
my $mult_Ord_Rows = 0;
my $mult_Prod_Rows = 0;
my $ratio_Mult = 0;
my $ratio_Cust = 0;
my $ratio_Ord = 0;
my $ratio_Prod = 0;

my $par_Pct_Member = 10;        # Percentage of users that are in the membership program


my $par_Avg_Reviews = 20;       # Average number of reviews per product
my $par_review_rows;


#For small database (Database size greater than 10MB till 1GB/ 1000 MB)
if($bln_is_Small_DB == 1)
{
        #Now base DB will be 10MB database and ratio calculated wrt to that
        print "Small size database (less than 1 GB) \n";
        $mult_Cust_Rows = 20000;                                # 2 x 10^4
        $mult_Ord_Rows = 1000;                                  # 1 x 10^3
        $mult_Prod_Rows = 10000;                                # 1 x 10^4
        $ratio_Mult = ($database_size / 10);    # 10MB database is base
}

#For medium database with size exactly 1GB
if($bln_is_Medium_DB == 1)
{
        print "Medium size database ( equal to 1 GB) \n";
        $mult_Cust_Rows = 2000000;                              # 2 x 10^6
        $mult_Ord_Rows = 100000;                                # 1 x 10^5
        $mult_Prod_Rows = 100000;                               # 1 x 10^5
        $ratio_Mult = ($database_size / 1);             # 1GB database is base
}

#For large database with size > 1GB
if($bln_is_Large_DB == 1)
{
        print "Large size database ( greater than 1 GB) \n";
        $mult_Cust_Rows = 200000000;                    # 2 x 10^8
        $mult_Ord_Rows = 10000000;                              # 1 x 10^7
        $mult_Prod_Rows = 1000000;                              # 1 x 10^6
        $ratio_Mult = ($database_size / 100);   # 100GB database is base
}

print "Ratio calculated : $ratio_Mult \n";

#Calculate number of rows in table according to ratio
$i_Cust_Rows = ($mult_Cust_Rows * $ratio_Mult);
$i_Ord_Rows = ($mult_Ord_Rows * $ratio_Mult * 12);  #Times 12 to account for all 12 months
$i_Prod_Rows = ($mult_Prod_Rows * $ratio_Mult);

$i_Membership_Rows = $i_Cust_Rows * ($par_Pct_Member/100);
$i_Review_Rows = $i_Prod_Rows * $par_Avg_Reviews;

#Print number of rows for a check
print "Customer Rows: $i_Cust_Rows \n";
print "Order Rows / month: $i_Ord_Rows \n";
print "Product Rows: $i_Prod_Rows \n";



foreach my $k (1 .. $numberofstores){
        open (my $OUT, ">mysqlds35_cleanuptables.sql") || die("Can't open mysqlds35_cleanuptables.sql");
        print $OUT  "-- Clean Up Tables
use DS3;

SET UNIQUE_CHECKS=0;
SET FOREIGN_KEY_CHECKS=0;

alter table CUSTOMERS$k DISABLE KEYS;
alter table ORDERS$k DISABLE KEYS;
alter table ORDERLINES$k DISABLE KEYS;
alter table CUST_HIST$k DISABLE KEYS;
alter table REVIEWS$k DISABLE KEYS;
alter table REVIEWS_HELPFULNESS$k DISABLE KEYS;

delete from CUSTOMERS$k where CUSTOMERID > $i_Cust_Rows;
delete from ORDERS$k where ORDERID > $i_Ord_Rows;
delete from ORDERLINES$k where ORDERID > $i_Ord_Rows;
delete from CUST_HIST$k where ORDERID > $i_Ord_Rows;
delete from REVIEWS$k where REVIEW_ID > $i_Review_Rows;
delete from REVIEWS_HELPFULNESS$k where REVIEW_ID > $i_Review_Rows;

alter table REVIEWS$k ENABLE KEYS;
alter table REVIEWS_HELPFULNESS$k ENABLE KEYS;
alter table CUST_HIST$k ENABLE KEYS;
alter table ORDERLINES$k ENABLE KEYS;
alter table ORDERS$k ENABLE KEYS;
alter table CUSTOMERS$k ENABLE KEYS;

SET FOREIGN_KEY_CHECKS=1;
SET UNIQUE_CHECKS=1;

drop table INVENTORY$k;

CREATE TABLE INVENTORY$k
  (
  PROD_ID INT NOT NULL PRIMARY KEY,
  QUAN_IN_STOCK INT NOT NULL,
  SALES INT NOT NULL
  )
  ENGINE=InnoDB;

alter table INVENTORY$k DISABLE KEYS;

LOAD DATA LOCAL INFILE \"../../data_files/prod/inv.csv\"
  INTO TABLE INVENTORY$k
  FIELDS TERMINATED BY
  ',' OPTIONALLY ENCLOSED BY '\"';

alter table INVENTORY$k ENABLE KEYS;



\n";
  close $OUT;
  sleep(1);
  print ("Cleaning Store number $k\n");
  print ("mysql -h $mysqltarget -u web --password=web < mysqlds35_cleanuptables.sql\n");
  system ("mysql -h $mysqltarget -u web --password=web < mysqlds35_cleanuptables.sql");
  #system ("del mysqlds35_cleanuptables.sql");
  }
