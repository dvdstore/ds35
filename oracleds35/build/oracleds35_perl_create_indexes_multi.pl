# oracleds3_perl_create_indexes_multi.pl
# Script to create a ds3 indexes in oracle with a provided number of copies - supporting multiple stores
# Syntax to run - perl oracleds3_perl_create_indexes_multi.pl <oracle_target> <number_of_stores> 

use strict;
use warnings;

my $oracletarget = $ARGV [0];
my $numberofstores = $ARGV[1];

#Need seperate target directory so that mulitple DB Targets can be loaded at the same time
my $oracletargetdir;  

$oracletargetdir = $oracletarget;

# remove any backslashes from string to be used for directory name
$oracletargetdir =~ s/\\//;

system ("mkdir $oracletargetdir");


foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">$oracletargetdir\\oracleds35_createindexes$k.sql") || die("Can't open oracleds35_indexes$k.sql");
	print $OUT "CREATE UNIQUE INDEX \"DS3\".\"PK_CUSTOMERS$k\" 
  ON \"DS3\".\"CUSTOMERS$k\"  (\"CUSTOMERID\")
  PARALLEL ( DEGREE DEFAULT )
  TABLESPACE \"INDXTBS\" 
  ;

ALTER TABLE \"DS3\".\"CUSTOMERS$k\" 
  ADD (CONSTRAINT \"PK_CUSTOMERS$k\" PRIMARY KEY(\"CUSTOMERID\"))
  ; 

CREATE UNIQUE INDEX \"DS3\".\"IX_CUST_USERNAME$k\" 
  ON \"DS3\".\"CUSTOMERS$k\"  (\"USERNAME\") 
  PARALLEL ( DEGREE DEFAULT )
  TABLESPACE \"INDXTBS\" 
  ;

CREATE INDEX \"DS3\".\"PK_CUST_HIST$k\"
  ON \"DS3\".\"CUST_HIST$k\" (\"CUSTOMERID\")
  PARALLEL ( DEGREE DEFAULT )
  TABLESPACE \"INDXTBS\"
  ;

ALTER TABLE \"DS3\".\"CUST_HIST$k\"
  ADD (CONSTRAINT \"FK_CUST_HIST_CUSTOMERID$k\" FOREIGN KEY (\"CUSTOMERID\")
  REFERENCES \"DS3\".\"CUSTOMERS$k\" (\"CUSTOMERID\")
  ON DELETE CASCADE)
  ;

CREATE UNIQUE INDEX \"DS3\".\"PK_ORDERS$k\"
  ON \"DS3\".\"ORDERS$k\"  (\"ORDERID\")
  GLOBAL PARTITION BY HASH (\"ORDERID\")
  PARTITIONS 8 STORE IN (\"INDXTBS\")
  PARALLEL ( DEGREE DEFAULT )
  TABLESPACE \"INDXTBS\"
  ;

ALTER TABLE \"DS3\".\"ORDERS$k\"
  ADD (CONSTRAINT \"PK_ORDERS$k\" PRIMARY KEY(\"ORDERID\"))
  ;

ALTER TABLE \"DS3\".\"ORDERS$k\"
  ADD (CONSTRAINT \"FK_CUSTOMERID$k\" FOREIGN KEY(\"CUSTOMERID\")
    REFERENCES \"DS3\".\"CUSTOMERS$k\"(\"CUSTOMERID\")
    ON DELETE SET NULL)
  ;

CREATE UNIQUE INDEX \"DS3\".\"PK_ORDERLINES$k\"
  ON \"DS3\".\"ORDERLINES$k\"  (\"ORDERID\", \"ORDERLINEID\")
  GLOBAL PARTITION BY HASH (\"ORDERID\",\"ORDERLINEID\")
  PARTITIONS 8 STORE IN (\"INDXTBS\")
  PARALLEL ( DEGREE DEFAULT )
  TABLESPACE \"INDXTBS\"
  ;
ALTER TABLE \"DS3\".\"ORDERLINES$k\"
  ADD (CONSTRAINT \"PK_ORDERLINES$k\" PRIMARY KEY(\"ORDERID\", \"ORDERLINEID\"))
  ;

ALTER TABLE \"DS3\".\"ORDERLINES$k\"
  ADD (CONSTRAINT \"FK_ORDERID$k\" FOREIGN KEY(\"ORDERID\")
    REFERENCES \"DS3\".\"ORDERS$k\"(\"ORDERID\"))
  ;

CREATE UNIQUE INDEX \"DS3\".\"PK_PROD_ID$k\" 
  ON \"DS3\".\"PRODUCTS$k\"  (\"PROD_ID\")
  PARALLEL ( DEGREE DEFAULT )
  TABLESPACE \"INDXTBS\" 
  ;

ALTER TABLE \"DS3\".\"PRODUCTS$k\" 
  ADD (CONSTRAINT \"PK_PROD_ID$k\" PRIMARY KEY(\"PROD_ID\"))
  ; 

CREATE INDEX \"DS3\".\"IX_PROD_CATEGORY$k\"
  ON \"DS3\".\"PRODUCTS$k\"  (\"CATEGORY\")
  TABLESPACE \"INDXTBS\" 
  ;

CREATE INDEX \"DS3\".\"IX_PROD_SPECIAL$k\"
  ON \"DS3\".\"PRODUCTS$k\"  (\"SPECIAL\")
  TABLESPACE \"INDXTBS\" 
  ;

CREATE INDEX \"DS3\".\"IX_PROD_MEMBERSHIP$k\"
  ON \"DS3\".\"PRODUCTS$k\"  (\"MEMBERSHIP_ITEM\")
  TABLESPACE \"INDXTBS\"
  ;

CREATE INDEX \"DS3\".\"IX_INV_PROD_ID$k\" 
  ON \"DS3\".\"INVENTORY$k\"  (\"PROD_ID\") 
  TABLESPACE \"INDXTBS\"
  ;

CREATE UNIQUE INDEX \"DS3\".\"PK_MEMBERSHIP$k\"
  ON \"DS3\".\"MEMBERSHIP$k\"  (\"CUSTOMERID\")
  PARALLEL ( DEGREE DEFAULT )
  TABLESPACE \"INDXTBS\"
  ;

ALTER TABLE \"DS3\".\"MEMBERSHIP$k\"
  ADD (CONSTRAINT \"PK_MEMBERSHIP$k\" PRIMARY KEY(\"CUSTOMERID\"))
  ;

ALTER TABLE \"DS3\".\"MEMBERSHIP$k\"
  ADD (CONSTRAINT \"FK_MEMBERSHIP_CUSTID$k\" FOREIGN KEY(\"CUSTOMERID\")
    REFERENCES \"DS3\".\"CUSTOMERS$k\"(\"CUSTOMERID\"))
  ;

CREATE UNIQUE INDEX \"DS3\".\"PK_REVIEWS$k\"
  ON \"DS3\".\"REVIEWS$k\"  (\"REVIEW_ID\")
  PARALLEL ( DEGREE DEFAULT )
  TABLESPACE \"INDXTBS\"
  ;

ALTER TABLE \"DS3\".\"REVIEWS$k\"
  ADD (CONSTRAINT \"PK_REVIEWS$k\" PRIMARY KEY(\"REVIEW_ID\"))
  ;

ALTER TABLE \"DS3\".\"REVIEWS$k\"
  ADD (CONSTRAINT \"FK_PROD_ID$k\" FOREIGN KEY(\"PROD_ID\")
    REFERENCES \"DS3\".\"PRODUCTS$k\"(\"PROD_ID\"))
  ;

ALTER TABLE \"DS3\".\"REVIEWS$k\"
  ADD (CONSTRAINT \"FK_REVIEW_CUSTOMERID$k\" FOREIGN KEY(\"CUSTOMERID\")
    REFERENCES \"DS3\".\"CUSTOMERS$k\"(\"CUSTOMERID\"))
  ;

CREATE INDEX \"DS3\".\"IX_REVIEWS_PROD_ID$k\"
  ON \"DS3\".\"REVIEWS$k\"  (\"PROD_ID\")
  TABLESPACE \"INDXTBS\"
  ;

CREATE INDEX \"DS3\".\"IX_REVIEWS_STARS$k\"
  ON \"DS3\".\"REVIEWS$k\"  (\"STARS\")
  TABLESPACE \"INDXTBS\"
  ;

CREATE INDEX \"DS3\".\"IX_REVIEWS_PRODSTARS$k\"
  ON \"DS3\".\"REVIEWS$k\" (\"PROD_ID\",\"STARS\")
  TABLESPACE \"INDXTBS\"
  ;

CREATE UNIQUE INDEX \"DS3\".\"PK_REVIEWS_HELPFULNESS$k\"
  ON \"DS3\".\"REVIEWS_HELPFULNESS$k\"  (\"REVIEW_HELPFULNESS_ID\")
  PARALLEL ( DEGREE DEFAULT )
  TABLESPACE \"INDXTBS\"
  ;

ALTER TABLE \"DS3\".\"REVIEWS_HELPFULNESS$k\"
  ADD (CONSTRAINT \"PK_REVIEWS_HELPFULNESS$k\" PRIMARY KEY(\"REVIEW_HELPFULNESS_ID\"))
  ;

ALTER TABLE \"DS3\".\"REVIEWS_HELPFULNESS$k\"
  ADD (CONSTRAINT \"FK_REVIEW_ID$k\" FOREIGN KEY(\"REVIEW_ID\")
    REFERENCES \"DS3\".\"REVIEWS$k\"(\"REVIEW_ID\"))
  ;

CREATE INDEX \"DS3\".\"IX_REVIEWS_HELP_REVID$k\"
  ON \"DS3\".\"REVIEWS_HELPFULNESS$k\"  (\"REVIEW_ID\")
  TABLESPACE \"INDXTBS\"
  ;

CREATE INDEX \"DS3\".\"IX_REVIEWS_HELP_CUSTID$k\"
  ON \"DS3\".\"REVIEWS_HELPFULNESS$k\"  (\"CUSTOMERID\")
  TABLESPACE \"INDXTBS\"
  ;

CREATE INDEX \"DS3\".\"IX_REORDER_PRODID$k\"
  ON \"DS3\".\"REORDER$k\" (\"PROD_ID\")
  TABLESPACE \"INDXTBS\"
  ;


EXIT;
  \n";
  close $OUT;
  }
  
sleep(1);
  
foreach my $k (1 .. ($numberofstores-1)){
  system ("start sqlplus \"ds3/ds3\@$oracletarget \" \@$oracletargetdir\\oracleds35_createindexes$k.sql");
  }
  system ("sqlplus \"ds3/ds3\@$oracletarget \" \@$oracletargetdir\\oracleds35_createindexes$numberofstores.sql");
