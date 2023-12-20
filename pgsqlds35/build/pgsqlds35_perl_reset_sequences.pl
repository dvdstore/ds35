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

foreach my $k (1 .. $numStores){
        open(my $OUT, ">$pgsql_targetdir\\pgsqlds35_reset_seq.sql") || die("Can't open pgsqlds35_reset_seq.sql");
        print $OUT "-- Reset sequences

\\c ds3;



-- Reset Sequences after load

SELECT setval(CONCAT('categories$k','_category_seq'),max(category)) FROM categories$k;
SELECT setval(CONCAT('customers$k', '_customerid_seq'),max(customerid)) FROM customers$k;
SELECT setval(CONCAT('orders$k','_orderid_seq'),max(orderid)) FROM orders$k;
SELECT setval(CONCAT('products$k','_prod_id_seq'),max(prod_id)) FROM products$k;
SELECT setval(CONCAT('reviews$k','_review_id_seq'),max(review_id)) from reviews$k;
SELECT setval(CONCAT('reviews_helpfulness$k','_review_helpfulness_id_seq'),max(review_helpfulness_id)) from reviews_helpfulness$k;


\n";
        close $OUT;
        sleep(1);
        print("psql -h $pgsql_target -U $SYSDBA -d $DBNAME < $pgsql_targetdir\\pgsqlds35_reset_seq.sql\n");
        system("psql -h $pgsql_target -U $SYSDBA -d $DBNAME < $pgsql_targetdir\\pgsqlds35_reset_seq.sql");
}
