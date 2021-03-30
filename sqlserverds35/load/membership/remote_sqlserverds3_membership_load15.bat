bcp ds3..membership15 in ..\..\..\data_files\membership\membership.csv -b 10000 -h TABLOCK -S 10.10.100.51 -U sa -P password -c -t ,> membership15.log
time /T > finished15.txt
exit
