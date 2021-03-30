#!/bin/sh
sqlplus ds3/ds3 @oracleds35_cleanup_3GB_fk_disabled.sql
sqlldr ds3/ds3 CONTROL=../load/prod/inv.ctl, LOG=inv.log, BAD=inv.bad, DATA=../../data_files/prod/inv.csv 
