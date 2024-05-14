# mysqlds3_perl_create_db_tables_multi.pl
# Script to create a ds3 tables in MySQL with a provided number of copies - supporting multiple stores
# Syntax to run - perl mysqlds3_perl_create_db_tables_multi.pl <mysql_target> <number_of_stores> 

use strict;
use warnings;

my $mysqltarget = $ARGV[0];
my $numberofstores = $ARGV[1];

#Need seperate target directory so that mulitple DB Targets can be loaded at the same time
my $mysql_targetdir;  

$mysql_targetdir = $mysqltarget;

# remove any backslashes from string to be used for directory name
$mysql_targetdir =~ s/\\//;

system ("mkdir $mysql_targetdir");

#First call the script to prepare for the creation of the database - which will delete any existing DS3 database

system ("mysql -h $mysqltarget -u web --password=web < mysqlds35_prep_create_db.sql"); 

foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">$mysql_targetdir\\mysqlds35_createtables.sql") || die("Can't open $mysql_targetdir\\mysqlds35_createtables.sql");
	print $OUT  "-- Tables
USE DS3;

CREATE TABLE CUSTOMERS$k
  (
  CUSTOMERID INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  FIRSTNAME VARCHAR(50) NOT NULL, 
  LASTNAME VARCHAR(50) NOT NULL, 
  ADDRESS1 VARCHAR(50) NOT NULL, 
  ADDRESS2 VARCHAR(50), 
  CITY VARCHAR(50) NOT NULL, 
  STATE VARCHAR(50), 
  ZIP INT, 
  COUNTRY VARCHAR(50) NOT NULL, 
  REGION TINYINT NOT NULL,
  EMAIL VARCHAR(50),
  PHONE VARCHAR(50),
  CREDITCARDTYPE INT NOT NULL,
  CREDITCARD VARCHAR(50) NOT NULL, 
  CREDITCARDEXPIRATION VARCHAR(50) NOT NULL, 
  USERNAME VARCHAR(50) NOT NULL, 
  PASSWORD VARCHAR(50) NOT NULL, 
  AGE TINYINT, 
  INCOME INT,
  GENDER VARCHAR(1) 
  )
  ENGINE = InnoDB;
  
CREATE TABLE CUST_HIST$k
  (
  CUSTOMERID INT NOT NULL, 
  ORDERID INT NOT NULL, 
  PROD_ID INT NOT NULL 
  )
  ENGINE = InnoDB;

CREATE TABLE MEMBERSHIP$k
  (
  CUSTOMERID INT NOT NULL,
  MEMBERSHIPTYPE INT NOT NULL,
  EXPIREDATE DATE NOT NULL
  )
  ENGINE = InnoDB;
  
CREATE TABLE ORDERS$k
  (
  ORDERID INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  ORDERDATE DATE NOT NULL, 
  CUSTOMERID INT, 
  NETAMOUNT NUMERIC(12,2) NOT NULL, 
  TAX NUMERIC(12,2) NOT NULL, 
  TOTALAMOUNT NUMERIC(12,2) NOT NULL
  )
  ENGINE = InnoDB; 
  
CREATE TABLE ORDERLINES$k
  (
  ORDERLINEID SMALLINT NOT NULL, 
  ORDERID INT NOT NULL, 
  PROD_ID INT NOT NULL, 
  QUANTITY SMALLINT NOT NULL, 
  ORDERDATE DATE NOT NULL
  )
  ENGINE = InnoDB; 
  
CREATE TABLE PRODUCTS$k
  (
  PROD_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  CATEGORY TINYINT NOT NULL, 
  TITLE VARCHAR(50) NOT NULL, 
  ACTOR VARCHAR(50) NOT NULL, 
  PRICE NUMERIC(12,2) NOT NULL, 
  SPECIAL TINYINT,
  COMMON_PROD_ID INT NOT NULL,
  MEMBERSHIP_ITEM INT NOT NULL 
  )
  ENGINE = MyISAM;

CREATE TABLE REVIEWS$k
  (
  REVIEW_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  PROD_ID INT NOT NULL,
  REVIEW_DATE DATE NOT NULL,
  STARS INT NOT NULL,
  CUSTOMERID INT NOT NULL,
  REVIEW_SUMMARY VARCHAR(50) NOT NULL,
  REVIEW_TEXT VARCHAR(1000) NOT NULL
  )
  ENGINE = InnoDB;

CREATE TABLE REVIEWS_HELPFULNESS$k
  (
  REVIEWS_HELPFULNESS_ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  REVIEW_ID INT NOT NULL,
  CUSTOMERID INT NOT NULL,
  HELPFULNESS INT NOT NULL
  ) 
  ENGINE = InnoDB;

CREATE TABLE INVENTORY$k
  (
  PROD_ID INT NOT NULL PRIMARY KEY,
  QUAN_IN_STOCK INT NOT NULL,
  SALES INT NOT NULL
  )
  ENGINE = InnoDB;
   

CREATE TABLE CATEGORIES$k
  (
  CATEGORY TINYINT NOT NULL AUTO_INCREMENT PRIMARY KEY, 
  CATEGORYNAME VARCHAR(50) NOT NULL  
  )
  ENGINE = InnoDB;
   
  
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
  )
  ENGINE = InnoDB;
  
\n";
  close $OUT;
  sleep(1);
  print ("mysql -h $mysqltarget -u web --password=web < $mysql_targetdir\\mysqlds35_createtables.sql");
  system ("mysql -h $mysqltarget -u web --password=web < $mysql_targetdir\\mysqlds35_createtables.sql");
  #system ("del $mysql_targetdir\\mysqlds35_createtables.sql");
  }
