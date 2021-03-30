bcp ds3..customers1 in ..\..\..\data_files\cust\us_cust.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > us_cust1.log
bcp ds3..customers1 in ..\..\..\data_files\cust\row_cust.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t , > row_cust1.log
time /T > finished1.txt
exit
