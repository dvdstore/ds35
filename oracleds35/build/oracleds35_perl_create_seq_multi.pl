# oracleds35_perl_create_seq_multi.pl
# Script to create a DS3 sequences script that will create seqences for Reviews and Reviews Helpfulness tables - supporting multiple stores
# Syntax to run - perl oracleds35_perl_create_seq_multi.pl <oracle_target> <number_of_stores> 

use strict;
use warnings;

my $oracletarget = $ARGV [0];
my $numberofstores = $ARGV[1];


foreach my $k (1 .. $numberofstores){
	open (my $OUT, ">oracleds35_createseq$k.sql") || die("Can't open oracleds35_createseq$k.sql");
	print $OUT "DECLARE 
  REVIEW_ROWS$k NUMBER;
  HELP_ROWS$k NUMBER;

BEGIN

  SELECT count(*) INTO REVIEW_ROWS$k  from \"DS3\".\"REVIEWS$k\";

REVIEW_ROWS$k := REVIEW_ROWS$k + 1;

EXECUTE IMMEDIATE '
CREATE SEQUENCE \"DS3\".\"REVIEWID_SEQ$k\"
  INCREMENT BY 1
  START WITH ' || REVIEW_ROWS$k || '
  MAXVALUE 1.0E28
  MINVALUE 1
  NOCYCLE
  CACHE 100000
  NOORDER'
  ;

  SELECT count(*) INTO HELP_ROWS$k  from \"DS3\".\"REVIEWS_HELPFULNESS$k\";

HELP_ROWS$k := HELP_ROWS$k + 1;

EXECUTE IMMEDIATE '
CREATE SEQUENCE \"DS3\".\"REVIEWHELPFULNESSID_SEQ$k\"
  INCREMENT BY 1
  START WITH ' || HELP_ROWS$k || '
  MAXVALUE 1.0E28
  MINVALUE 1
  NOCYCLE
  CACHE 100000
  NOORDER'
  ;
END;
/
EXIT;
\n";
close $OUT;
  
 }
  
sleep(1);

foreach my $k (1 .. ($numberofstores-1)){
  system ("start sqlplus \"sys/oracle\@$oracletarget as sysdba \" \@oracleds35_createseq$k.sql");
  }
  system ("sqlplus \"sys/oracle\@$oracletarget as sysdba \" \@oracleds35_createseq$numberofstores.sql");