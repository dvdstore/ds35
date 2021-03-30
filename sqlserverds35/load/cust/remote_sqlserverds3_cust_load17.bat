bcp ds3..customers17 in ..\..\..\data_files\cust\us_cust.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t , > us_cust17.log
bcp ds3..customers17 in ..\..\..\data_files\cust\row_cust.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t , > row_cust17.log
time /T > finished17.txt
exit
