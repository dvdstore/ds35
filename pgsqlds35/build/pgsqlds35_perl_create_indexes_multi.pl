# pgsqlds35_perl_create_indexes_multi.pl
# Script to create a ds35 indexes in PostgresQL with a provided number of copies - supporting multiple stores
# Syntax to run - perl pgsqlds35_perl_create_indexes_multi.pl <psql_target> <number_of_stores>

use strict;
use warnings;

my $psqltarget = $ARGV[0];
my $numStores = $ARGV[1];

my $PGPASSWORD = "ds3";
my $SYSDBA = "ds3";
my $DBNAME= "ds3";

my $movecommand;
my $timecommand;
my $pathsep;

my @indexfiles;

# This section enables support for Linux and Windows - detecting the type of OS, and then using the proper commands
if ("$^O" eq "linux")
        {
        $movecommand = "mv";
        $timecommand = "date";
        $pathsep = "/";
        }
else
        {
        $movecommand = "move";
        $timecommand = "time /T";
        $pathsep = "\\\\";
        };


#Need seperate target directory so that mulitple DB Targets can be loaded at the same time
my $pgsql_targetdir;  

$pgsql_targetdir = $psqltarget;

# remove any backslashes from string to be used for directory name
$pgsql_targetdir =~ s/\\//;

system ("mkdir $pgsql_targetdir");

foreach my $k(1 .. $numStores){
	open (my $OUT, ">$pgsql_targetdir\\pgsqlds35_createindexes$k.sql") || die("Can't open pgsqlds35_createindexes$k.sql");
	print $OUT "-- Tables
\\c ds3;

CREATE UNIQUE INDEX IX_CUST_USERNAME$k ON CUSTOMERS$k
  (
  USERNAME
  );

CREATE UNIQUE INDEX IX_CUST_USER_PASSWORD$k ON CUSTOMERS$k
  (
  USERNAME,
  PASSWORD
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

CREATE INDEX IX_PROD_ACTOR$k ON PRODUCTS$k
USING GIN
  (
  to_tsvector('simple',ACTOR)
  );

CREATE INDEX IX_PROD_CATEGORY$k ON PRODUCTS$k
  (
  CATEGORY
  );

CREATE INDEX IX_PROD_TITLE$k ON PRODUCTS$k
USING GIN
  (
   to_tsvector('simple',TITLE)
  );

CREATE INDEX IX_PROD_SPECIAL$k ON PRODUCTS$k
  (
  SPECIAL
  );

CREATE INDEX IX_PROD_CAT_SPECIAL$k ON PRODUCTS$k
  (
  CATEGORY,
  SPECIAL
  );

CREATE INDEX IX_PROD_MEMBERSHIP$k ON PRODUCTS$k
  (
  MEMBERSHIP_ITEM
  )
  ;

CREATE INDEX IX_INV_PROD_ID$k ON INVENTORY$k
  (
  PROD_ID
  )
  ;

ALTER TABLE MEMBERSHIP$k
  ADD CONSTRAINT FK_MEMBERSHIP_CUSTID$k FOREIGN KEY (CUSTOMERID)
  REFERENCES CUSTOMERS$k (CUSTOMERID)
  ON DELETE CASCADE
  ;

ALTER TABLE REVIEWS$k
  ADD CONSTRAINT FK_PROD_ID$k FOREIGN KEY (PROD_ID)
  REFERENCES PRODUCTS$k (PROD_ID)
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
  )
  ;

CREATE INDEX IX_REVIEWS_STARS$k ON REVIEWS$k
  (
  STARS
  )
  ;

CREATE INDEX IX_REVIEWS_PRODSTARS$k ON REVIEWS$k
  (
  PROD_ID,STARS
  )
  ;

ALTER TABLE REVIEWS_HELPFULNESS$k
  ADD CONSTRAINT FK_REVIEW_ID$k FOREIGN KEY (REVIEW_ID)
    REFERENCES REVIEWS$k (REVIEW_ID)
        ON DELETE CASCADE
  ;

CREATE INDEX IX_REVIEWS_HELP_REVID$k ON REVIEWS_HELPFULNESS$k
  (
  REVIEW_ID
  )
  ;

CREATE INDEX IX_REVIEWS_HELP_CUSTID$k ON REVIEWS_HELPFULNESS$k
  (
  CUSTOMERID
  )
  ;

CREATE INDEX IX_REORDER_PRODID$k ON REORDER$k
  (
  PROD_ID
  )
  ;

\n";
	close $OUT;
	              
open (my $OUTBAT, ">$pgsql_targetdir\\pgsqlds35_createindexes$k.bat") || die("Can't open pgsqlds35_createindexes$k.bat");
		print $OUTBAT "set PGPASSWORD=ds3\n";
		print $OUTBAT "psql -h $psqltarget -U $SYSDBA -d $DBNAME < $pgsql_targetdir\\pgsqlds35_createindexes$k.sql\n";
        print $OUTBAT "$timecommand > $pgsql_targetdir\\finished$k.txt\n";
        print $OUTBAT "exit\n";
        close $OUTBAT;
}
sleep(1);

system ("del $pgsql_targetdir\\finished*.txt");
print "Load started at " .(localtime) , "\n";

foreach my $k (1 .. ($numStores)){
  print("psql -h $psqltarget -U $SYSDBA -d $DBNAME < $pgsql_targetdir\\pgsqlds35_createindexes$k.sql\n");
  system("start $pgsql_targetdir\\pgsqlds35_createindexes$k.bat ");
  }

my $num_finished = 0;

while ($num_finished < $numStores)
			{
			$num_finished =0;
			sleep(5);
			@indexfiles = glob("$pgsql_targetdir\\finished*.txt");                            # glob gets an array of all the finished*.txt files
																								   # The size of this array will tell us how many have finished
			
			$num_finished = $#indexfiles + 1;           #Compare size of array with number of stores being created, minus one due to array index starting at 0
			print "Num store indexes finished is $num_finished of $numStores \n";
			}

print "Load finished at ".(localtime), "\n";
		
sleep(5);

# Delete the finishedxx.txt files

system ("del $pgsql_targetdir\\finished*.txt");
	

