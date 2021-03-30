bcp ds3..products5 in ..\..\..\data_files\prod\prod.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> prod5.log
time /T > finished5.txt
exit
