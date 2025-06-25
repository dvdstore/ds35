# mysqlds35_create_all.sh
# Syntax to run - sh mysqlds35_create_all.sh <mysql_target> <number_of_stores>
# start in ./ds35/mysqlds35

TARGET=${1:-`hostname`}
STORES=${2:-1}

cd build
perl mysqlds35_perl_create_db_tables_multi.pl $TARGET $STORES
perl mysqlds35_perl_create_indexes_multi.pl $TARGET $STORES
perl mysqlds35_perl_create_sp_multi.pl $TARGET $STORES
perl mysqlds35_perl_create_trigger_multi.pl $TARGET $STORES
cd ../load/
perl ds35_create_mysql_multistore_load_files.pl $TARGET $STORES
perl ds35_execute_mysql_multistore_load.pl $TARGET $STORES
cd ../
