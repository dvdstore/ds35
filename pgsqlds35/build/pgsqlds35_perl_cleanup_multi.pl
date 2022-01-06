# pgsqlds35_perl_cleanup_multi.pl
# Script to cleanup or reset ds35 tables in PostgresQL with a provided number of copies -- supporting multiple stores
# Syntax to run: perl pgsqlds35_perl_cleanup_multi.pl <psql_target> <number_of_stores> <DB size - example 10> <DB size units - MB or GB>

use strict;
use warnings;

my $psqltarget = $ARGV[0];
my $numberofstores = $ARGV[1];
my $database_size = $ARGV[2];
my $database_size_str = $ARGV[3];

my $SYSDBA = "ds3";
my $DBNAME = "ds3";
my $PGPASSWORD = "ds3";

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
	open(my $OUT, ">pgsqlds35_cleanuptables.sql") || die("Can't open pgsqlds35_cleanuptables.sql");
	my $i_Member_Rows = $i_Cust_Rows / 10;
	print $OUT "-- Clean up Tables
\\c ds3;

alter table CUSTOMERS$k DISABLE TRIGGER ALL;
alter table ORDERS$k DISABLE TRIGGER ALL;
alter table ORDERLINES$k DISABLE TRIGGER ALL;
alter table CUST_HIST$k DISABLE TRIGGER ALL;
alter table REVIEWS$k DISABLE TRIGGER ALL;
alter table REVIEWS_HELPFULNESS$k DISABLE TRIGGER ALL;
alter table MEMBERSHIP$k DISABLE TRIGGER ALL;

delete from CUSTOMERS$k where CUSTOMERID > $i_Cust_Rows;
delete from ORDERS$k where ORDERID > $i_Ord_Rows;
delete from ORDERLINES$k where ORDERID > $i_Ord_Rows;
delete from CUST_HIST$k where ORDERID > $i_Ord_Rows;
delete from REVIEWS$k where REVIEW_ID > $i_Review_Rows;
delete from REVIEWS_HELPFULNESS$k where REVIEW_HELPFULNESS_ID > $i_Review_Rows;
delete from MEMBERSHIP$k where CUSTOMERID > $i_Member_Rows;

alter table CUST_HIST$k ENABLE TRIGGER ALL;
alter table ORDERLINES$k ENABLE TRIGGER ALL;
alter table ORDERS$k ENABLE TRIGGER ALL;
alter table CUSTOMERS$k ENABLE TRIGGER ALL;
alter table REVIEWS$k ENABLE TRIGGER ALL;
alter table REVIEWS_HELPFULNESS$k ENABLE TRIGGER ALL;
alter table MEMBERSHIP$k ENABLE TRIGGER ALL;

drop table INVENTORY$k;

CREATE TABLE INVENTORY$k
  (
  PROD_ID INT NOT NULL PRIMARY KEY,
  QUAN_IN_STOCK INT NOT NULL,
  SALES INT NOT NULL
  )
  ;

alter table INVENTORY$k DISABLE TRIGGER ALL;

\\copy INVENTORY$k FROM '../../data_files/prod/inv.csv' DELIMITER ',' CSV

alter table INVENTORY$k ENABLE TRIGGER ALL;

GRANT ALL PRIVILEGES on INVENTORY$k to ds3;
\n";
	close $OUT;
	sleep(1);
	print ("Cleaning Store number $k\n");
  	print ("psql -h $psqltarget -U $SYSDBA -d $DBNAME < pgsqlds35_cleanuptables.sql\n");
  	system ("PGPASSWORD=$PGPASSWORD psql -h $psqltarget -U $SYSDBA -d $DBNAME < pgsqlds35_cleanuptables.sql");
}
