#!/bin/sh
cd build
sqlplus "sys/oracle@%1 as sysdba" @oracleds35_prep_create_db.sql
sqlplus "sys/oracle@%1 as sysdba" @oracleds35_drop_tablespaces.sql
sqlplus "sys/oracle@%1 as sysdba" @{TBLSPACE_SQLFNAME}
perl {CREATEDB_SQLFNAME} $1 $2
sqlplus "sys/oracle@%1 as sysdba" @oracleds35_create_datatypes.sql
cd ../load
perl ds35_create_oracle_multistore_ctl_files.pl $1 $2
perl ds35_execute_oracle_multistore_sqlldr.pl $1 $2
sleep 60
cd ../build
perl oracleds35_perl_create_seq_multi.pl $1 $2
perl oracleds35_perl_create_indexes_multi.pl $1 $2
perl oracleds35_perl_create_fulltextindex_multi.pl $1 $2
perl oracleds35_perl_create_sp_multi.pl $1 $2
perl oracleds35_perl_analyze_all_multi.pl $1 $2
cd ..

