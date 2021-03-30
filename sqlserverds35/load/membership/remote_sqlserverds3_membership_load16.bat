bcp ds3..membership16 in ..\..\..\data_files\membership\membership.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> membership16.log
time /T > finished16.txt
exit
