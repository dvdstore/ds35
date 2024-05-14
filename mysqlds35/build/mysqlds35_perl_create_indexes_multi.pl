# mysqlds3_perl_create_indexes_multi.pl
# Script to create a ds35 indexes in MySQL with a provided number of copies - supporting multiple stores
# Syntax to run - perl mysqlds3_perl_create_indexes_multi.pl <mysql_target> <number_of_stores> 

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

foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">$mysql_targetdir\\mysqlds35_createindexes.sql") || die("Can't open $mysql_targetdir\\mysqlds35_createindexes.sql");
	print $OUT  "-- Tables
USE DS3;

CREATE UNIQUE INDEX IX_CUST_USERNAME$k ON CUSTOMERS$k 
  (
  USERNAME
  );

CREATE INDEX IX_CUST_HIST_CUSTOMERID$k ON CUST_HIST$k
  (
  CUSTOMERID
  );

ALTER TABLE CUST_HIST$k
  ADD CONSTRAINT FK_CUST_HIST_CUSTOMERID$k FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS$k (CUSTOMERID)
  ON DELETE CASCADE
  ;

CREATE INDEX IX_ORDER_CUSTID$k ON ORDERS$k
  (
  CUSTOMERID
  );

ALTER TABLE ORDERS$k 
  ADD CONSTRAINT FK_CUSTOMERID$k FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS$k (CUSTOMERID)
  ON DELETE SET NULL
  ;

CREATE UNIQUE INDEX IX_ORDERLINES_ORDERID$k ON ORDERLINES$k
  (
  ORDERID, ORDERLINEID
  );

ALTER TABLE ORDERLINES$k
  ADD CONSTRAINT FK_ORDERID$k FOREIGN KEY (ORDERID)
  REFERENCES ORDERS$k (ORDERID)
  ON DELETE CASCADE
  ;

CREATE FULLTEXT INDEX IX_PROD_ACTOR$k ON PRODUCTS$k 
  (
  ACTOR
  );

CREATE INDEX IX_PROD_CATEGORY$k ON PRODUCTS$k
  (
  CATEGORY
  );

CREATE FULLTEXT INDEX IX_PROD_TITLE$k ON PRODUCTS$k
  (
  TITLE
  );

CREATE INDEX IX_PROD_SPECIAL$k ON PRODUCTS$k 
  (
  SPECIAL
  );

ALTER TABLE MEMBERSHIP$k
  ADD CONSTRAINT FK_MEMBERSHIP_CUSTID$k FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS$k (CUSTOMERID)
  ON DELETE CASCADE
  ;

ALTER TABLE REVIEWS$k
  ADD CONSTRAINT FK_REVIEW_CUSTOMERID$k FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS$k (CUSTOMERID)
  ON DELETE CASCADE
  ;

CREATE INDEX IX_REVIEWS_PROD_ID$k ON REVIEWS$k
  (
  PROD_ID
  );

CREATE INDEX IX_REVIEWS_STARS$k on REVIEWS$k
  (
  STARS
  );

CREATE INDEX IX_REVIEWS_PRODSTARS$k on REVIEWS$k
  (
  PROD_ID,
  STARS
  );

ALTER TABLE REVIEWS_HELPFULNESS$k
  ADD CONSTRAINT FK_REVIEW_ID$k FOREIGN KEY (REVIEW_ID)
  REFERENCES REVIEWS$k (REVIEW_ID)
  ON DELETE CASCADE
  ;

CREATE INDEX IX_REVIEWS_HELP_REVID$k on REVIEWS_HELPFULNESS$k
  (
  REVIEW_ID
  );

CREATE INDEX IX_CUST_HIST_CUSTOMERID_PRODID$k ON CUST_HIST$k
   (
   CUSTOMERID ,
   PROD_ID
   );


CREATE INDEX IX_REVIEWS_HELP_CUSTID$k on REVIEWS_HELPFULNESS$k
  (
  CUSTOMERID
  );

CREATE INDEX IX_PROD_PRODID_COMMON$k ON PRODUCTS$k
  (
  PROD_ID,
  COMMON_PROD_ID
  );

CREATE INDEX IX_REVIEW_HELP_ID_HELPID$k ON REVIEWS_HELPFULNESS$k
  (
  REVIEW_ID,
  REVIEWS_HELPFULNESS_ID
  );

CREATE INDEX IX_REVIEWS_PRODID_REVID_DATE$k ON REVIEWS$k
  (
  PROD_ID,
  REVIEW_ID,
  REVIEW_DATE
  );


CREATE INDEX IX_REORDER_PRODID$k on REORDER$k
  (
  PROD_ID
  );
\n";
  close $OUT;
  sleep(1);
  print ("mysql -h $mysqltarget -u web --password=web < $mysql_targetdir\\mysqlds35_createindexes.sql");
  system ("mysql -h $mysqltarget -u web --password=web < $mysql_targetdir\\mysqlds35_createindexes.sql");
  #system ("del $mysql_targetdir\\mysqlds35_createindexes.sql");
  }
