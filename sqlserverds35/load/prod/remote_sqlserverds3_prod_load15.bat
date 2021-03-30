bcp ds3..products15 in ..\..\..\data_files\prod\prod.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> prod15.log
time /T > finished15.txt
exit
