REM remote_sqlserverds3_create_all_concurrent.bat
REM start in ./ds3/sqlserverds3
REM syntax is: remote_sqlserverds3_create_all_concurrent.bat <sqlserverdbtarget> <number of stores>
cd build
sqlcmd -S %1 -U sa -P password -i sqlserverds3_create_all_init.sql
perl sqlserverds3_perl_create_db_tables_multi.pl %1 %2
cd ..\load
perl ds3_create_sqlserver_multistore_load_files.pl %1 %2
perl ds3_execute_sqlserver_multistore_load.pl %1 %2
cd ..\
sleep 60
cd build
sqlcmd -S %1 -U sa -P password -i sqlserverds3_shrinklog.sql
perl sqlserverds3_perl_create_indexes_multi.pl %1 %2
perl sqlserverds3_perl_create_sp_multi.pl %1 %2
sqlcmd -S %1 -U sa -P password -i sqlserverds3_create_user.sql
REM perl oracleds3_perl_analyze_all_multi.pl %1 %2
cd ..

