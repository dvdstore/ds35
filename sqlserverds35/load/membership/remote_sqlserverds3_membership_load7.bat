bcp ds3..membership7 in ..\..\..\data_files\membership\membership.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> membership7.log
time /T > finished7.txt
exit
