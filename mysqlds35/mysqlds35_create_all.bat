REM mysqlds35_create_all.bat
REM Syntax to run - mysqlds35_create_all.bat <mysql_target> <number_of_stores>
REM start in ./ds35/mysqlds35
cd build
perl mysqlds35_perl_create_db_tables_multi.pl %1 %2
perl mysqlds35_perl_create_indexes_multi.pl %1 %2
perl mysqlds35_perl_create_sp_multi.pl %1 %2
cd ../load/
perl ds35_create_mysql_multistore_load_files.pl %1 %2
perl ds35_execute_mysql_multistore_load.pl %1 %2
cd ..
