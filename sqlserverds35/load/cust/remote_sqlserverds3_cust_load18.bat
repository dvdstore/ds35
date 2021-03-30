bcp ds3..customers18 in ..\..\..\data_files\cust\us_cust.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t , > us_cust18.log
bcp ds3..customers18 in ..\..\..\data_files\cust\row_cust.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t , > row_cust18.log
time /T > finished18.txt
exit
