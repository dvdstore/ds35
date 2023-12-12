# oracleds3_perl_create_fulltextindexes_multi.pl
# Script to create a ds3 fulltext indexes in oracle with a provided number of copies - supporting multiple stores
# Syntax to run - perl oracleds3_perl_create_fulltextindexes_multi.pl <oracle_target> <number_of_stores> 

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
	open (my $OUT, ">$oracletargetdir\\oracleds35_createfulltextindexes$k.sql") || die("Can't open oracleds35_fulltextindexes$k.sql");
	print $OUT "CREATE INDEX \"DS3\".\"IX_ACTOR_TEXT$k\" ON 
\"DS3\".\"PRODUCTS$k\"(actor) INDEXTYPE IS CTXSYS.CONTEXT
;

CREATE INDEX \"DS3\".\"IX_TITLE_TEXT$k\" ON
\"DS3\".\"PRODUCTS$k\"(title) INDEXTYPE IS CTXSYS.CONTEXT
;

exit;\n";
  close $OUT;
}

sleep (1);

foreach my $k (1 .. ($numberofstores-1)){
  system ("start sqlplus \"ds3/ds3\@$oracletarget\" \@$oracletargetdir\\oracleds35_createfulltextindexes$k.sql");
  }
  system ("sqlplus \"ds3/ds3\@$oracletarget\" \@$oracletargetdir\\oracleds35_createfulltextindexes$numberofstores.sql");
