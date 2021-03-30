REM oracleds35_create_all_concurrent.bat
REM start in ./ds3/oracleds35
REM syntax is: oracleds35_create_all_concurrent.bat <oracledbtarget> <number of stores>
cd build
sqlplus "sys/oracle@%1 as sysdba" @oracleds35_prep_create_db.sql
sqlplus "sys/oracle@%1 as sysdba" @oracleds35_drop_tablespaces.sql
sqlplus "sys/oracle@%1 as sysdba" @oracleds3_create_tablespaces_10GB_10x.sql
perl oracleds3_perl_create_db_tables_multi.pl %1 %2
sqlplus "sys/oracle@%1 as sysdba" @oracleds3_create_datatypes.sql
cd ..\load
perl ds3_create_oracle_multistore_ctl_files.pl %1 %2
perl ds3_execute_oracle_multistore_sqlldr.pl %1 %2
sleep 60
cd ..\build
perl oracleds3_perl_create_seq_multi.pl %1 %2
perl oracleds3_perl_create_indexes_multi.pl %1 %2
perl oracleds3_perl_create_fulltextindex_multi.pl %1 %2
perl oracleds3_perl_create_sp_multi.pl %1 %2
perl oracleds3_perl_analyze_all_multi.pl %1 %2
cd ..

