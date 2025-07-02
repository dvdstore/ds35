# remote_sqlserverds3_create_all_concurrent.sh
# start in ./ds3/sqlserverds3
# syntax is: remote_sqlserverds3_create_all_concurrent.sh <sqlserverdbtarget> <number of stores> <password>
# Assumes sqlcmd is in PATH.

TARGET=${1:-`hostname`}
STORES=${2:-1}
PASSWORD=${3:-password}

cd build
echo sqlcmd -C -S $TARGET -U sa -P $PASSWORD -i sqlserverds35_create_all_init_{DB_SIZE}.sql
sqlcmd -C -S $TARGET -U sa -P $PASSWORD -i sqlserverds35_create_all_init_{DB_SIZE}.sql
perl sqlserverds35_perl_create_db_tables_multi.pl $TARGET $STORES $PASSWORD

cd ../load
perl linux_ds35_create_sqlserver_multistore_load_files.pl $TARGET $STORES $PASSWORD
perl linux_ds35_execute_sqlserver_multistore_load.pl $TARGET $STORES $PASSWORD

cd ../build
sqlcmd -C -S $TARGET -U sa -P $PASSWORD -i sqlserverds35_shrinklog.sql
perl sqlserverds35_perl_create_indexes_multi.pl $TARGET $STORES $PASSWORD
perl sqlserverds35_perl_create_sp_multi.pl $TARGET $STORES $PASSWORD
sqlcmd -C -S $TARGET -U sa -P $PASSWORD -i sqlserverds35_create_user.sql

cd ..

