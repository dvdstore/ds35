# ds35_create_oracle_sqlldr_ctl.pl
# Script to create an oracle sqlldr ctl file that defines the bulk load with table and definition of data
# Syntax to run - perl ds3_create_oracle_sqlldr_ctl.pl <tablename> <ds3_tabletype> <ctl_filename> <partitionname - only needed for orders, orderlines, and cust types>
# The ds3_tabletype options are CUST ORDERS ORDERLINES CUST_HIST REVIEWS REVIEWHELPFULNESS MEMBERS PROD INV 
# key parameters that are changed often are at the top of the file  

use strict;
use warnings;

my $tablename = $ARGV[0];
my $ds3tabletype = $ARGV[1];
my $ctlfilename = $ARGV[2];
my $partitionname = $ARGV[3];
my $ds3tabledefinition;

open (my $OUT, ">$ctlfilename") || die("Can't open $ctlfilename");

print $OUT "OPTIONS(DIRECT=TRUE, PARALLEL=TRUE)\n";  #output standard beginning of ctl file
print $OUT " \n";
print $OUT "UNRECOVERABLE\n";
print $OUT " \n";
print $OUT "LOAD DATA\n";
print $OUT " \n";
print $OUT "APPEND\n";
print $OUT " \n";

print $OUT "INTO TABLE ds3.$tablename \n";
print $OUT " \n";

if (($ds3tabletype eq 'ORDERS') or ($ds3tabletype eq 'ORDERLINES') or ($ds3tabletype eq 'CUST')) { 
	print $OUT "PARTITION (" . $partitionname . ")\n";
	print $OUT "\n";
	}
print $OUT "FIELDS TERMINATED BY \",\" OPTIONALLY ENCLOSED BY '\"'\n";
print $OUT " \n";
print $OUT "TRAILING NULLCOLS\n";
print $OUT " \n";

if ($ds3tabletype eq 'ORDERS') {
	$ds3tabledefinition = "(ORDERID integer external,ORDERDATE date \"yyyy/mm/dd\",CUSTOMERID integer external,NETAMOUNT decimal external,TAX decimal external,TOTALAMOUNT decimal external) ";
    }
if ($ds3tabletype eq 'ORDERLINES') {
	$ds3tabledefinition = "(ORDERLINEID integer external,
ORDERID integer external,
PROD_ID integer external,
QUANTITY integer external,
ORDERDATE date \"yyyy/mm/dd\") ";
    }
	if ($ds3tabletype eq 'CUST_HIST') {
	$ds3tabledefinition = "(CUSTOMERID integer external,
ORDERID integer external,
PROD_ID integer external) ";
    }
	if ($ds3tabletype eq 'CUST') {
	$ds3tabledefinition = "(CUSTOMERID integer external,
FIRSTNAME char,
LASTNAME char,
ADDRESS1 char,
ADDRESS2 char,
CITY char,
STATE char,
ZIP integer external,
COUNTRY char,
REGION integer external,
EMAIL char,
PHONE char,
CREDITCARDTYPE integer external,
CREDITCARD char,
CREDITCARDEXPIRATION char,
USERNAME char,
PASSWORD char,
AGE integer external,
INCOME integer external,
GENDER char)\n";
    }
	if ($ds3tabletype eq 'REVIEWS') {
	$ds3tabledefinition = "(REVIEW_ID integer external,
PROD_ID integer external,
REVIEW_DATE date \"yyyy/mm/dd\", 
STARS integer external,
CUSTOMERID integer external,
REVIEW_SUMMARY char,
REVIEW_TEXT char(1000))\n";
    }
	if ($ds3tabletype eq 'REVIEWHELPFULNESS') {
	$ds3tabledefinition = "(REVIEW_HELPFULNESS_ID integer external,
REVIEW_ID integer external,
CUSTOMERID integer external,
HELPFULNESS integer external)\n";
    }
	if ($ds3tabletype eq 'MEMBERS') {
	$ds3tabledefinition = "(CUSTOMERID integer external,
MEMBERSHIPTYPE integer external,
EXPIREDATE date \"yyyy/mm/dd\")\n ";
    }
	if ($ds3tabletype eq 'PROD') {
	$ds3tabledefinition = "(PROD_ID integer external,
CATEGORY integer external,
TITLE char,
ACTOR char,
PRICE decimal external,
SPECIAL integer external,
COMMON_PROD_ID integer external,
MEMBERSHIP_ITEM integer external)\n";
    }
	if ($ds3tabletype eq 'INV') {
	$ds3tabledefinition = "(PROD_ID integer external,
QUAN_IN_STOCK integer external,
SALES integer external)\n";
    }
	
print $OUT "$ds3tabledefinition \n";

close $OUT;