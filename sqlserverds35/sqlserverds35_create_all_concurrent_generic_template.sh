# remote_sqlserverds3_create_all_concurrent.sh
# start in ./ds3/sqlserverds3
# syntax is: remote_sqlserverds3_create_all_concurrent.sh <sqlserverdbtarget> <number of stores>
# Assumes sqlcmd is in PATH.

TARGET=${1:-`hostname`}
PASSWORD=${2:-password}
STORES=${3:-1}

cd build
echo sqlcmd -C -S $TARGET -U sa -P $PASSWORD -i sqlserverds35_create_all_init_{DB_SIZE}.sql
sqlcmd -C -S $TARGET -U sa -P $PASSWORD -i sqlserverds35_create_all_init_{DB_SIZE}.sql
perl sqlserverds35_perl_create_db_tables_multi.pl $TARGET $PASSWORD $STORES

cd ../load
perl linux_ds35_create_sqlserver_multistore_load_files.pl $TARGET $PASSWORD $STORES
perl linux_ds35_execute_sqlserver_multistore_load.pl $TARGET $PASSWORD $STORES

cd ../build
sqlcmd -C -S $TARGET -U sa -P $PASSWORD -i sqlserverds35_shrinklog.sql
perl sqlserverds35_perl_create_indexes_multi.pl $TARGET $PASSWORD $STORES
perl sqlserverds35_perl_create_sp_multi.pl $TARGET $PASSWORD $STORES
sqlcmd -C -S $TARGET -U sa -P $PASSWORD -i sqlserverds35_create_user.sql

cd ..

