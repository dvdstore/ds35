bcp ds3..membership17 in ..\..\..\data_files\membership\membership.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> membership17.log
time /T > finished17.txt
exit
