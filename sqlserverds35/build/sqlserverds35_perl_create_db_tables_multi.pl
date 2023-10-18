# sqlserverds35_perl_create_db_tables_multi.pl
# Script to create a ds35 tables in sqlserver with a provided number of copies - supporting multiple stores
# Syntax to run - perl sqlserverds35_perl_create_db_tables_multi.pl <sqlserver_target> <number_of_stores> 

use strict;
use warnings;

my $sqlservertarget = $ARGV[0];
my $numberofstores = $ARGV[1];

#Need seperate target directory so that mulitple DB Targets can be loaded at the same time
my $sqlservertargetdir;  

$sqlservertargetdir = $sqlservertarget;

# remove any backslashes from string to be used for directory name
$sqlservertargetdir =~ s/\\//;

system ("mkdir $sqlservertargetdir");

foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">$sqlservertargetdir\\sqlserverds35_createtables.sql") || die("Can't open sqlserverds35_createtables.sql");
	print $OUT  "-- Tables
USE DS3
GO

CREATE TABLE CUSTOMERS$k
  (
  CUSTOMERID INT IDENTITY NOT NULL, 
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
  CREDITCARDTYPE TINYINT NOT NULL,
  CREDITCARD VARCHAR(50) NOT NULL, 
  CREDITCARDEXPIRATION VARCHAR(50) NOT NULL, 
  USERNAME VARCHAR(50) NOT NULL, 
  PASSWORD VARCHAR(50) NOT NULL, 
  AGE TINYINT, 
  INCOME INT,
  GENDER VARCHAR(1)
  )
  ON DS_CUST_FG
GO  
  
CREATE TABLE CUST_HIST$k
  (
  CUSTOMERID INT NOT NULL, 
  ORDERID INT NOT NULL, 
  PROD_ID INT NOT NULL 
  )
  ON DS_CUST_FG
GO
  
CREATE TABLE MEMBERSHIP$k
  (
  CUSTOMERID INT NOT NULL, 
  MEMBERSHIPTYPE INT NOT NULL, 
  EXPIREDATE DATETIME NOT NULL 
  )
  ON DS_MEMBER_FG
GO


CREATE TABLE ORDERS$k
  (
  ORDERID INT IDENTITY NOT NULL, 
  ORDERDATE DATETIME NOT NULL, 
  CUSTOMERID INT NOT NULL, 
  NETAMOUNT MONEY NOT NULL, 
  TAX MONEY NOT NULL, 
  TOTALAMOUNT MONEY NOT NULL
  ) 
  ON DS_ORDERS_FG
GO

CREATE TABLE ORDERLINES$k
  (
  ORDERLINEID SMALLINT NOT NULL, 
  ORDERID INT NOT NULL, 
  PROD_ID INT NOT NULL, 
  QUANTITY SMALLINT NOT NULL, 
  ORDERDATE DATETIME NOT NULL
  ) 
  ON DS_ORDERS_FG
GO

CREATE TABLE PRODUCTS$k
  (
  PROD_ID INT IDENTITY NOT NULL, 
  CATEGORY TINYINT NOT NULL, 
  TITLE VARCHAR(50) NOT NULL, 
  ACTOR VARCHAR(50) NOT NULL, 
  PRICE MONEY NOT NULL, 
  SPECIAL TINYINT,
  COMMON_PROD_ID INT NOT NULL,
  MEMBERSHIP_ITEM INT NOT NULL
  )
  ON DS_MISC_FG
GO 

CREATE TABLE REVIEWS$k
  (
  REVIEW_ID INT IDENTITY NOT NULL, 
  PROD_ID INT NOT NULL,
  REVIEW_DATE DATETIME NOT NULL,
  STARS INT NOT NULL,
  CUSTOMERID INT NOT NULL, 
  REVIEW_SUMMARY VARCHAR(50) NOT NULL, 
  REVIEW_TEXT VARCHAR(1000) NOT NULL
  )
  ON DS_REVIEW_FG
GO 

