# pgsqlds35_perl_create_db_tables_multi.pl
# Script to create ds35 tables in PostgresQL with a provided number of copies - supporting multiple stores
# Syntax to run: perl pgsqlds35_perl_create_db_tables_multi.pl <pgsql_target> <number of stores>
# Last updated 11/2/21

use strict;
use warnings;

my $pgsql_target = $ARGV[0];
my $numStores = $ARGV[1];
my $DBNAME = "ds3";
my $SYSDBA = "ds3";
my $PGPASSWORD = "ds3";

#Need seperate target directory so that mulitple DB Targets can be loaded at the same time
my $pgsql_targetdir;  

$pgsql_targetdir = $pgsql_target;

# remove any backslashes from string to be used for directory name
$pgsql_targetdir =~ s/\\//;

system ("mkdir $pgsql_targetdir");

# First call the script to prepare for the creation of the database which will delete any existing DS35 database

#system("PGPASSWORD=$PGPASSWORD psql -h $pgsql_target -U postgres -d postgres < pgsqlds35_prep_create_db.sql");
system("psql -h $pgsql_target -U postgres -d postgres < pgsqlds35_prep_create_db.sql");

foreach my $k (1 .. $numStores){
	open(my $OUT, ">$pgsql_targetdir\\pgsqlds35_createtables.sql") || die("Can't open pgsqlds35_createtables.sql");
	print $OUT "-- Tables

\\c ds3;

 
 CREATE TABLE CUSTOMERS$k
  (
  CUSTOMERID SERIAL PRIMARY KEY,
  FIRSTNAME VARCHAR(50) NOT NULL,
  LASTNAME VARCHAR(50) NOT NULL,
  ADDRESS1 VARCHAR(50) NOT NULL,
  ADDRESS2 VARCHAR(50),
  CITY VARCHAR(50) NOT NULL,
  STATE VARCHAR(50),
  ZIP VARCHAR(9),
  COUNTRY VARCHAR(50) NOT NULL,
  REGION SMALLINT NOT NULL,
  EMAIL VARCHAR(50),
  PHONE VARCHAR(50),
  CREDITCARDTYPE INT NOT NULL,
  CREDITCARD VARCHAR(50) NOT NULL,
  CREDITCARDEXPIRATION VARCHAR(50) NOT NULL,
  USERNAME VARCHAR(50) NOT NULL,
  PASSWORD VARCHAR(50) NOT NULL,
  AGE SMALLINT,
  INCOME INT,
  GENDER VARCHAR(1)
  );
  
  CREATE TABLE CUST_HIST$k
  (
  CUSTOMERID INT NOT NULL,
  ORDERID INT NOT NULL,
  PROD_ID INT NOT NULL
  );

  CREATE TABLE ORDERS$k
  (
  ORDERID SERIAL PRIMARY KEY,
  ORDERDATE DATE NOT NULL,
  CUSTOMERID INT,
  NETAMOUNT NUMERIC NOT NULL,
  TAX NUMERIC NOT NULL,
  TOTALAMOUNT NUMERIC NOT NULL
  );

  CREATE TABLE ORDERLINES$k
  (
  ORDERLINEID SMALLINT NOT NULL,
  ORDERID INT NOT NULL,
  PROD_ID INT NOT NULL,
  QUANTITY SMALLINT NOT NULL,
  ORDERDATE DATE NOT NULL
  );

  CREATE TABLE PRODUCTS$k
  (
  PROD_ID SERIAL PRIMARY KEY,
  CATEGORY SMALLINT NOT NULL,
  TITLE TEXT NOT NULL,
  ACTOR TEXT NOT NULL,
  PRICE NUMERIC NOT NULL,
  SPECIAL SMALLINT,
  COMMON_PROD_ID INT NOT NULL,
  MEMBERSHIP_ITEM SMALLINT NOT NULL
  );

  CREATE TABLE INVENTORY$k
  (
  PROD_ID INT NOT NULL PRIMARY KEY,
  QUAN_IN_STOCK INT NOT NULL,
  SALES INT NOT NULL
  ) WITH (fillfactor=85);

  CREATE TABLE CATEGORIES$k
  (
  CATEGORY SERIAL PRIMARY KEY,
  CATEGORYNAME VARCHAR(50) NOT NULL
  );

  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (1,'Action');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (2,'Animation');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (3,'Children');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (4,'Classics');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (5,'Comedy');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (6,'Documentary');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (7,'Drama');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (8,'Family');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (9,'Foreign');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (10,'Games');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (11,'Horror');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (12,'Music');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (13,'New');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (14,'Sci-Fi');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (15,'Sports');
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (16,'Travel');

  CREATE TABLE REORDER$k
  (
  PROD_ID INT NOT NULL,
  DATE_LOW DATE NOT NULL,
  QUAN_LOW INT NOT NULL,
  DATE_REORDERED DATE,
  QUAN_REORDERED INT,
  DATE_EXPECTED DATE
  );

  CREATE TABLE REVIEWS$k
  (
  REVIEW_ID SERIAL PRIMARY KEY,
  PROD_ID INT NOT NULL,
  REVIEW_DATE DATE NOT NULL,
  STARS SMALLINT NOT NULL,
  CUSTOMERID INT NOT NULL,
  REVIEW_SUMMARY TEXT NOT NULL,
  REVIEW_TEXT TEXT NULL
  );

  CREATE TABLE REVIEWS_HELPFULNESS$k
  (
  REVIEW_HELPFULNESS_ID SERIAL PRIMARY KEY,
  REVIEW_ID INT NOT NULL,
  CUSTOMERID INT NOT NULL,
  HELPFULNESS SMALLINT NOT NULL
  );

  CREATE TABLE MEMBERSHIP$k
  (
  CUSTOMERID INT NOT NULL PRIMARY KEY,
  MEMBERSHIPTYPE INT NOT NULL,
  EXPIREDATE DATE NOT NULL
  );

\n";
	close $OUT;
	sleep(1);
	print("psql -h $pgsql_target -U $SYSDBA -d $DBNAME < $pgsql_targetdir\\pgsqlds35_createtables.sql\n");
      	#system("PGPASSWORD=$PGPASSWORD psql -h $pgsql_target -U $SYSDBA -d $DBNAME < pgsqlds35_createtables.sql");
		system("psql -h $pgsql_target -U $SYSDBA -d $DBNAME < $pgsql_targetdir\\pgsqlds35_createtables.sql");
}

