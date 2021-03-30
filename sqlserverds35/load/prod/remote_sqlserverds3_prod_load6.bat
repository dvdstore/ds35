bcp ds3..products6 in ..\..\..\data_files\prod\prod.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> prod6.log
time /T > finished6.txt
exit
