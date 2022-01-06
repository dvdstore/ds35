use strict;
use warnings;

my $pgsql_target = $ARGV[0];
my $numStores = $ARGV[1];
my $DBNAME = "ds3";
my $SYSDBA = "ds3";
my $PGPASSWORD = "ds3";



foreach my $k (1 .. $numStores){
        open(my $OUT, ">pgsqlds35_createtriggers.sql") || die("Can't open pgsqlds35_createtriggers.sql");
        print $OUT "-- Triggers

\\c ds3;







CREATE OR REPLACE FUNCTION RESTOCK_ORDER$k()
RETURNS TRIGGER
LANGUAGE plpgsql
AS \$RESTOCK_ORDER\$
DECLARE
  restockto INTEGER;
BEGIN
  IF ( NEW.QUAN_IN_STOCK < 3) THEN
    restockto = 250;
    IF ( ( NEW.PROD_ID +1) % 10000 = 0 ) THEN
      restockto = 2500;
    END IF;
    INSERT INTO REORDER$k ( PROD_ID, DATE_LOW, QUAN_LOW)
    VALUES ( NEW.PROD_ID, current_timestamp , restockto - NEW.QUAN_IN_STOCK);
    NEW.QUAN_IN_STOCK = restockto;
    -- UPDATE INVENTORY$k SET QUAN_IN_STOCK = OLD.QUAN_IN_STOCK WHERE PROD_ID = NEW.PROD_ID;
  END IF;
RETURN NEW;
END;
\$RESTOCK_ORDER\$;

CREATE TRIGGER RESTOCK$k BEFORE UPDATE ON INVENTORY$k
FOR EACH ROW
WHEN (OLD.QUAN_IN_STOCK IS DISTINCT FROM NEW.QUAN_IN_STOCK )
EXECUTE PROCEDURE  RESTOCK_ORDER$k();


\n";


close $OUT;
        sleep(1);
        print("psql -h $pgsql_target -U $SYSDBA -d $DBNAME < pgsqlds35_createtriggers.sql\n");
        system("psql -h $pgsql_target -U $SYSDBA -d $DBNAME < pgsqlds35_createtriggers.sql");
}



