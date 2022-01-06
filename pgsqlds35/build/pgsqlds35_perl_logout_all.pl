use strict;
use warnings;

my $pgsql_target = $ARGV[0];
my $DBNAME = "ds3";
my $SYSDBA = "ds3";


open(my $OUT, ">pgsqlds35_logout_all.sql") || die("Can't open pgsqlds35_logout_all.sql");

print $OUT "--logging out all users

SELECT pid, pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname='ds3' AND pid <> pg_backend_pid();

\n";

close $OUT;
sleep(1);
print("psql -h $pgsql_target -U postgres -d $DBNAME < pgsqlds35_logout_all.sql\n");
system("psql -h $pgsql_target -U postgres -d $DBNAME < pgsqlds35_logout_all.sql");