CREATE TABLE REVIEWS_HELPFULNESS$k
  (
  REVIEW_HELPFULNESS_ID INT IDENTITY NOT NULL, 
  REVIEW_ID INT NOT NULL,
  CUSTOMERID INT NOT NULL,  
  HELPFULNESS INT NOT NULL
  )
  ON DS_REVIEW_FG
GO 

CREATE TABLE INVENTORY$k
  (
  PROD_ID INT NOT NULL,
  QUAN_IN_STOCK INT NOT NULL,
  SALES INT NOT NULL
  )
  ON DS_MISC_FG
GO

CREATE TABLE CATEGORIES$k
  (
  CATEGORY TINYINT IDENTITY NOT NULL, 
  CATEGORYNAME VARCHAR(50) NOT NULL, 
  )
  ON DS_MISC_FG
GO 

  SET IDENTITY_INSERT CATEGORIES$k ON 
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (1,'Action')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (2,'Animation')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (3,'Children')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (4,'Classics')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (5,'Comedy')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (6,'Documentary')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (7,'Drama')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (8,'Family')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (9,'Foreign')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (10,'Games')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (11,'Horror')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (12,'Music')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (13,'New')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (14,'Sci-Fi')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (15,'Sports')
  INSERT INTO CATEGORIES$k (CATEGORY, CATEGORYNAME) VALUES (16,'Travel')
  GO

CREATE TABLE REORDER$k
  (
  PROD_ID INT NOT NULL,
  DATE_LOW DATETIME NOT NULL,
  QUAN_LOW INT NOT NULL,
  DATE_REORDERED DATETIME,
  QUAN_REORDERED INT,
  DATE_EXPECTED DATETIME
  )
  ON DS_MISC_FG
GO

-- This keeps the number of items with low QUAN_IN_STOCK constant so that the rollback rate is constant 
CREATE TRIGGER RESTOCK$k ON INVENTORY$k AFTER UPDATE
AS
  DECLARE \@changedPROD_ID INT, \@oldQUAN_IN_STOCK INT, \@newQUAN_IN_STOCK INT;
  IF UPDATE(QUAN_IN_STOCK)
    BEGIN
      SELECT \@changedPROD_ID = i.PROD_ID, \@oldQUAN_IN_STOCK = d.QUAN_IN_STOCK, \@newQUAN_IN_STOCK = i.QUAN_IN_STOCK
        FROM inserted i INNER JOIN deleted d ON i.PROD_ID = d.PROD_ID
      IF \@newQUAN_IN_STOCK < 3    -- assumes quantity ordered is 1, 2, or 3 - change if different
        BEGIN
          INSERT INTO REORDER$k
            (
            PROD_ID,
            DATE_LOW,
            QUAN_LOW
            )
          VALUES
            (
            \@changedPROD_ID,
            GETDATE(),
            \@newQUAN_IN_STOCK
            )
          UPDATE INVENTORY$k SET QUAN_IN_STOCK  = \@oldQUAN_IN_STOCK WHERE PROD_ID = \@changedPROD_ID
        END
    END
  RETURN
GO

DECLARE \@db_id int, \@tbl_id int
USE DS3
SET \@db_id = DB_ID('DS3')
SET \@tbl_id = OBJECT_ID('DS3..CATEGORIES$k')
DBCC PINTABLE (\@db_id, \@tbl_id)

SET \@db_id = DB_ID('DS3')
SET \@tbl_id = OBJECT_ID('DS3..PRODUCTS$k')
DBCC PINTABLE (\@db_id, \@tbl_id)
USE DS3
GO
\n";
  close $OUT;
  sleep(1);
  print ("sqlcmd -S $sqlservertarget -U sa -P password -i $sqlservertargetdir\\sqlserverds35_createtables.sql");
  system ("sqlcmd -S $sqlservertarget -U sa -P password -i $sqlservertargetdir\\sqlserverds35_createtables.sql");
  #system ("del $sqlservertargetdir\\sqlserverds35_createtables.sql");
  }
