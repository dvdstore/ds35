bcp ds3..products3 in ..\..\..\data_files\prod\prod.csv -b 10000 -h TABLOCK -S 10.10.100.55\TWO -U sa -P password -c -t ,> prod3.log
time /T > finished3.txt
exit
