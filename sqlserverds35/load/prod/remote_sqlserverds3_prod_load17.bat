bcp ds3..products17 in ..\..\..\data_files\prod\prod.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> prod17.log
time /T > finished17.txt
exit
